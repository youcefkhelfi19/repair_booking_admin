import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../helper/global_constants.dart';
import '../models/device_model.dart';
import '../presentation/screens/device_details.dart';
class NotificationsService{
  FirebaseDatabase database = FirebaseDatabase.instance;
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{
    print('background :------');
      print(message.data);
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestPermission()async{
    FirebaseMessaging  messaging = FirebaseMessaging.instance;
    NotificationSettings setting = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(setting.authorizationStatus == AuthorizationStatus.authorized){
      print('granted');
    }else if(setting.authorizationStatus == AuthorizationStatus.provisional){
   print('provisional');
    }else{
      print("declined");
    }
  }
  getToken(String idToken)async{
    await FirebaseMessaging.instance.getToken().then((value){
      saveTokens(idToken,value!);
    });
  }
  saveTokens(String idToken ,String dToken)async{
    try{

      DatabaseReference ref = database.ref("tokens");
      await ref.set(
          {
            idToken: dToken,

          }
      );

    }catch(e){
      return e;
    }
  }
  saveToken(String token)async{
    await FirebaseFirestore.instance.collection("tokens").doc("admin").set(
        {"token": token});
  }
  initInfo(){
     Device device;
    var initializationSettings = const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    FirebaseMessaging.onMessage.listen((message)async {
     //device = Device.fromJson(message.data);
    BigTextStyleInformation  bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
    );
  AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'repair_bg', "repair_bg", importance: Importance.high,
      priority: Priority.high,playSound: true,
  );
   NotificationDetails platformSpecifics = NotificationDetails(
  android: androidNotificationDetails,
    // iOS: const IOSNotificationDetails()
  );
  await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body,
       platformSpecifics,
      payload: message.data['title']
   );
     flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (payload)async{
       if(payload != null && payload.isNotEmpty){
         print('payload');
        // Get.to(()=>DeviceDetails(device: device));

         print(payload);

       }
     });

    });

  }
  sendNotificationViaTopic({required Device device , required String status,})async{
    try{
    http.Response response =   await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            "Content-type": "application/json",
            "Authorization":"key=AAAAsZzylWE:APA91bH7TN3xEKZjWSiulV3KXQozl-Y3w5b_cgJGjPXjs-zl9WhuItHTrGOoh9SXrNdIYWir6UVTIjEb3HlLeDV9CJXizLtV4dmiWLMDr2gBImeOG5-8z-TeBGIOE2_y5b3CoW0kuYEY",
          },
          body: jsonEncode(
          {
            "priority":"high",
            "data": device.toJson(),
              "notification":<String, dynamic>{
                "body": "${device.model.toUpperCase()} has been $status",
                "title": status,
                "android_channel_id":"repair_bg",

              },
              "to":"/topics/flutter",
            },

          )
      );
    print(response.statusCode);
      print('sent');

    }catch(e){
      print('error here $e');
      print('catching');
    }
  }

}