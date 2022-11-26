import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';

import '../../business_logic/controllers/auth_controller.dart';
import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../screens/store_profile.dart';
import 'language_switch.dart';

class CustomDrawer extends StatelessWidget {
   CustomDrawer({Key? key}) : super(key: key);
  final AuthController authController = Get.put<AuthController>(AuthController());
  final FirebaseController firebaseController =Get.put(FirebaseController());
  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.only(left: 10,bottom:0 ),
            decoration: const BoxDecoration(
              color: mainColor,
              borderRadius:  BorderRadius.only(
                bottomLeft: Radius.elliptical(300, 30),
                bottomRight: Radius.elliptical(300, 30),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 43,
                    backgroundImage: NetworkImage('${storage.read('photo')}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10 ),
                  child: Text('${storage.read('username')}',style: const TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('store_details'.tr,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Ionicons.information_circle,color: mainColor),
                  title: Text(firebaseController.store.name.isEmpty? 'store_name'.tr:firebaseController.store.name),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Ionicons.call,color: Colors.green),
                  title: Text(firebaseController.store.phone.isEmpty? 'phone_number'.tr:firebaseController.store.phone),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Ionicons.logo_facebook,color: Colors.blue),
                  title: Text(firebaseController.store.facebook.isEmpty? 'facebook_page'.tr :firebaseController.store.facebook),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Ionicons.location,color: Colors.deepOrange),
                  title: Text(firebaseController.store.location.isEmpty? 'location'.tr:firebaseController.store.location),
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('settings'.tr,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
          ),
          Padding(
            padding:  const EdgeInsets.only(left: 8.0),
            child: ListTile(
              onTap: (){Get.to(()=>  StoreProfile(store: firebaseController.store,));},
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Ionicons.create,color: Colors.black,size: 30,),
              title: Text('edite_details'.tr),
            ),
          ),
          Padding(
            padding:  const EdgeInsets.only(left: 8.0),
            child: ListTile(
              onTap: (){Get.to(()=>  StoreProfile(store: firebaseController.store,));},
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Ionicons.language,color: Colors.lightBlue,size: 30,),
              title:  Text('language'.tr),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: LanguageSwitch(),
          ),
          const Spacer(),
          GetBuilder<AuthController>(
              builder: (context) {
                return ListTile(
                  onTap: () {
                    authController.signOut();
                  },
                  title: Text('logout'.tr,),
                  leading:const Icon(Ionicons.log_out_outline),

                );
              }
          ),
        ],
      ),
    );
  }
}
