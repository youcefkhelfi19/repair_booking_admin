import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../models/device_model.dart';
import '../screens/device_details.dart';


class DeviceCard extends StatelessWidget {
  DeviceCard({
    Key? key, required this.device,
  }) : super(key: key);
  final Device device ;
  final FirebaseController firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: GestureDetector(
        onTap: (){
          Get.to(()=>DeviceDetails(device: device));
        },
        child: Container(

          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),

          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(

                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                  ),
                  child: Center(
                      child: CachedNetworkImage(
                        //  cacheManager: customCacheManager,
                        key: UniqueKey(),
                        imageUrl:device.images[0],
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.low,
                        maxHeightDiskCache: 100,
                        placeholder: (context,url)=>  Container(

                            padding: const EdgeInsets.all(30),
                            child: const CircularProgressIndicator(color: mainColor,)),
                        errorWidget: (context,url,error) => const Icon(Ionicons.alert_circle_outline),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width:180,
                      child: Text('${device.brand} ${device.model}',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style:  const TextStyle(color: Colors.black,fontSize: 16),),
                    ),
                    Text('${'issue'.tr}: ${device.issue}',style: TextStyle(color: Colors.grey.shade500,fontSize: 14),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-117,
                      child: Row(
                        children: [
                          Text('${'status'.tr}: ',style: const TextStyle(color: Colors.black,fontSize: 14),),

                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(device.repairingStatus.tr,style: const TextStyle(color: Colors.white,fontSize: 12),)),
                          const Spacer(),
                          Text('${handleDate()}',style: const TextStyle(color: Colors.grey,fontSize: 10),)

                        ],
                      ),
                    )
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  handleDate(){
    var postIn = DateTime.parse(device.dateTime);
    String postedDate = '${postIn.day}.${postIn.month}.${postIn.year}';
    return postedDate;

  }
}

