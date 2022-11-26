import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pattern_lock/pattern_lock.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../business_logic/controllers/real_time_db_controller.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/global_constants.dart';
import '../../widgets/buttons/custom_FAB.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/toast.dart';

class BrandAndModel extends StatefulWidget {
  const BrandAndModel({Key? key,  required this.pageController}) : super(key: key);
  final PageController pageController;

  @override
  State<BrandAndModel> createState() => _BrandAndModelState();
}

class _BrandAndModelState extends State<BrandAndModel> {
  SecurityTypes? securityType = SecurityTypes.none;
  String securityStatus = "None";
   TextEditingController securityTypeController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  final FirebaseController firebaseController = Get.put(FirebaseController());
  RealTimeDbController realTimeDbController = Get.put(RealTimeDbController());
  GlobalKey<FormState> formKey = GlobalKey();
  //GetStorage storage = GetStorage();
  @override
  void initState() {
    realTimeDbController.readIssues();
    realTimeDbController.readAccessories();
    //securityTypeController.text = 'Non';
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Center(
          child:  CustomTopRoundedContainer(
            widget:Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  child: Column(

                    children: [
                     Row(
                       children: [
                         Expanded(
                           child: Autocomplete<String>(
                             optionsBuilder: (TextEditingValue textEditingValue) {
                               return realTimeDbController.brands
                                   .where((county) => county
                                   .toLowerCase()
                                   .startsWith(textEditingValue.text.toLowerCase()))
                                   .toList();
                             },
                             displayStringForOption: (option) => option,
                             fieldViewBuilder: (BuildContext context,
                                 TextEditingController brandController,
                                 FocusNode brandNode,
                                 VoidCallback onFieldSubmitted) {
                               return CustomInputField(
                                 focusNode: brandNode,
                                 autoFocus: true,
                                 controller: brandController,
                                 showSuffix: true,
                                 onSaved: (value){
                                 firebaseController.brand = value.toString().toLowerCase();
                                   //storage.write('brand', brandController.text.toLowerCase());

                                 },
                                 validator: (value){
                                   if(value.toString().isEmpty){
                                     return 'please_select_a_brand'.tr;
                                   }else{
                                     return null;
                                   }
                                 },
                                 onSuffixTap: (){
                                   if(brandController.text.trim().isEmpty){
                                     showToast(msg: "empty_field".tr, color: Colors.green);

                                   }else if(!realTimeDbController.brands.contains(brandController.text.trim().toLowerCase())){
                                     realTimeDbController.brands.add(brandController.text.trim().toLowerCase());
                                     realTimeDbController.updateData(field: "brands", list:realTimeDbController.brands );
                                     showToast(msg: "brand_has_been_added".tr, color: Colors.green);

                                   }else{
                                     showToast(msg: "brand_is_already_exist".tr, color: Colors.green);

                                   }
                                 },

                                 hint: 'brand'.tr,
                               );
                             },
                             onSelected: (selection) {
                               //brandController.text = selection;
                               //print('Selected: ${brandController.text}');
                             },
                             optionsViewBuilder: (BuildContext context,
                                 AutocompleteOnSelected<String> onSelected,
                                 Iterable<String> options) {
                               return Align(
                                 alignment: Alignment.topLeft,
                                 child: Material(
                                   elevation: 0.0,
                                   borderRadius: BorderRadius.circular(10),
                                   child: Container(
                                     width: 150,
                                     height: 300,

                                     decoration: BoxDecoration(
                                         color: Colors.grey.shade200,
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     child: ListView.builder(
                                       padding: const EdgeInsets.all(10.0),
                                       itemCount: options.length,
                                       itemBuilder: (BuildContext context, int index) {
                                         final String option = options.elementAt(index);

                                         return ListTile(
                                           contentPadding: EdgeInsets.zero,
                                           onTap: () {
                                             onSelected(option);
                                           },
                                           title: Text(option,
                                               style: const TextStyle(color: Colors.black)),
                                         );
                                       },
                                     ),
                                   ),
                                 ),
                               );
                             },
                           ),
                         ),
                         const SizedBox(width: 10,),
                         Expanded(
                           child: Autocomplete<String>(
                             optionsBuilder: (TextEditingValue textEditingValue) {
                               return realTimeDbController.models
                                   .where((county) => county
                                   .toLowerCase()
                                   .startsWith(textEditingValue.text.toLowerCase()))
                                   .toList();
                             },
                             displayStringForOption: (option) => option,
                             fieldViewBuilder: (BuildContext context,
                                 TextEditingController modelController,
                                 FocusNode fieldFocusNode,
                                 VoidCallback onFieldSubmitted) {
                               return CustomInputField(
                                 focusNode: fieldFocusNode,
                                 controller: modelController,
                                 hint: 'model'.tr,
                                 showSuffix: true,
                                 onSaved: (value){
                                  firebaseController.model = value.toString().toLowerCase();
                                  // storage.write('model', modelController.text.toLowerCase());
                                 },
                                 validator: (value){
                                   if(value.toString().isEmpty){
                                     return 'please_select_a_model'.tr;
                                   }else{
                                     return null;
                                   }
                                 },
                                 onSuffixTap: (){
                                   if(modelController.text.trim().isEmpty){
                                     showToast(msg: "empty_field".tr, color: Colors.red);
                                   }else if(!realTimeDbController.models.contains(modelController.text.trim().toLowerCase())){
                                     realTimeDbController.models.add(modelController.text.trim().toLowerCase());
                                     realTimeDbController.updateData(field: "models", list:realTimeDbController.models );
                                     showToast(msg: "model_has_been_added".tr, color: Colors.green);
                                   }else{
                                     showToast(msg: "Model is already exist !", color: mainColor);
                                   }
                                 },
                               );
                             },
                             onSelected: (selection) {
                             },
                             optionsViewBuilder: (BuildContext context,
                                 AutocompleteOnSelected<String> onSelected,
                                 Iterable<String> options) {
                               return Align(
                                 alignment: Alignment.topLeft,
                                 child: Material(
                                   borderRadius: BorderRadius.circular(10),
                                   child: Container(
                                     width: 150,
                                     height: 300,
                                     decoration: BoxDecoration(
                                         color: Colors.grey.shade200,
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     child: ListView.builder(
                                       padding: const EdgeInsets.all(10.0),
                                       itemCount: options.length,
                                       itemBuilder: (BuildContext context, int index) {
                                         final String option = options.elementAt(index);

                                         return ListTile(
                                           contentPadding: EdgeInsets.zero,
                                           onTap: () {
                                             onSelected(option);
                                           },
                                           title: Text(option,
                                               style: const TextStyle(color: Colors.black)),
                                         );
                                       },
                                     ),
                                   ),
                                 ),
                               );
                             },
                           ),
                         ),

                       ],
                     ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: serialNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,

                          onSubmitted: (value){
                            value.toString().isNotEmpty?firebaseController.serial = value.toLowerCase():null;
                            //storage.write('serial', serialNumberController.text.trim());
                          },
                          decoration: InputDecoration(
                            hintText: 'serial_number'.tr,
                            label: Text('serial_number'.tr,style:  const TextStyle(color: mainColor),),

                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child:  Text('device_security'.tr),
                        ),
                      ),
                      securityRadios(),
                      securityStatus == "None"
                          ? const SizedBox()
                          : securityStatus == "Password"
                          ?  CustomInputField(
                        controller: securityTypeController,
                        validator: (value){
                          if(value.toString().isEmpty){
                            return 'please_add_password'.tr;
                          }else{
                            return null;
                          }
                        },
                        hint: 'device_password'.tr,
                        onSaved: (value){
                          value.toString().isNotEmpty? firebaseController.security = value.toString().toLowerCase():null;
                        },
                      )
                          : Column(
                        children: [
                          Text('${'pattern_code'.tr}: ${securityTypeController.text}'),

                          Container(
                            height: 200,
                            color: Colors.white,
                            child: PatternLock(
                              selectedColor: mainColor,
                              notSelectedColor: blue,
                              pointRadius: 10,
                              showInput: true,
                              dimension: 3,
                              relativePadding: 0.3,
                              selectThreshold: 25,
                              fillPoints: true,
                              onInputComplete: (List<int> input) {
                                List code = [];
                                for(int i in input){
                                  code.add(i+1);
                                }
                                setState(() {
                                  securityTypeController.text = code.join();
                                  firebaseController.security = code.join();

                                });

                              },
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            )
          )
      ),
      floatingActionButton:CustomFloatingButton(
        elevation: 1.0,
        opacity:1 ,
        onTap: (){
          if(securityStatus == 'Pattern'&& securityTypeController.text.isEmpty){
              showToast(msg: 'pattern_code_is_missing'.tr, color: Colors.red);
          }else{
            if(formKey.currentState!.validate()){
              formKey.currentState!.save();
            //  storage.write('security', securityTypeController.text);
             // storage.write('serial', serialNumberController.text.isEmpty?  "Not defined":serialNumberController.text);

              widget.pageController.nextPage( duration: const Duration(milliseconds: 200), curve: Curves.linear,);

            }
          }

        },
      ) ,
    );
  }

  Padding securityRadios() {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<SecurityTypes>(
            hoverColor: mainColor,
            activeColor: mainColor,
            value: SecurityTypes.none,
            groupValue: securityType,
            onChanged: (SecurityTypes? value) {
              setState(() {
                firebaseController.security = 'Non';
                securityTypeController.text = 'Non';
                securityType = value;
                securityStatus = "None";

              });
            },
          ),
          Text('none'.tr),
          const Spacer(),
          Radio<SecurityTypes>(
            value: SecurityTypes.pattern,
            activeColor: mainColor,
            groupValue: securityType,
            onChanged: (SecurityTypes? value) {
              setState(() {
                securityTypeController.clear();
                securityType = value;
                securityStatus = "Pattern";
              });
            },
          ),
          Text('pattern'.tr),
          const Spacer(),
          Radio<SecurityTypes>(
            activeColor: mainColor,
            value: SecurityTypes.password,
            groupValue: securityType,
            onChanged: (SecurityTypes? value) {
              setState(() {
                securityTypeController.clear();
                securityType = value;
                securityStatus = "Password";
              });
            },
          ),
          Text('password'.tr),
        ],
      ),
    );
  }
}
