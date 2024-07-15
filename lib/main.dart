import 'package:easy_localization/easy_localization.dart';
import 'package:ewallet/pages/wallets_page.dart';
import 'package:ewallet/provider/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool darkMode = preferences.getBool("theme") ?? true;

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('de', 'DE'),
      child: ChangeNotifierProvider<ThemeManager>(
        create: (_) =>
            ThemeManager(darkMode ? MyThemes.darkTheme : MyThemes.lightTheme),
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'E-Wallet',
        theme: Provider.of<ThemeManager>(context).getTheme(),
        home: const WalletSelection());
  }
}
