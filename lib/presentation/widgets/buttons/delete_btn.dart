import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../helper/app_colors.dart';
import '../alert_dialog.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key, required this.id, required this.images, required this.firebaseController}) : super(key: key);
  final FirebaseController firebaseController ;
  final String id;
  final List images;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        deleteDeviceDialog(context: context,
            onDelete: () { firebaseController.deleteDevice(id: id, urls: images);
            Navigator.pop(context);
          },
            title: 'delete_device',
            subtitle: 'are_you_sure_you_want_to_delete_this_device');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: mainColor)
            ),
            child:  const Icon(Ionicons.trash_outline,),
          ),
          Text('delete'.tr,style: const TextStyle(color: mainColor,fontSize: 12),)
        ],
      ),
    );
  }
}
