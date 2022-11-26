import 'package:flutter/material.dart';

import '../../business_logic/controllers/language_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/global_constants.dart';
import '../../models/language_model.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({Key? key, required this.languageModel, required this.localizationController, required this.index}) : super(key: key);
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        localizationController.setLanguage(
          Locale(LanguageConstants.languagesList[index].languageCode,
            LanguageConstants.languagesList[index].countryCode,
          )
        );
        localizationController.setSelectedIndex(index);

      },
      child: Container(
        width: 70,
        height: 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: localizationController.selectedIndex == index ?mainColor : Colors.white,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: mainColor
          )
        ),
        child: Text(languageModel.languageName,style:  TextStyle(fontSize: 14, color: localizationController.selectedIndex == index ?  Colors.white:mainColor,
        ),),
      ),
    );
  }
}
