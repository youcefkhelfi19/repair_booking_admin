import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../models/device_model.dart';
import '../../models/status_model.dart';
import '../../services/device_status.dart';
import '../widgets/buttons/delete_btn.dart';
import '../widgets/buttons/status_btn.dart';
import '../widgets/device_card.dart';
import '../widgets/empty_msg.dart';

class DevicesList extends StatefulWidget {
  const DevicesList({Key? key, required this.index}) : super(key: key);
  final int index ;
  @override
  State<DevicesList> createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> with TickerProviderStateMixin {
  late TabController tabController ;
  final firebaseController = Get.find<FirebaseController>();
  TextEditingController searchController = TextEditingController();
  List searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    tabController = TabController(length: 4,vsync:this,initialIndex: widget.index );
    firebaseController.fetchDevicesBySSearching();
    super.initState();
  }
  searchDevice(String name){
    searchList= firebaseController.devices.where((deviceModel) => deviceModel.model.toLowerCase().startsWith(name)).toList();
    setState(() {

    });
  }
  searchArea(){
    return  TextField(
      controller: searchController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration:  InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: 'search_by_model'.tr,
          hintStyle: const TextStyle(color: Colors.white38,fontSize: 14),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none
      ),
      onChanged: (value)=>searchDevice(value),
    );

  }
  @override
  void dispose() {
    searchController.dispose() ;
    searchList.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(

          title: isSearching? searchArea():Text('devices_list'.tr),
          actions: [
            IconButton(onPressed:(){
              searchList.clear();
              searchController.clear();
              setState((){
                isSearching =!isSearching;


              });

            },
                icon:isSearching?const Icon(Ionicons.close,color: Colors.white,): const Icon(Ionicons.search,color: Colors.white,)

            )
          ],
        ),
        body: isSearching?SizedBox.expand(
          child:searchList.isEmpty? const EmptyListMsg(): ListView.builder(
              itemCount: searchList.length,
              itemBuilder:
                  (context,index){

                return DeviceCard(device: searchList[index],);
              }),
        ):Column(
          children: [
            ButtonsTabBar(
              controller: tabController,
              backgroundColor: mainColor,
              unselectedBackgroundColor: Colors.grey[300],
              unselectedLabelStyle: const TextStyle(color: mainColor),

              labelStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              tabs: statusList.map<Widget>((Status status) {
                return Tab(
                  text: status.title.tr,
                  icon: Icon(
                    status.icon,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
            Expanded(

              child: TabBarView(
                controller: tabController,
                children: statusList.map<Widget>((Status status) {

                  return StreamBuilder<QuerySnapshot>(
                    stream: firebaseController.fetchDevicesByStatus(status.title,),
                    builder: (context, snapshot) {
                      print(snapshot);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {


                        if (snapshot.data!.docs.isEmpty) {
                          return const EmptyListMsg();

                        } else {
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
                                return snapshot.data!.docs[index]['storing'] == 'Delivered'?const SizedBox(): Slidable(
                                    key: const ValueKey(5),
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
                                    startActionPane:  ActionPane(
                                      motion: const ScrollMotion(),
                                      dismissible: DismissiblePane(onDismissed: () {
                                        firebaseController.updateField(fieldValue:device.repairingStatus == 'Pending'? 'In Progress':device.repairingStatus =='In Progress'?'Completed':'Cancelled',
                                            device:device, field: 'repairing' );

                                      }),
                                      children:  [

                                        device.repairingStatus == 'Pending'?StatusIconBtn(
                                          device:device ,
                                          iconData: Ionicons.checkmark_circle_outline,
                                          firebaseController: firebaseController,
                                          value: 'Completed',): const Expanded(
                                            flex: 1,
                                            child: SizedBox(width: 0.0,)),
                                        device.repairingStatus == 'Pending' || device.repairingStatus == 'In Progress'?  StatusIconBtn(
                                          device:device,
                                          iconData: Ionicons.close_circle_outline,
                                          firebaseController: firebaseController,
                                          value: 'Cancelled',):const Expanded(
                                            flex: 1,
                                            child: SizedBox(width: 0.0,)),
                                        //

                                      ],
                                    ),
                                    child: DeviceCard(device: device,));
                              });

                        }
                      }
                      return Center(
                          child:  Text(
                            'something_went_wrong'.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ));
                    },
                  );
                }).toList(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
