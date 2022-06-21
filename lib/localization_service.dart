import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_manager/lang/en_US.dart';
import 'package:expense_manager/lang/hu_HU.dart';

class LocalizationService extends Translations{
  static final locale = Locale('en', 'US');
  static final fallBackLocale = Locale('en', 'US');

  static final langs = ['English', 'Hungarian'];
  static final locales = [
    Locale('en', 'US'),
    Locale('hu', 'HU'),
  ];

  @override
  Map<String, Map<String, String>> get keys =>{
    'en_US': enUs,
    'hu_HU': huHu
  };

  void changeLocale(String lang){
    final locale = getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  Locale? getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}