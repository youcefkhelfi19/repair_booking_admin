import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';

class EmptyListMsg extends StatelessWidget {
  const EmptyListMsg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/search.svg',height: 300,width: 300,),
          Text('empty_list'.tr,style: const TextStyle(color: mainColor,fontSize: 20),)
        ],
      ),
    );
  }
}
