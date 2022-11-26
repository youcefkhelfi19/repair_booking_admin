import 'package:flutter/material.dart';

class PageViewDote extends StatelessWidget {
  const PageViewDote({
    Key? key, required this.text, required this.color,
  }) : super(key: key);
  final String text;
  final Color color ;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration:  BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child:  Text(text,style:  const TextStyle(color: Colors.white),),
        ),

      ],
    );
  }
}
