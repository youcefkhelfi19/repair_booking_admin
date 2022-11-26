import 'package:flutter/material.dart';

import '../../../helper/app_colors.dart';


class StatusButton extends StatelessWidget {
  const StatusButton({Key? key, required this.title, required this.onTap, required this.color}) : super(key: key);
  final String title;
  final Function() onTap;
  final Color color ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: blue
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Text(title),
      ),
    );
  }
}
