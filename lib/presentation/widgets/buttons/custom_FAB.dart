import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../helper/app_colors.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    Key? key,
    required this.onTap, required this.elevation, required this.opacity, this.icon = Ionicons.arrow_forward  ,
  }) : super(key: key);
  final Function() onTap;
  final double elevation;
  final double opacity;
  final IconData  icon ;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation:elevation ,
        backgroundColor: mainColor.withOpacity(opacity),
        onPressed:()=> onTap(),
        child:  Icon(icon)

    );
  }
}
