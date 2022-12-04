import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../helper/app_colors.dart';
import '../../helper/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
saveTopic()async{
  try{
    await FirebaseMessaging.instance.subscribeToTopic("admin");
    print('sub');
  }catch(e){
    print(e);
  }
}
  @override
  void initState() {
  saveTopic();
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
