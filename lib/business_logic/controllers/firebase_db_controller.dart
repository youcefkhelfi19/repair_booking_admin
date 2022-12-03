import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../helper/app_routes.dart';
import '../../models/device_model.dart';
import '../../models/store_model.dart';
import '../../presentation/screens/device_details.dart';
import '../../presentation/widgets/alert_dialog.dart';
import '../../presentation/widgets/toast.dart';
import '../../services/firebase_notification.dart';
import '../../services/invoice_service/file_handle_api.dart';
import '../../services/invoice_service/pdf_invoice_api.dart';

class FirebaseController extends GetxController with NotificationsService {
  GetStorage storage = GetStorage();
  late firebase_storage.Reference ref;
  RxBool isLoading = false.obs;
  List imagesLinks = [];
  List<File> images =[];
  RxList devices = [].obs;
  String deviceId = const Uuid().v4();
  late Store store ;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late String brand;
  late String model;
  late String serial = 'Not defined';
   String description= "...";
  late String address;
 late String phone;
  late String issue ;
  late String ownerName ;
  String security = 'Non';
  String accessories = 'no_accessories'.tr;
  String repairingPrice = "0.00";
  @override
  void onInit() {

    fetchStoreDetails();
  }


  @override
  void onReady() {
    fetchStoreDetails();
  }

  Future<bool> uploadImage() async {
    isLoading(true);
    try {
      if(images.isNotEmpty){
        for (int i = 0; i < images.length; i++) {
          final ref =  firebaseStorage
              .ref()
              .child('devices')
              .child(deviceId)
              .child(Path.basename(i.toString()));
          await ref.putFile(images[i]).whenComplete(() async {
            await ref.getDownloadURL().then((value) => {
              imagesLinks.add(value),
            });


          });

        }
      }

    update();
      isLoading(false);

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          borderRadius: 20,
          backgroundColor: Colors.red);
      isLoading(false);

      return false;
    }
  }

  Future uploadDevice(BuildContext context) async {
    isLoading(true);
    Device device = Device(
        deviceId: deviceId,
        brand: brand,
        model: model,
        serial: serial,
        description: description,
        images: imagesLinks,
        address: address,
        phone: phone,
        dateTime: DateTime.now().toString(),
        repairingStatus: "Pending",
        issue: issue,
        ownerName: ownerName,
        security: security,
        uploadedBy: storage.read('username'),
        storingStatus: 'In Store',
        accessories: accessories,
        repairingPrice: repairingPrice,
        completedNote: "",
        cancelledNote: "",
        inProgressNote: "",
        returnedNote: ""
    );
    try {
      await firebaseFirestore
          .collection('devices')
          .doc(deviceId)
          .set(device.toJson())
          .whenComplete(() async {
        showToast(color: Colors.green, msg: 'device_has_been_uploaded'.tr);
        Get.offAllNamed(dashboardScreen);

        printInvoiceDialog(context: context,
            onPrint: () {
          generateReceipt(device);
          Get.offAllNamed(dashboardScreen);

            },
            onAdd: () { Get.offAllNamed(addDevice); });
        isLoading(false);


      });

    } catch (e) {
      isLoading(false);

      showToast(color: Colors.red, msg: 'Error ${e.toString()}');

    }
  }

  fetchDevicesByStatus(String status,) {
    return firebaseFirestore
        .collection('devices')
        .where('repairing', isEqualTo: status).orderBy('date', descending: false)
        .snapshots();
  }
  fetchDeliveredDevices() {
    return firebaseFirestore
        .collection('devices')
        .where('storing', isEqualTo: "Delivered")
        .snapshots();
  }
  fetchDevicesBySSearching() async {
    var snapshot = firebaseFirestore.collection('devices').get();
    snapshot.then((value) {
      for (var doc in value.docs) {
        Device device = Device(
            deviceId: doc.id,
            brand: doc.data()['brand'],
            model: doc.data()['model'],
            repairingStatus: doc.data()['repairing'],
            description: doc.data()['description'],
            images: doc.data()['images'],
            address: doc.data()['address'],
            phone: doc.data()['phone'],
            serial: doc.data()['serial'],
            dateTime: doc.data()['date'],
            issue: doc.data()['issue'],
            ownerName: doc.data()['owner'],
            security: doc.data()['security'],
            uploadedBy: doc.data()['by'],
            storingStatus: doc.data()['storing'],
            completedNote: doc.data()['completed_note'],
            repairingPrice: doc.data()['price'],
            accessories: doc.data()['accessories'],
            cancelledNote: doc.data()['cancelled_note'],
            inProgressNote: doc.data()['progress_note'],
            returnedNote: doc.data()['returned_note']
        );
        devices.add(device);

      }
    });
  }
   getDeviceById({required String id}) {
   late Device device ;
    var snapshot = firebaseFirestore.collection('devices').doc(id);
    snapshot.get().then((value){
       device = Device(
          deviceId: value.get('id'),
          brand: value.get('brand'),
          model: value.get('model'),
          repairingStatus: value.get('repairing'),
          description: value.get('description'),
          images: value.get('images'),
          address: value.get('address'),
          phone: value.get('phone'),
          serial: value.get('serial'),
          dateTime: value.get('date'),
          issue: value.get('issue'),
          ownerName: value.get('owner'),
          security: value.get('security'),
          uploadedBy: value.get('by'),
          storingStatus: value.get('storing'),
          completedNote: value.get('completed_note'),
          repairingPrice: value.get('price'),
          accessories: value.get('accessories'),
          cancelledNote: value.get('cancelled_note'),
          inProgressNote: value.get('progress_note'),
          returnedNote: value.get('returned_note')
      );
    }).whenComplete(() => Get.to(()=>DeviceDetails(device: device))
    );
  }
  Future<bool> updateField({required String fieldValue, required Device device,required String field}) async {
    try{
      await  firebaseFirestore
          .collection('devices')
          .doc(device.deviceId)
          .update({field: fieldValue});
      update();
      showToast(color: Colors.green, msg: 'update_success'.tr);
      fieldValue =='Completed' || fieldValue == 'Cancelled'?
      sendNotificationViaTopic(deviceId: device.deviceId,
          status: fieldValue, model: device.model, ):null;

      return true;
    }catch(e){
      showToast(color: Colors.green, msg: e.toString());

      return false;
    }

  }
  updatePriceAndNote({required String price, required String id,required String note}) async {
    return firebaseFirestore
        .collection('devices')
        .doc(id)
        .update({'price': price,'completed_note':note})
        .then((value) => showToast(color: Colors.green, msg: 'data_has_been_updated'.tr)
    )
        .catchError((error) =>  showToast(color: Colors.red, msg: error)
    );
  }

  generateReceipt(Device device) async {
    final pdfFile = await PdfReceiptApi.generate(device: device,store: store);

    FileHandleApi.openFile(pdfFile);
  }
  generateInvoice(Device device,String price) async {
    final pdfFile = await PdfInvoiceApi.generateInvoice(device: device, store: store, price: price);

    FileHandleApi.openFile(pdfFile);
  }


  Future<bool> deleteDevicePictures({required List urls}) async {
    try {
      for (var url in urls) {
        Reference photoRef = firebaseStorage.refFromURL(url);
        await photoRef.delete().then((value) {
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  deleteDevice({required String id, required List urls}) async {
    try {
      bool response = await deleteDevicePictures(urls: urls);
      if (response) {
        await firebaseFirestore.collection('devices').doc(id).delete().whenComplete(() => showToast(color: Colors.green, msg: 'device_has_been_deleted'.tr)
        );
      } else {
        showToast(color: Colors.red, msg: 'something_went_wrong_please_try_later_again'.tr);
      }
    } catch (e) {
      showToast(color: Colors.red, msg: 'something_went_wrong_please_try_later_again'.tr);

    }
  }
  // store profile part;
   createStoreProfile(Store store)async{
     isLoading(true);
     try {
       await firebaseFirestore
           .collection('store')
           .doc('details')
           .set(store.toJson())
           .whenComplete(() async {
         showToast(color: Colors.green, msg: 'data_has_been_updated'.tr);

         Get.offAllNamed(dashboardScreen);

       });
       isLoading(false);
     } catch (e) {
       isLoading(true);

       showToast(color: Colors.red, msg: 'Error ${e.toString()}');

     }
     isLoading(true);
   }
  fetchStoreDetails() {
    var snapshot = firebaseFirestore
        .collection('store').doc('details').get();
    snapshot.then((value){
      if(value.exists){
        store = Store(name:  value.data()!['name'],
            facebook:  value.data()!['facebook'],
            phone: value.data()!['phone'],
            location: value.data()!['location']);
      }else{
          store = Store(name: '', facebook: '', phone: '',
              location: '');
      }

    });

  }
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

}
