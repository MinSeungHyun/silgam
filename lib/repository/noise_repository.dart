import 'dart:math';

import '../util/shared_preferences_holder.dart';

enum NoisePreset { disabled, easy, normal, hard, custom }

class Noise {
  static const int maxLevel = 20;
  final int id;
  final String name;
  final String preferenceKey;
  final Map<NoisePreset, int> presetLevels;
  final int existingFiles;

  const Noise({
    required this.id,
    required this.name,
    required this.preferenceKey,
    required this.presetLevels,
    required this.existingFiles,
  });

  String? getRandomNoisePath() {
    if (existingFiles == 0) return null;
    int randomNumber = Random().nextInt(existingFiles) + 1;
    return '$_noiseAssetPath/$preferenceKey$randomNumber.mp3';
  }

  int getDefaultLevel(NoisePreset currentPreset) {
    return presetLevels[currentPreset] ?? 0;
  }

  static Noise byId(int id) {
    return defaultNoises.firstWhere((noise) => noise.id == id);
  }
}

class NoiseSettings {
  NoisePreset noisePreset = NoisePreset.disabled;
  bool useWhiteNoise = false;
  final Map<int, int> noiseLevels = {};

  void loadAll() {
    final sharedPreferences = SharedPreferencesHolder.get;
    final presetName = sharedPreferences.getString(PreferenceKey.noisePreset) ?? NoisePreset.disabled.name;
    noisePreset = NoisePreset.values.byName(presetName);
    useWhiteNoise = sharedPreferences.getBool(PreferenceKey.useWhiteNoise) ?? false;
    for (Noise defaultNoise in defaultNoises) {
      final level = sharedPreferences.getInt(defaultNoise.preferenceKey) ?? 0;
      noiseLevels[defaultNoise.id] = level;
    }
  }

  void saveAll() {
    final sharedPreferences = SharedPreferencesHolder.get;
    sharedPreferences.setString(PreferenceKey.noisePreset, noisePreset.name);
    sharedPreferences.setBool(PreferenceKey.useWhiteNoise, useWhiteNoise);
    for (Noise defaultNoise in defaultNoises) {
      final level = noiseLevels[defaultNoise.id] ?? 0;
      sharedPreferences.setInt(defaultNoise.preferenceKey, level);
    }
  }
}

const _noiseAssetPath = 'assets/noises';
const whiteNoisePath = '$_noiseAssetPath/whiteNoise.mp3';
const defaultNoises = [
  Noise(
    id: 0,
    name: '????????? ????????? ??????',
    preferenceKey: 'paperFlippingNoise',
    presetLevels: {
      NoisePreset.easy: 8,
      NoisePreset.normal: 12,
      NoisePreset.hard: 16,
    },
    existingFiles: 15,
  ),
  Noise(
    id: 1,
    name: '?????? ?????? ??????',
    preferenceKey: 'writingNoise',
    presetLevels: {
      NoisePreset.easy: 6,
      NoisePreset.normal: 8,
      NoisePreset.hard: 10,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 2,
    name: '???????????? ????????? ??????',
    preferenceKey: 'erasingNoise',
    presetLevels: {
      NoisePreset.easy: 2,
      NoisePreset.normal: 4,
      NoisePreset.hard: 6,
    },
    existingFiles: 10,
  ),
  Noise(
    id: 3,
    name: '?????? ???????????? ??????',
    preferenceKey: 'sharpClickingNoise',
    presetLevels: {
      NoisePreset.easy: 2,
      NoisePreset.normal: 4,
      NoisePreset.hard: 6,
    },
    existingFiles: 20,
  ),
  Noise(
    id: 4,
    name: '?????? ??????',
    preferenceKey: 'coughNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 5,
    name: '??? ???????????? ??????',
    preferenceKey: 'sniffleNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 6,
    name: '?????? ?????? ??????',
    preferenceKey: 'legShakingNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 7,
    name: '??? ???????????? ??????',
    preferenceKey: 'clothesNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 8,
    name: '?????? ???????????? ??????',
    preferenceKey: 'chairMovingNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 9,
    name: '?????? ???????????? ??????',
    preferenceKey: 'chairCreakingNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 2,
      NoisePreset.hard: 3,
    },
    existingFiles: 0,
  ),
  Noise(
    id: 10,
    name: '?????? ????????? ???????????? ??????',
    preferenceKey: 'droppingNoise',
    presetLevels: {
      NoisePreset.easy: 1,
      NoisePreset.normal: 1,
      NoisePreset.hard: 2,
    },
    existingFiles: 10,
  ),
];
