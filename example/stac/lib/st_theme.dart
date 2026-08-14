import 'package:stac/stac_core.dart';

@StacThemeRef(name: 'main_theme')
StacTheme get mainTheme => StacTheme(
  datePickerTheme: StacDatePickerThemeData(
    confirmButtonStyle: StacButtonStyle(
      textStyle: StacTextStyle(
        fontSize: 16,
        fontWeight: StacFontWeight.w500,
        color: StacColors.black,
      ),
    ),
    cancelButtonStyle: StacButtonStyle(
      textStyle: StacTextStyle(fontSize: 16, fontWeight: StacFontWeight.w500),
    ),
    backgroundColor: StacColors.white,
    dayBackgroundColor: StacColors.white,
    todayBorder: const StacBorderSide(color: StacColors.black),
    todayBackgroundColor: StacColors.white,
  ),
  scaffoldBackgroundColor: StacColors.white,
  primaryColorDark: '#3053A1',
  primaryColor: StacColors.black,
  bottomSheetTheme: const StacBottomSheetThemeData(
    backgroundColor: StacColors.transparent,
  ),
  listTileTheme: const StacListTileThemeData(
    contentPadding: StacEdgeInsets.all(0),
  ),
  highlightColor: StacColors.transparent,
  hoverColor: StacColors.transparent,
  splashColor: StacColors.transparent,
  textTheme: StacTextTheme(),
  primaryTextTheme: getMainTextTheme(),
);

StacTextTheme getMainTextTheme() {
  return StacTextTheme(
    displayLarge: StacTextStyle(
      fontSize: 36,
      fontWeight: StacFontWeight.w700,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    displayMedium: StacTextStyle(
      fontSize: 32,
      fontWeight: StacFontWeight.w500,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    displaySmall: StacTextStyle(
      fontSize: 24,
      fontWeight: StacFontWeight.w600,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    headlineMedium: StacTextStyle(
      fontSize: 16,
      fontWeight: StacFontWeight.w700,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    headlineSmall: StacTextStyle(
      fontSize: 16,
      fontWeight: StacFontWeight.w400,
      color: StacColors.black,
    ),
    titleLarge: StacTextStyle(
      fontSize: 12,
      fontWeight: StacFontWeight.w600,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    bodyLarge: StacTextStyle(
      fontSize: 20,
      fontWeight: StacFontWeight.w600,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    bodyMedium: StacTextStyle(
      fontSize: 16,
      fontWeight: StacFontWeight.w400,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    titleMedium: StacTextStyle(
      fontSize: 12,
      fontWeight: StacFontWeight.w400,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
    titleSmall: StacTextStyle(
      fontSize: 10,
      fontWeight: StacFontWeight.w400,
      color: StacColors.black,
      fontFamily: 'dmSans',
    ),
  );
}
