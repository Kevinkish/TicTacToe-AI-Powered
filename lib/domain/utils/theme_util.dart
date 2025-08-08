import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUtil {
  static TextTheme createTextTheme(BuildContext context, String fontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
      fontString,
      baseTextTheme,
    );
    TextTheme displayTextTheme = GoogleFonts.getTextTheme(
      fontString,
      baseTextTheme,
    );
    TextTheme textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
    return textTheme;
  }

  static TextTheme txtTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  static ColorScheme colorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;
}
