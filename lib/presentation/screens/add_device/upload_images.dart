import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../business_logic/controllers/firebase_db_controller.dart';
import '../../../business_logic/controllers/real_time_db_controller.dart';
import '../../../helper/app_colors.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/buttons/custom_FAB.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/toast.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;
  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  final picker = ImagePicker();
  final RealTimeDbController realTimeDbController = Get.put(RealTimeDbController());
  final FirebaseController firebaseController = Get.put(FirebaseController());
 // List<File> images = [];
  GetStorage storage = GetStorage();
  @override
  void initState() {
    realTimeDbController.readBrands();
    realTimeDbController.readModels();
    firebaseController.images = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:  CustomTopRoundedContainer(
              widget: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: firebaseController.images.length + 1,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,


                ),
                itemBuilder: (context, index) {
                  if (index == firebaseController.images.length) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(3),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: mainColor.withOpacity(0.5),
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => selectImagesFromCamera(),
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: mainColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Container(

                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage(
                                    firebaseController.images[index],
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                          Positioned(
                            top:7,
                            right:7,
                            child: Container(
                              padding:const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white54
                              ),

                              child: InkWell(
                                 onTap:(){
                                   firebaseController.images.removeAt(index);
                                   setState(() {

                                   });
                                   },
                              child: const Icon(Icons.remove_circle_outline,color: mainColor,size: 17,)),
                            ))
                      ],
                    );
                  }
                }, ),
            )
        ),
        floatingActionButton: CustomFloatingButton(
          elevation: firebaseController.images.isEmpty ? 0 : 10,
          opacity: firebaseController.images.isEmpty ? 0.5 : 1,
          onTap: firebaseController.images.isEmpty
              ? () {
                  customDialog(
                      image: 'assets/images/alert.png',
                      message: 'Please take a picture for the device',
                      dismiss: true);
                }
              : () => nextStep(),
        ));
  }
  nextStep(){
     // firebaseController.images = images;
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }


  void selectImagesFromCamera() async {
    if(await Permission.camera.request().isGranted){
      try{
        final pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 25,
        );

        if(pickedImage!.path.isNotEmpty){
          setState(() {
            firebaseController.images.add(File(pickedImage.path));

          });

        }
        print(firebaseController.images);
      }catch(e){
        showToast(msg: e.toString(), color: Colors.red);
      }


    }
  }
}
