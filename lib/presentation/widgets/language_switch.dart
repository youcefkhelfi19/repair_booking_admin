import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/language_controller.dart';
import '../../helper/global_constants.dart';
import '../../models/language_model.dart';
import 'languageWidget.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return SizedBox(
          height:30,
          width: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
              itemCount: localizationController.languages.length,
              itemBuilder: (context,index){

            return  LanguageWidget(languageModel: localizationController.languages[index], localizationController: localizationController, index: index,);

          }, separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 10,);
          },),
        );
      }
    );
  }
}
