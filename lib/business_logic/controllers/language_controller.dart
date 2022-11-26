import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../helper/global_constants.dart';
import '../../models/language_model.dart';

class LocalizationController extends GetxController implements GetxService{
  final GetStorage storage ;

  LocalizationController({required this.storage}){
    loadCurrentLanguage();
  }
Locale _locale = Locale(LanguageConstants.languagesList[0].countryCode);
   int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];

  Locale get local =>  _locale;
  List<LanguageModel> get languages => _languages;
loadCurrentLanguage()async{
  _locale = Locale(storage.read(LanguageConstants.languageCode)??
      LanguageConstants.languagesList[0].languageCode,
    storage.read(LanguageConstants.countryCode)??
        LanguageConstants.languagesList[0].countryCode
  );
  for(int index = 0 ;index< LanguageConstants.languagesList.length;index++){
    if(LanguageConstants.languagesList[index].languageCode == _locale.languageCode){
      _selectedIndex = index;
      break;
    }
  }
  _languages = [];
  _languages.addAll(LanguageConstants.languagesList);
  update();

}
setLanguage(Locale locale){
  Get.updateLocale(locale);
  _locale = locale;
  saveLanguage(locale);
}
setSelectedIndex(int index){
  _selectedIndex = index;
  update();
}
saveLanguage(Locale locale)async{
storage.write(LanguageConstants.languageCode, locale.languageCode);
storage.write(LanguageConstants.countryCode, locale.countryCode);
}
}