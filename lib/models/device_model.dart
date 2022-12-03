import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Device> deviceFromJson(String data) => List<Device>.from(json.decode(data).map((x) => Device.fromJson(x)));

String deviceToJson(List<Device> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Device {
  Device({
    required this.deviceId,
    required this.brand,
    required this.model,
    required this.repairingStatus,
    required this.description,
    required this.images,
    required this.address,
    required this.phone,
    required this.dateTime,
    required this.issue,
    required this.ownerName,
    required this.security,
    required this.serial,
    required this.uploadedBy,
    required this.storingStatus,
    required this.completedNote,
    required this.repairingPrice,
    required this.accessories,
    required this.cancelledNote,
    required this.inProgressNote,
    required this.returnedNote

  });

  String deviceId;
  String serial;
  String brand;
  String model;
  String issue;
  String description;
  List images;
  String repairingStatus ;
  String security;
  String ownerName;
  String phone;
  String address;
  String uploadedBy;
  String dateTime;
  String repairingPrice;
  String completedNote;
  String storingStatus;
  String accessories;
  String cancelledNote;
  String inProgressNote;
  String returnedNote;



  factory Device.fromJson(Map<String, dynamic> json) => Device(
      deviceId: json["id"],
      brand: json["brand"],
      model: json["model"],
      issue: json["issue"],
      serial: json["serial"],
      security: json["security"],
      ownerName: json["owner"],
      phone: json["phone"],
      address: json["address"],
      uploadedBy: json["by"],
      dateTime: json["date"],
      description: json["description"],
      images: json["images"],
      repairingStatus: json["repairing"],
      storingStatus: json["storing"],
      completedNote: json["completed_note"],
      accessories: json["accessories"],
      repairingPrice: json["price"],
      cancelledNote: json["cancelled_note"],
      inProgressNote: json["progress_note"],
      returnedNote: json["returned_note"]


  );

  Map<String, dynamic> toJson() => {
    "id": deviceId,
    "brand": brand,
    "model": model,
    "description": description,
    "images": images,
    "issue": issue,
    "repairing" : repairingStatus,
    "security" : security,
    "owner" :ownerName,
    "phone" : phone,
    "serial":serial,
    "address" : address,
    "by" : uploadedBy,
    "date": dateTime,
    "storing":storingStatus,
    "completed_note":completedNote,
    "accessories":accessories,
    "price":repairingPrice,
    "cancelled_note":cancelledNote,
    "progress_note":inProgressNote,
    "returned_note":returnedNote

  };
}