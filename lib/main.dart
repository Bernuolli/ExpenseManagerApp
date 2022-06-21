import 'package:expense_manager/pages/login.dart';
import 'package:expense_manager/pages/splash.dart';
import 'package:expense_manager/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'localization_service.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Manager',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      translations: LocalizationService(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      home: const Login(),
    );
  }
}

