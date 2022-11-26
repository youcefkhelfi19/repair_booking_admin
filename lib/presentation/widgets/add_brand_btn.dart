import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';

class SmallAddButton extends StatelessWidget {
  const SmallAddButton({
    Key? key, required this.onTap,
  }) : super(key: key);
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: MaterialButton(
        padding:  const EdgeInsets.all(3),
        elevation: 0.0,
        height: 45,
        minWidth: 45,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        color: blue,
        onPressed:()=>onTap(),
        child:  Text('add'.tr),
      ),
    );
  }
}
