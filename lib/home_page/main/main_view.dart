import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:silgam/util/const.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../clock_page/clock_page.dart';
import '../../edit_record_page/edit_record_page.dart';
import '../../login_page/login_page.dart';
import '../../model/ads.dart';
import '../../model/exam.dart';
import '../../repository/ads_repository.dart';
import '../../repository/dday_repository.dart';
import '../../repository/exam_repository.dart';
import '../../repository/user_repository.dart';
import '../settings/noise_setting_page.dart';

part 'ads_card.dart';
part 'button_card.dart';
part 'card.dart';
part 'd_days_card.dart';
part 'exam_start_card.dart';
part 'welcome_messages.dart';

class MainView extends StatefulWidget {
  static const title = '메인';
  final Function() navigateToRecordTab;

  const MainView({
    Key? key,
    required this.navigateToRecordTab,
  }) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final DateTime today = DateTime.now();
  late final List<DDayItem> dDayItems = DDayRepository().getItemsToShow(today);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTitle(),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _welcomeMessages[Random().nextInt(_welcomeMessages.length)],
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Divider(indent: 20, endIndent: 20),
              FutureBuilder(
                future: AdsRepository().getAllAds(),
                builder: (_, AsyncSnapshot<List<Ads>> snapshot) {
                  final List<Ads> data = snapshot.data ?? [];
                  if (data.isNotEmpty) {
                    return AdsCard(ads: data);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              _DDaysCard(dDayItems: dDayItems),
              _ExamStartCard(navigateToRecordTab: widget.navigateToRecordTab),
              if (UserRepository().isNotSignedIn())
                _ButtonCard(
                  onTap: _onLoginButtonTap,
                  iconData: Icons.login,
                  title: '간편로그인하고 더 많은 기능 이용하기',
                  primary: true,
                ),
              _ButtonCard(
                onTap: _onNoiseSettingButtonTap,
                iconData: Icons.graphic_eq,
                title: '백색 소음, 시험장 소음 설정하기',
              ),
              _ButtonCard(
                onTap: _onRecordButtonTap,
                iconData: Icons.edit,
                title: '모의고사 기록하고 피드백하기',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Text(
          DateFormat.MMMMEEEEd('ko_KR').format(today),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
        _buildSnsButton(snsName: "instagram", tooltip: '실감 인스타그램', url: urlInstagram),
        _buildSnsButton(snsName: "facebook", tooltip: '실감 페이스북', url: urlFacebook),
        _buildSnsButton(snsName: "kakaotalk", tooltip: '카카오톡으로 문의하기', url: urlKakaotalk),
      ],
    );
  }

  Widget _buildSnsButton({required String snsName, required String tooltip, required String url}) {
    return IconButton(
      onPressed: () => launch(url),
      splashRadius: 20,
      tooltip: tooltip,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      icon: SvgPicture.asset(
        'assets/sns_$snsName.svg',
        color: Colors.grey,
        width: 20,
      ),
    );
  }

  void _onLoginButtonTap() {
    Navigator.pushNamed(context, LoginPage.routeName);
  }

  void _onNoiseSettingButtonTap() {
    Navigator.pushNamed(context, NoiseSettingPage.routeName);
  }

  void _onRecordButtonTap() async {
    if (UserRepository().isSignedIn()) {
      await Navigator.pushNamed(context, EditRecordPage.routeName, arguments: EditRecordPageArguments());
    }
    widget.navigateToRecordTab();
  }
}
