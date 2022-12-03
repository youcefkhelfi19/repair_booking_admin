import 'package:flutter/material.dart';
import 'package:repair_booking_admin/models/device_model.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../helper/app_colors.dart';

class StatusIconBtn extends StatelessWidget {
  const  StatusIconBtn({
    Key? key, required this.value, required this.iconData, required this.device, required this.firebaseController,
  }) : super(key: key);
  final String value;
  final IconData iconData;
  final Device device ;
  final FirebaseController firebaseController ;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          firebaseController.updateField(fieldValue: value, device:device, field: 'repairing' );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: mainColor)
              ),
              child:  Icon(iconData),
            ),
            Text(value,style: const TextStyle(color: mainColor,fontSize: 12),)
          ],
        ),
      ),
    );
  }
}
