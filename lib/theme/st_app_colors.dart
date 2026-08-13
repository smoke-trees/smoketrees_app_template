/// Pure-Dart brand color palette for Stac DSL and JSON.
///
/// This file deliberately contains NO Flutter imports. The Stac CLI compiles
/// `@StacScreen` DSL files with standalone `dart run` (no Flutter engine), so
/// anything that transitively imports `dart:ui` crashes the compiler. Keep
/// this file and the DSL files Flutter-free.
///
/// Stac resolves a color string three ways: `#hex` (native), theme names, and
/// the built-in Stac named colors; any other string silently becomes
/// `transparent`. To use your own `AppColors`-style names in Stac JSON, map
/// them to `#hex` values through [StacColorMapper].
class StacColorMapper {
  StacColorMapper._();

  static const Map<String, String> colors = {
    'scaffoldColor': '#FFFFFF',
    'primaryColor': '#169AB4',
    'primaryLight': '#CFF6FE',
    'dark': '#272728',
    'm1': '#04445E',
    'm2': '#169AB4',
    'l1': '#CFF6FE',
    'warningBg': '#FFFBDA',
    'yellowBg': '#ECD500',
    'grey1': '#595D62',
    'grey2': '#E2E2E2',
    'success': '#2E7D32',
    'successBg': '#E4FFE9',
    'error': '#D33030',
    'errorBg': '#FFF0F0',
    'errorBg2': '#FFEDD5',
    'error2': '#FA8236',
    'white': '#FFFFFF',
    'transparent': '#00000000',
    'grey': '#D7D7D7',
    'textDark': '#011E29',
    'textWhite': '#FFFFFF',
    'radioActive': '#22BEB6',
    'radioActive2': '#83B4FF',
    'chipBgColor': '#D6E6FF',
    'iconTextColor': '#404040',
    'gradientBlue': '#3053A1',
    'textBlue': '#2D57A4',
    'textBlue2': '#29539C',
    'darkBlue': '#2F3E74',
    'fomoPurple': '#968CE4',
  };

  static bool contains(String value) => colors.containsKey(value);

  /// Resolves a single color string to a `#hex` value Stac can parse.
  ///
  /// Known brand names become their hex value; anything else (`#hex`, theme
  /// names, built-in Stac names) is returned unchanged.
  static String resolve(String value) => colors[value] ?? value;

  static Object? resolveValue(Object? value) =>
      value is String ? resolve(value) : value;

  /// Recursively rewrites a Stac JSON map/list so every string that matches a
  /// brand color name becomes its `#hex` value.
  ///
  /// Apply this before handing JSON to `Stac.fromJson`, a custom parser's
  /// `getModel`, or your own screen loader.
  static dynamic normalize(dynamic json) {
    if (json is Map) {
      return json.map((key, value) => MapEntry(key, normalize(value)));
    }
    if (json is List) return json.map(normalize).toList();
    if (json is String) return resolve(json);
    return json;
  }
}

/// Hex-string mirror of `AppColors` for Stac DSL/JSON. Derives from
/// [StacColorMapper] so the two can never drift apart.
class StAppColors {
  static final String scaffoldColor = StacColorMapper.colors['scaffoldColor']!;
  static final String primaryColor = StacColorMapper.colors['primaryColor']!;
  static final String primaryLight = StacColorMapper.colors['primaryLight']!;
  static final String dark = StacColorMapper.colors['dark']!;
  static final String m1 = StacColorMapper.colors['m1']!;
  static final String m2 = StacColorMapper.colors['m2']!;
  static final String l1 = StacColorMapper.colors['l1']!;

  static final String warningBg = StacColorMapper.colors['warningBg']!;
  static final String yellowBg = StacColorMapper.colors['yellowBg']!;

  static final String grey1 = StacColorMapper.colors['grey1']!;
  static final String grey2 = StacColorMapper.colors['grey2']!;

  static final String success = StacColorMapper.colors['success']!;
  static final String successBg = StacColorMapper.colors['successBg']!;

  static final String error = StacColorMapper.colors['error']!;

  static final String errorBg = StacColorMapper.colors['errorBg']!;
  static final String errorBg2 = StacColorMapper.colors['errorBg2']!;
  static final String error2 = StacColorMapper.colors['error2']!;

  static final String white = StacColorMapper.colors['white']!;
  static final String transparent = StacColorMapper.colors['transparent']!;
  static final String grey = StacColorMapper.colors['grey']!;
  static final String textDark = StacColorMapper.colors['textDark']!;
  static final String textWhite = StacColorMapper.colors['textWhite']!;

  static final String radioActive = StacColorMapper.colors['radioActive']!;
  static final String radioActive2 = StacColorMapper.colors['radioActive2']!;
  static final String chipBgColor = StacColorMapper.colors['chipBgColor']!;
  static final String iconTextColor = StacColorMapper.colors['iconTextColor']!;

  static final String gradientBlue = StacColorMapper.colors['gradientBlue']!;
  static final String textBlue = StacColorMapper.colors['textBlue']!;
  static final String textBlue2 = StacColorMapper.colors['textBlue2']!;
  static final String darkBlue = StacColorMapper.colors['darkBlue']!;
  static final String fomoPurple = StacColorMapper.colors['fomoPurple']!;
}
