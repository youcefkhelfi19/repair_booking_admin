
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/global_constants.dart';
import '../models/language_model.dart';

import '../business_logic/controllers/language_controller.dart';

Future<Map<String, Map<String, String>>>init()async{
  final storage = GetStorage();
  Get.lazyPut(() => storage);
  Get.lazyPut(() => LocalizationController(storage: Get.find()));
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in LanguageConstants.languagesList){
    String jsonStringValue = await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic>mappedJson = json.decode(jsonStringValue);
  Map<String, String> jsonLang ={};
  mappedJson.forEach((key, value) {
    jsonLang[key]= value.toString();

  });
  languages['${languageModel.languageCode}_${languageModel.countryCode}']=jsonLang;
  }
return languages;
}
