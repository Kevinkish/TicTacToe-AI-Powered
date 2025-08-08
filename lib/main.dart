import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/domain.dart';
import 'ui/ui.dart';

void main() async {
  final pref = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeneralProvider()..getPrefs(pref),
        ),
        // ChangeNotifierProvider(create: (context) => ConsultationProvider()),
        // ChangeNotifierProvider(create: (context) => PatientsProvider()),
      ],
      child: TicTacToe(),
    ),
  );
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = ThemeUtil.createTextTheme(context, "Outfit");

    AppTheme theme = AppTheme(textTheme);
    return Consumer<GeneralProvider>(
      builder: (context, general, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'TicTacToe',
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: general.isDark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: goRouter,
        );
      },
    );
  }
}
