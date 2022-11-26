import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/global_constants.dart';
import '../../models/device_model.dart';
import '../../services/firebase_notification.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/buttons/delete_btn.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/toast.dart';

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({Key? key, required this.device}) : super(key: key);
  final Device device;

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  FirebaseController firebaseController = Get.put(FirebaseController());
  int _currentIndex = 0;
  late String postedDate = '';
  late String postedTime = '';
  late String repairingStatus = '';
  late String storingStatus = '';

  TextEditingController priceController = TextEditingController();
  TextEditingController completedNoteController = TextEditingController();
  TextEditingController cancelledNoteController = TextEditingController();
  TextEditingController progressNoteController = TextEditingController();
  TextEditingController returnedNoteController = TextEditingController();

  @override
  void initState() {
    handleDate();
    repairingStatus= widget.device.repairingStatus;
    storingStatus = widget.device.storingStatus;
    returnedNoteController.text = widget.device.returnedNote;
    priceController.text = widget.device.repairingPrice;
    completedNoteController.text = widget.device.completedNote;
    cancelledNoteController.text = widget.device.cancelledNote;
    progressNoteController.text = widget.device.inProgressNote;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height*0.6,
            pinned: true,
            stretch: true,
            actions: [
              repairingStatus == 'Pending'
                  ? IconButton(
                  onPressed: () {
                    firebaseController.generateReceipt(widget.device);
                  },
                  icon: const Icon(Ionicons.document_text_outline))
                  : SizedBox(
                child: repairingStatus == 'Completed'
                    ? IconButton(
                    onPressed: () {
                      firebaseController.generateInvoice(widget.device,priceController.text);

                    },
                    icon: const Icon(Ionicons.receipt_outline))
                    : null,
              )
            ],
            backgroundColor: mainColor,
            flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  height: MediaQuery.of(context).size.height*0.65,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(
                          () {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
                items: widget.device.images
                    .map((item) => CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: item,
                  height: MediaQuery.of(context).size.height*0.65,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  maxHeightDiskCache: 400,
                  filterQuality: FilterQuality.low,
                  placeholder: (context, url) => Container(
                      color: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 160, horizontal: 100),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      )),
                  errorWidget: (context, url, error) =>
                  const Icon(Ionicons.alert_circle_outline),
                ))
                    .toList(),
              ),
              centerTitle: true,
              title: Text(
                '${widget.device.brand.toUpperCase()} ${widget.device.model.toUpperCase()}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.device.images.map((urlOfItem) {
                    int index = widget.device.images.indexOf(urlOfItem);
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? const Color.fromRGBO(0, 0, 0, 0.8)
                            : const Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${'serial'.tr} :  ${widget.device.serial}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${'security'.tr} :  ${widget.device.security}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${'issue'.tr} : ${widget.device.issue}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${'description'.tr} :  ${widget.device.description}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${'accessories'.tr} : ${widget.device.accessories}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

               Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'repairing_status'.tr,
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                ),
              ),
              repairingStatusSwitch(),
               Padding(
                padding: const EdgeInsets.only(left: 8,top: 10,bottom: 5),
                child: Text(
                  'storing_status'.tr,
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                ),
              ),
              storingStatusSwitch(),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${'uploaded_by'.tr} : ${widget.device.uploadedBy}',
                    ),
                    const SizedBox(height: 5,),
                    Text('${'in'.tr}: $postedDate  $postedTime'),
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
              ),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'device_owner_details'.tr,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              CustomListTile(
                title: 'full_name'.tr,
                subtitle: widget.device.ownerName,
              ),
              CustomListTile(
                title: 'phone_number'.tr,
                subtitle: widget.device.phone,
                trailing: InkWell(
                    onTap: () {
                      firebaseController.makePhoneCall(widget.device.phone);
                    },
                    child: const Icon(
                      Ionicons.call_outline,
                      color: mainColor,
                    )),
              ),
              CustomListTile(title: 'address'.tr, subtitle: widget.device.address),
              const Divider(
                thickness: 3,
              ),
              repairingStatus == "Cancelled"? const SizedBox():completedNoteField(),
             repairingStatus =="Cancelled"?
              cancelledNoteField():
              repairingStatus == "In Progress"?
              inProgressNoteField():repairingStatus == "Pending"&& storingStatus == "Returned"?returnedNoteField():const SizedBox(),
              SizedBox(
                  height: 100,
                  child: DeleteButton(
                    id: widget.device.deviceId,
                    images: widget.device.images,
                    firebaseController: firebaseController,
                  )),


            ]),
          )
        ],
      ),
    );
  }

  CustomRadioButton<String> repairingStatusSwitch() {
    return CustomRadioButton(
              margin: EdgeInsets.zero,
              elevation: 0,
              padding: 0.0,
              width: 80,
              autoWidth: true,
              enableShape: true,
              radius: 10,
              shapeRadius: 10,
              spacing: 1.5,
              height: 40,
              unSelectedBorderColor: blue,
              selectedBorderColor: blue,
              defaultSelected: widget.device.repairingStatus,
              unSelectedColor: Colors.white,
              buttonLables: repairStatusLabels,
              buttonValues: repairStatus,
              buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: mainColor,
                  textStyle: TextStyle(fontSize: 12)),
              radioButtonValue: (value) {
                firebaseController.updateField(
                    fieldValue: value.toString(),
                    id: widget.device.deviceId,
                    field: 'repairing').then((response){
                  if(response == true){
                    repairingStatus =='Completed' || repairingStatus == 'Cancelled'?
                    NotificationsService().sendNotificationViaTopic(device: widget.device, status: repairingStatus):null;

                    setState(() {
                      repairingStatus = value.toString();

                    });
                    repairingStatus == 'Completed'?firebaseController.updateField(
                        fieldValue: 'In Store',
                        id: widget.device.deviceId,
                        field: 'storing').then((response){
                      if(response == true){
                                                    setState(() {
                          storingStatus = 'In Store';
                        });
                      }

                    }):null;

                    value=='Completed'?addPriceAndNote():value == 'Cancelled'?addCancelledNote():null;
                  }

                });

              },
              selectedColor: blue,
            );
  }

  Padding storingStatusSwitch() {
    return Padding(
              padding: const EdgeInsets.only(left: 8,bottom: 10),
              child: Row(
                children: [
                  CustomRadioButton(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    padding: 0.0,
                    width: 80,
                    autoWidth: true,
                    enableShape: true,
                    radius: 10,
                    shapeRadius: 10,
                    spacing: 1.5,
                    height: 40,
                    unSelectedBorderColor: blue,
                    selectedBorderColor: blue,
                    defaultSelected: widget.device.storingStatus,
                    unSelectedColor: Colors.white,
                    buttonLables: storedStatusLabels,
                    buttonValues: storedStatus,
                    buttonTextStyle: const ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: mainColor,
                        textStyle: TextStyle(fontSize: 12)),
                    radioButtonValue: (value) {
                      if(value == 'In Store'){
                        showToast(color: Colors.red, msg: 'option_unavailable'.tr);

                      }else{
                        firebaseController.updateField(
                            fieldValue: value.toString(),
                            id: widget.device.deviceId,
                            field: 'storing').then((response){
                          if(response == true){

                            value=='Returned'?addReturnedNote():repairingStatus == 'Completed'&& value == 'Delivered'?addPriceAndNote():null;
                            setState(() {
                              storingStatus = value.toString();
                            });
                          }

                        });

                      }

                    },
                    selectedColor: blue,
                  ),
                ],
              ),
            );
  }

  Container completedNoteField() {
    return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: blue
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${'price'.tr}: ${priceController.text.isNotEmpty?priceController.text:"0.00"} DA',
                        style: const TextStyle(fontSize: 18),

                      ),
                      const Spacer(),
                      InkWell(
                          onTap:(){
                            addPriceAndNote();
                          }, child:Text('update'.tr,style: const TextStyle(color: blue),))
                    ],
                  ),
                  const Divider(),
                  Text(
                    '${'note'.tr}: ${completedNoteController.text}',
                    style:  TextStyle(fontSize: 16,color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
  }

  Container cancelledNoteField() {
    return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: blue
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'cancelled_reason'.tr,
                        style: const TextStyle(fontSize: 18),

                      ),
                      const Spacer(),
                      InkWell(
                          onTap:(){
                            addCancelledNote();
                          }, child:Text('update'.tr,style: const TextStyle(color: blue),))
                    ],
                  ),
                  Text(
                    cancelledNoteController.text,
                    style:  TextStyle(fontSize: 16,color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
  }

  Container inProgressNoteField() {
    return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: blue
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'note'.tr,
                        style: const TextStyle(fontSize: 18),

                      ),
                      const Spacer(),
                      InkWell(
                          onTap:(){
                            addProgressNote();
                          }, child:Text('update'.tr,style: const TextStyle(color: blue),))
                    ],
                  ),
                  Text(
                    progressNoteController.text,
                    style:  TextStyle(fontSize: 16,color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
  }

  Container returnedNoteField() {
    return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: blue
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'returned_reason'.tr,
                        style: const TextStyle(fontSize: 18),

                      ),
                      const Spacer(),
                      InkWell(
                          onTap:(){
                            addReturnedNote();
                          }, child:Text('update'.tr,style: const TextStyle(color: blue),))
                    ],
                  ),
                  Text(
                    returnedNoteController.text,
                    style:  TextStyle(fontSize: 16,color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
  }
  handleDate() {
    Timestamp postedDateTimeStamp = widget.device.dateTime;
    var postIn = postedDateTimeStamp.toDate();
    postedDate = '${postIn.year}.${postIn.month}.${postIn.day}';
    postedTime = '${postIn.hour}: ${postIn.minute}';
  }
  addPriceAndNote(){
    return  addPriceAndNoteDialog(context: context,
        priceController: priceController,
        noteController: completedNoteController,
        onTap:() {
          firebaseController.updatePriceAndNote(
              price: priceController.text,
              id: widget.device.deviceId,
              note: completedNoteController.text);
          Navigator.pop(context);
          setState(() {

          });
        });
  }
  addCancelledNote(){
    return addNoteDialog(context: context,
        noteController: cancelledNoteController,
        title:'cancelled_reason'.tr,
        hint: 'reason'.tr,
        onTap:(){
          firebaseController.updateField(
              fieldValue:cancelledNoteController.text, id: widget.device.deviceId, field: 'cancelled_note');

          Navigator.pop(context);
          setState(() {

          });
        });
  }
  addReturnedNote(){
    return addNoteDialog(context: context,
        noteController: returnedNoteController,
        title:'returned_reason'.tr,
        hint: 'reason'.tr,
        onTap:(){

          firebaseController.updateField(
              fieldValue:returnedNoteController.text, id: widget.device.deviceId, field: 'returned_note').
          whenComplete(() => firebaseController.updateField(
              fieldValue:'Pending', id: widget.device.deviceId, field: 'repairing')).then((value) {
            setState(() {
              repairingStatus = 'Pending';
            });
          });

          Navigator.pop(context);

        });
  }
  addProgressNote(){
    return addNoteDialog(context: context,
        noteController: progressNoteController,
        title:'in_progress_note'.tr,
        hint: 'note'.tr,
        onTap:(){
            firebaseController.updateField(
                fieldValue:progressNoteController.text, id: widget.device.deviceId, field: 'progress_note');
            Navigator.pop(context);
            setState(() {

            });

        });
  }

}
