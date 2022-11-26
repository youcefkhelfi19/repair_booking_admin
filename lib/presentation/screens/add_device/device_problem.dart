import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../business_logic/controllers/real_time_db_controller.dart';
import '../../../helper/app_colors.dart';
import '../../widgets/buttons/custom_FAB.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/toast.dart';

class DeviceProblem extends StatefulWidget {
  const DeviceProblem({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;

  @override
  State<DeviceProblem> createState() => _DeviceProblemState();
}

class _DeviceProblemState extends State<DeviceProblem> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController accessorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final TextEditingController descriptionController = TextEditingController();

  final RealTimeDbController realTimeDbController =
      Get.put(RealTimeDbController());

  GlobalKey<FormState> formKey = GlobalKey();
  late List<String> accessories ;
  bool isVisible = false;
  final GetStorage storage = GetStorage();
 // String accessoriesValue = "no_accessories".tr;
  @override
  void initState() {
    realTimeDbController.readAddress();
    accessories = realTimeDbController.accessories;
   // storage.write('accessories',accessoriesValue );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomTopRoundedContainer(
              widget: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return realTimeDbController.issues
                              .where((county) => county
                                  .toLowerCase()
                                  .startsWith(textEditingValue.text.toLowerCase()))
                              .toList();
                        },
                        displayStringForOption: (option) => option,
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController issueController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return CustomInputField(
                            focusNode: fieldFocusNode,
                            autoFocus: true,
                            controller: issueController,
                            hint: 'issue'.tr,
                            showSuffix: true,
                            onSaved: (value) {
                          firebaseController.issue=value.toString();
                             // storage.write('issue', issueController.text.toLowerCase());
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'please_define_the_issue'.tr;
                              } else {
                                return null;
                              }
                            },
                            onSuffixTap: () {
                              if (issueController.text.trim().isEmpty) {
                                showToast(msg: "empty_field".tr, color: Colors.red);
                              } else if (!realTimeDbController.issues.contains(
                                  issueController.text.trim().toLowerCase())) {
                                realTimeDbController.issues
                                    .add(issueController.text.trim().toLowerCase());
                                realTimeDbController.updateData(
                                    field: "issues",
                                    list: realTimeDbController.issues);
                                showToast(
                                    msg: "issue_has_been_added".tr, color: Colors.green);
                              } else {
                                showToast(
                                    msg: "issue_is_already_exist".tr,
                                    color: mainColor);
                              }
                            },
                          );
                        },
                        onSelected: (selection) {},
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
                                    borderRadius: BorderRadius.circular(10)),
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
                                          style:
                                              const TextStyle(color: Colors.black)),
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
                      flex: 3,
                      child: CustomInputField(
                        controller: priceController,
                        hint: '${'price'.tr}(DA)',
                        isNumber: true,

                        onSaved: (value) {
                          value.toString().isNotEmpty?firebaseController.repairingPrice=value.toString():null;

                          //  storage.write('price', priceController.text.isEmpty? '0.00':priceController.text);
                        },
                        validator: (value) {
                        },
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    minLines: 1,
                    maxLines: 5,
                    onSaved: (value){
                     value.toString().isNotEmpty? firebaseController.description=value.toString():null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Problem Description',
                      label: Text(
                        'Description',
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'accessories'.tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                CustomCheckBoxGroup(
                  buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: mainColor,
                    textStyle: TextStyle(fontSize: 14, color: mainColor),
                  ),
                  shapeRadius: 10,
                  radius: 10,
                  enableShape: true,
                  unSelectedColor: Colors.white,
                  buttonLables: accessories,
                  autoWidth: true,
                  buttonValuesList: accessories,
                  checkBoxButtonValues: (values) {
                    values.isNotEmpty?firebaseController.accessories = values.join(","):null;
                    //storage.write('accessories',accessoriesValue );
                  },
                  spacing: 0,
                  horizontal: false,
                  enableButtonWrap: true,
                  width: 40,
                  absoluteZeroSpacing: false,
                  selectedColor: mainColor,
                  padding: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 35,
                    margin: const EdgeInsets.all(8),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      color: mainColor.withOpacity(0.5),
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {setState(() {
                            isVisible = !isVisible;
                          });},
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: mainColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: CustomInputField(
                    controller: accessorController,
                    hint: 'add_item'.tr,
                    showSuffix: true,
                    onSaved: (value) {},
                    validator: (value) {},
                    onSuffixTap: () {
                      if (accessorController.text.trim().isEmpty) {
                        showToast(msg: "empty_field".tr, color: Colors.red);
                      } else if (!accessories.contains(
                          accessorController.text.trim().toLowerCase())) {
                        accessories
                            .add(accessorController.text.trim().toLowerCase());
                        realTimeDbController.updateData(
                            field: "accessories", list: accessories);
                        showToast(
                            msg: "item_has_been_added".tr, color: Colors.green);
                        setState(() {
                          accessorController.clear();
                        });
                      } else {
                        showToast(
                            msg: "Item is already exist !", color: mainColor);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ))),
      floatingActionButton: CustomFloatingButton(
        elevation: 1.0,
        opacity: 1,
        onTap: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            storage.write(
                'description',
                descriptionController.text.isEmpty
                    ? "None"
                    : descriptionController.text);
            widget.pageController.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
            );
          }
        },
      ),
    );
  }
}
