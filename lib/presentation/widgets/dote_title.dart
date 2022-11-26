import 'package:flutter/material.dart';

class DoteTitle extends StatelessWidget {
  const DoteTitle({
    Key? key, required this.title, required this.color,
  }) : super(key: key);
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        width : MediaQuery.of(context).size.width*0.25,
        alignment: Alignment.center,
        child: Text(title,style:  TextStyle(fontSize: 14,color: color),));
  }
}
