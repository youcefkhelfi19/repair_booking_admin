import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../business_logic/controllers/auth_controller.dart';
import '../../helper/app_colors.dart';

class AuthScreen extends StatelessWidget {
   AuthScreen({Key? key}) : super(key: key);
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 50,
          width: 300,
          child: GetBuilder<AuthController>(
            builder: (context) {
              return controller.isLoading.value? const CircularProgressIndicator():MaterialButton(
                padding: const EdgeInsets.all(3),
                onPressed: (){
                  controller.googleSingIn();
                },
                color: deepBlue,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30),
                 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                          padding:const EdgeInsets.all(5),
                decoration:const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: Image.asset('assets/images/google.png',height: 40,width: 40,)),

                     Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('continue_with_google'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

}
