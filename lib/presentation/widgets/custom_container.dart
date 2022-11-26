import 'package:flutter/material.dart';

class CustomTopRoundedContainer extends StatelessWidget {
  const CustomTopRoundedContainer({Key? key, required this.widget}) : super(key: key);
  final Widget widget ;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
        boxShadow: [
           BoxShadow(
            offset:  Offset(0,-2),
            color: Colors.grey,
            blurRadius: 10.0
          )
        ]
      ),
      child: widget,
    );
  }
}
