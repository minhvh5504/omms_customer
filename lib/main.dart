import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final savedLang = prefs.getString('languageCode') ?? 'vi';

  // Run app
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('vi')],
        path: 'assets/lang',
        fallbackLocale: const Locale('vi'),
        startLocale: Locale(savedLang),
        saveLocale: false,
        child: const MyApp(),
      ),
    ),
  );
}
