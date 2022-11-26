import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../business_logic/controllers/real_time_db_controller.dart';
import '../../../helper/app_colors.dart';
import '../../../models/device_model.dart';
import '../../widgets/buttons/custom_FAB.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/toast.dart';

class OwnerDetails extends StatefulWidget {
  const OwnerDetails({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final RealTimeDbController realTimeDbController = Get.put(RealTimeDbController());
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final GlobalKey<FormState> formKey = GlobalKey();

  final GetStorage storage = GetStorage();
  bool isLoading = false;
  @override
  void initState() {
    realTimeDbController.readAddress();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
              child: CustomTopRoundedContainer(
            widget: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      CustomInputField(
                        controller: nameController,
                        autoFocus: true,
                        hint: 'full_name'.tr,
                        onSaved: (value) {
                          firebaseController.ownerName = value.toString();
                          //storage.write('owner', nameController.text.trim());
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'name_is_missing'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomInputField(
                        controller: phoneController,
                        hint: 'phone_number'.tr,
                        isNumber: true,
                        onSaved: (value) {
                          firebaseController.phone = value.toString();
                         // storage.write('phone', phoneController.text.trim());

                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'phone_number_is_missing'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return realTimeDbController.addresses
                              .where((county) => county
                                  .toLowerCase()
                                  .startsWith(
                                      textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        displayStringForOption: (option) => option,
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController addressController,
                            FocusNode brandNode,
                            VoidCallback onFieldSubmitted) {
                          return CustomInputField(
                            focusNode: brandNode,
                            controller: addressController,
                            showSuffix: true,
                            onSaved: (value) {
                             firebaseController.address = value.toString();

                              //storage.write('address', addressController.text.trim().toLowerCase());
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'please_add_an_address'.tr;
                              } else {
                                return null;
                              }
                            },
                            onSuffixTap: () {
                              if (addressController.text.trim().isEmpty) {
                                showToast(
                                    msg: "empty_field".tr, color: Colors.green);
                              } else if (!realTimeDbController.addresses.contains(
                                  addressController.text
                                      .trim()
                                      .toLowerCase())) {
                                realTimeDbController.addresses.add(addressController
                                    .text
                                    .trim()
                                    .toLowerCase());
                                realTimeDbController.updateData(
                                    field: "address",
                                    list: realTimeDbController.addresses);
                                showToast(
                                    msg: "address_has_been_added".tr,
                                    color: Colors.green);
                              } else {
                                showToast(
                                    msg: "address_is_already_exist".tr,
                                    color: Colors.green);
                              }
                            },
                            hint: 'address'.tr,
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);

                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      title: Text(option,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
          )),
          floatingActionButton: CustomFloatingButton(
            elevation: 1.0,
            opacity: 1,
            icon: Ionicons.checkmark,
            onTap: () async{
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                setState((){
                  isLoading == true;
                });

               await firebaseController.uploadImage().then((value) {

                  if (value == true) {

                    firebaseController.uploadDevice(context);

                    setState((){
                      isLoading == false;
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });
                });

              }
            },
          ),
        ),
        firebaseController.isLoading.isTrue
            ? SizedBox.expand(
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Row(
                        children: [
                          const CircularProgressIndicator(color: mainColor,),
                          const SizedBox(width: 10,),
                          Text('uploading_device'.tr)
                        ],
                      ),
                    )),
              )
            : const SizedBox(),
      ],
    );
  }
}
