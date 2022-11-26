import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../business_logic/controllers/real_time_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    nextScreen();
    super.initState();
  }
  nextScreen(){
    Timer(const Duration(milliseconds: 1500) , (){

      GetStorage().read('session') == 'active'? Get.offNamed(dashboardScreen) :Get.offNamed(authScreen);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: mainColor,
        body: Center(
          child: Image.asset('assets/images/splash_logo.png',height: 100,width: 100,),
        ),
    );
  }
}
