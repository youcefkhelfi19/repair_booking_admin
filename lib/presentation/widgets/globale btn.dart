import 'package:flutter/material.dart';

import '../../helper/app_colors.dart';



class CustomGlobalBtn extends StatelessWidget {
  const CustomGlobalBtn({
    Key? key,
    required this.btnText,
    this.radius = 10,
    this.textSize = 20,
    required this.onPressed,
  }) : super(key: key);
  final String btnText;
  final double textSize;
  final double radius ;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 80
      ),
      child: MaterialButton(
          color: mainColor,
          height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          child: Text(
            btnText,
            style: const TextStyle(color: Colors.white,),
          ),
          onPressed: () => onPressed()),
    );
  }
}