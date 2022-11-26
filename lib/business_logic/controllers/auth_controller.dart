import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/app_routes.dart';
import '../../services/firebase_notification.dart';
class AuthController extends GetxController with NotificationsService{
  bool isVisible = false;
  bool isAccepted = false;
  RxBool isLoading = false.obs;
  String activeSession = '' ;
  String dToken = "";

  final GetStorage storageBox = GetStorage();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future googleSingIn()async{
    try{
      isLoading(true);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

         await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
         activeSession = 'active';
         storageBox.write('session', activeSession);
         storageBox.write('username', value.user!.displayName!);
         storageBox.write('photo', value.user!.photoURL!);
         storageBox.write('email', value.user!.email!);
         getToken(value.user!.uid);
         Get.offNamed(dashboardScreen);
         Get.snackbar('Welcome', 'Mr.${value.user!.displayName}',
             snackPosition: SnackPosition.BOTTOM,
             colorText: Colors.white,
             borderRadius: 20,
             backgroundColor: Colors.green
         );
       });
      isLoading(false);
      update();
    }catch(e){
      isLoading(false);
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          borderRadius: 20,
          backgroundColor: Colors.red
      );
    }
  }
  signOut()async{
    try{

      await googleSignIn.signOut().then((value){
        activeSession = '';
        storageBox.write('session', activeSession);
      });



      update();
      Get.offAllNamed(authScreen);
    }catch(e){
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          borderRadius: 20,
          backgroundColor: Colors.red
      );
    }
  }
  handleSession(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        activeSession = 'false';
        storageBox.write('session', activeSession);
        Get.offAllNamed(authScreen);
      } else {
        activeSession = 'true';
       Get.offAllNamed(dashboardScreen);
      }
    });
  }

}