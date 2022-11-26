import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../models/device_model.dart';
import '../widgets/buttons/delete_btn.dart';
import '../widgets/device_card.dart';
import '../widgets/empty_msg.dart';
import '../widgets/toast.dart';

class DeliveredDevices extends StatefulWidget {
  const DeliveredDevices({Key? key}) : super(key: key);

  @override
  State<DeliveredDevices> createState() => _DeliveredDevicesState();
}

class _DeliveredDevicesState extends State<DeliveredDevices> {
  final firebaseController = Get.find<FirebaseController>();
  bool isDeleting = false;
   late QuerySnapshot snapshotData ;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title:  Text('delivered_devices'.tr),
            actions: [
              TextButton(
                  onPressed: (){
                  deleteDevices();},
                  child: const Text('Clear',style: TextStyle(color: blue),))
            ],
          ),
          body:StreamBuilder<QuerySnapshot>(
            stream: firebaseController.fetchDeliveredDevices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState ==
                  ConnectionState.active) {


                if (snapshot.data!.docs.isNotEmpty) {
                    snapshotData = snapshot.data!;
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext ctx, index) {

                        Device device = Device(
                          deviceId: snapshot.data!.docs[index].id,
                          brand: snapshot.data!.docs[index]['brand'],
                          model: snapshot.data!.docs[index]['model'],
                          serial: snapshot.data!.docs[index]['serial'],
                          repairingStatus: snapshot.data!.docs[index]['repairing'],
                          description: snapshot.data!.docs[index]['description'],
                          images: snapshot.data!.docs[index]['images'],
                          address: snapshot.data!.docs[index]['address'],
                          phone: snapshot.data!.docs[index]['phone'],
                          dateTime: snapshot.data!.docs[index]['date'],
                          issue: snapshot.data!.docs[index]['issue'],
                          ownerName: snapshot.data!.docs[index]['owner'],
                          security: snapshot.data!.docs[index]['security'],
                          uploadedBy: snapshot.data!.docs[index]['by'],
                          storingStatus: snapshot.data!.docs[index]['storing'],
                          completedNote: snapshot.data!.docs[index]['completed_note'],
                          repairingPrice: snapshot.data!.docs[index]['price'],
                          accessories: snapshot.data!.docs[index]['accessories'],
                          cancelledNote: snapshot.data!.docs[index]['cancelled_note'],
                          inProgressNote: snapshot.data!.docs[index]['progress_note'],
                          returnedNote: snapshot.data!.docs[index]['returned_note'],
                        );
                        return  Slidable(
                            key: const ValueKey(2),

                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                firebaseController.deleteDevice(id: device.deviceId, urls: device.images);

                              }),
                              children:  [
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: DeleteButton(
                                    id: device.deviceId,
                                    images: device.images,
                                    firebaseController: firebaseController,
                                  ),
                                ),
                                const Spacer(),

                              ],
                            ),
                            child: DeviceCard(device: device,));
                      });
                } else {
                  return const EmptyListMsg();
                }
              }
              return  Center(
                  child:  Text(
                    'something_went_wrong'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ));
            },
          )
        ),
        isDeleting?SizedBox.expand(
          child: Container(
              alignment: Alignment.center,
              color: Colors.black12,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                content: Row(
                  children: [
                    const CircularProgressIndicator(color: mainColor,),
                    const SizedBox(width: 10,),
                    Text('deleting_devices'.tr)
                  ],
                ),
              )
          ),
        ):const SizedBox(),
      ],
    );
  }
  deleteDevices()async{
setState(() {
  isDeleting = true;
});
   try{
     for(var item in snapshotData.docs){
       firebaseController.deleteDevice(id: item.id, urls:item['images']);
     }
   }catch(e){
     showToast(msg: 'no_data_to_delete'.tr, color: blue);
   }
setState(() {
  isDeleting = false;
});
  }
}
