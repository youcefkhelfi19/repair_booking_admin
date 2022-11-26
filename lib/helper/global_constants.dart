import 'package:get/get.dart';

import '../models/language_model.dart';
class LanguageConstants {
 static const String countryCode = "country_code";
static  const String languageCode = "language_code";

 static  List<LanguageModel> languagesList = [
    LanguageModel(countryCode: 'US', languageCode: 'en', languageName: "English"),
    LanguageModel(countryCode: 'FR', languageCode: 'fr', languageName: "French"),

  ];
}


List<String> repairStatus =[
  'Pending',
  'In Progress',
  'Completed',
  'Cancelled'
];
List<String> repairStatusLabels =[
  'Pending'.tr,
  'In Progress'.tr,
  'Completed'.tr,
  'Cancelled'.tr
];

List<String> storedStatus =[
  'In Store',
  'Delivered',
  'Returned'
];
List<String> storedStatusLabels =[
  'In Store'.tr,
  'Delivered'.tr,
  'Returned'.tr
];

enum SecurityTypes { none, pattern, password }
const String serverKey = "AAAAsZzylWE:APA91bH7TN3xEKZjWSiulV3KXQozl-Y3w5b_cgJGjPXjs-zl9WhuItHTrGOoh9SXrNdIYWir6UVTIjEb3HlLeDV9CJXizLtV4dmiWLMDr2gBImeOG5-8z-TeBGIOE2_y5b3CoW0kuYEY";