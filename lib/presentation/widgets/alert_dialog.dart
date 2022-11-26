import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';
import 'custom_input_field.dart';

customDialog ({required String image , required String message,required bool dismiss}){
  return  Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: dismiss,
      content: Row(

        children: [
          Row(
            children: [
              Image.asset(image,height: 35,width: 35,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(message,style: const TextStyle(
                    fontSize: 14
                ),),
              )
            ],
          ),
        ],
      )
  );
}
addPriceAndNoteDialog(
    {required BuildContext context,
      required TextEditingController priceController,
      required TextEditingController noteController,
      required Function() onTap}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          title:  Text('add_price'.tr),
          content: SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  CustomInputField(
                    hint: 'price'.tr,
                    isNumber: true,
                    controller: priceController,
                    onSaved: (value) {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    controller: noteController,
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: (value) {},
                    decoration:  InputDecoration(
                      hintText: 'leave_a_note'.tr,
                      label: Text(
                        'note'.tr,
                        style: const TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      height: 50,
                      minWidth: 400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: mainColor,
                      onPressed: () {onTap();},
                      child:  Text(
                        'save'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

addNoteDialog(
    {required BuildContext context,
      required TextEditingController noteController,
      required String title,
      required String hint,
      required Function() onTap}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          title:  Text(title),
          content: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [


                  TextField(
                    keyboardType: TextInputType.multiline,
                    controller: noteController,
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: (value) {},
                    decoration:  InputDecoration(
                      hintText: hint,
                      label: Text(
                        hint,
                        style: const TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      height: 50,
                      minWidth: 400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: mainColor,
                      onPressed: () {onTap();},
                      child:  Text(
                        'save'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
printInvoiceDialog(
    {required BuildContext context,
      required Function() onPrint,
      required Function() onAdd,
      }) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          insetPadding: EdgeInsets.zero,
          title:  Text('print_add'.tr,style: const TextStyle(fontSize: 20),),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('print_receipt_or_add_a_device'.tr,style: const TextStyle(color: Colors.grey),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(onPressed:()=>onAdd() , child: Text('add'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),

                    TextButton(onPressed:()=>onPrint() , child: Text('print'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600)))

                  ],
                ),
              ],
            ),
          ),

        );
      });
}
deleteDeviceDialog(
    {required BuildContext context,
      required Function() onDelete,
      required String title,
      required String subtitle,
    }) {
  return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            insetPadding: EdgeInsets.zero,
            title:  Text(title.tr,style: const TextStyle(fontSize: 20),),
            content: SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(subtitle.tr,style: const TextStyle(color: Colors.grey),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed:()=>Navigator.pop(context) , child: Text('No'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),

                      TextButton(onPressed:()=>onDelete() , child: Text('Yes'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600)))

                    ],
                  ),
                ],
              ),
            ),

          ),
        );
      });
}