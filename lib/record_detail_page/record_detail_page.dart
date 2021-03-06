import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../edit_record_page/edit_record_page.dart';
import '../model/exam_record.dart';
import '../model/problem.dart';
import '../model/subject.dart';
import '../repository/exam_record_repository.dart';
import '../review_problem_detail_page/review_problem_detail_page.dart';
import '../save_image_page/save_image_page.dart';
import '../util/material_hero.dart';
import '../util/menu_bar.dart';
import '../util/progress_overlay.dart';
import '../util/review_problem_card.dart';

class RecordDetailPage extends StatefulWidget {
  static const routeName = '/record_detail';
  final RecordDetailPageArguments arguments;

  const RecordDetailPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late ExamRecord _record;
  final ExamRecordRepository _recordRepository = ExamRecordRepository();
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _record = widget.arguments.record;
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressOverlay(
        isProgressing: _isDeleting,
        description: '삭제하는 중',
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuBar(
                actionButtons: [
                  ActionButton(
                    icon: const Icon(Icons.image),
                    tooltip: '이미지 저장',
                    onPressed: _onSaveImageButtonPressed,
                  ),
                  ActionButton(
                    icon: const Icon(Icons.edit),
                    tooltip: '수정',
                    onPressed: _onEditButtonPressed,
                  ),
                  ActionButton(
                    icon: const Icon(Icons.delete),
                    tooltip: '삭제',
                    onPressed: _onDeleteButtonPressed,
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildContent(),
                        ),
                      ),
                    ),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withAlpha(0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 0.7,
                color: Color(_record.getGradeColor()),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: _buildTitle(),
              ),
            ],
          ),
        ),
        if (_record.score != null || _record.grade != null || _record.examDurationMinutes != null)
          Column(
            children: [
              const SizedBox(height: 32),
              _buildScoreBoard(),
              const SizedBox(height: 8),
            ],
          ),
        if (_record.wrongProblems.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSubTitle('틀린 문제'),
              Wrap(
                spacing: 8,
                runSpacing: -8,
                children: [
                  for (final wrongProblem in _record.wrongProblems)
                    Chip(
                      label: Text('${wrongProblem.problemNumber}번'),
                      backgroundColor: Theme.of(context).primaryColor,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        if (_record.feedback.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSubTitle('피드백'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _record.feedback,
                  style: const TextStyle(height: 1.2),
                ),
              ),
            ],
          ),
        if (_record.reviewProblems.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSubTitle('복습할 문제'),
              const SizedBox(height: 8),
              GridView.extent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final problem in _record.reviewProblems)
                    ReviewProblemCard(
                      problem: problem,
                      onTap: () => _onReviewProblemCardTap(problem),
                    ),
                ],
              )
            ],
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MaterialHero(
          tag: 'time ${_record.hashCode}',
          child: Text(
            DateFormat.yMEd('ko_KR').add_Hm().format(_record.examStartedTime),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: MaterialHero(
                  tag: 'title ${_record.hashCode}',
                  child: Text(
                    _record.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              MaterialHero(
                tag: 'subject ${_record.hashCode}',
                child: Text(
                  _record.subject.subjectName,
                  style: TextStyle(
                    color: Color(_record.subject.firstColor),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBoard() {
    int? score = _record.score;
    int? grade = _record.grade;
    int? examDurationMinutes = _record.examDurationMinutes;

    final List<Widget> scoreItems = [
      if (score != null) _buildScoreItem('점수', score),
      if (grade != null) _buildScoreItem('등급', grade),
      if (examDurationMinutes != null) _buildScoreItem('시험 시간', examDurationMinutes),
    ];

    const divider = VerticalDivider(indent: 6, endIndent: 6);
    if (scoreItems.length == 3) {
      scoreItems.insert(2, divider);
      scoreItems.insert(1, divider);
    }
    if (scoreItems.length == 2) {
      scoreItems.insert(1, divider);
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: scoreItems,
      ),
    );
  }

  Widget _buildScoreItem(String title, int value) {
    return Column(
      children: [
        _buildSubTitle(title),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  void _refresh() async {
    _record = await _recordRepository.getExamRecordById(_record.documentId);
    setState(() {});
  }

  void _onSaveImageButtonPressed() async {
    final arguments = SaveImagePageArguments(recordToSave: _record);
    await Navigator.pushNamed(context, SaveImagePage.routeName, arguments: arguments);
  }

  void _onEditButtonPressed() async {
    final arguments = EditRecordPageArguments(recordToEdit: _record);
    await Navigator.pushNamed(context, EditRecordPage.routeName, arguments: arguments);
    _refresh();
  }

  void _onDeleteButtonPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '정말 이 기록을 삭제하실 건가요?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(_record.title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(primary: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteRecord();
              },
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
              style: TextButton.styleFrom(primary: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord() async {
    setState(() {
      _isDeleting = true;
    });
    await _recordRepository.deleteExamRecord(_record);
    Navigator.pop(context);
  }

  void _onReviewProblemCardTap(ReviewProblem problem) {
    final arguments = ReviewProblemDetailPageArguments(problem: problem);
    Navigator.pushNamed(context, ReviewProblemDetailPage.routeName, arguments: arguments);
  }
}

class RecordDetailPageArguments {
  final ExamRecord record;

  RecordDetailPageArguments({required this.record});
}
