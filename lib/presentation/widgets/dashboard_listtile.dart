import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../helper/app_colors.dart';

class DashBoardListTile extends StatelessWidget {
  const DashBoardListTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.image,
  }) : super(key: key);
  final String title;
  final Function onTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical:3 ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        leading: Image.asset(
          'assets/images/dashboard/$image.png',
          height: 40,
          width: 40,
        ),
        trailing: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Ionicons.chevron_forward,color: Colors.white,)
        ),
        onTap: ()=>onTap(),
      ),
    );
  }
}
