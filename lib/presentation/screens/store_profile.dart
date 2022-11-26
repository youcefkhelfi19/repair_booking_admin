import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/firebase_db_controller.dart';
import '../../helper/app_colors.dart';
import '../../models/store_model.dart';
import '../widgets/custom_input_field.dart';

class StoreProfile extends StatefulWidget {
  const StoreProfile({Key? key, required this.store}) : super(key: key);
  final Store store;
  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile> {

  late TextEditingController nameController = TextEditingController() ;

   late TextEditingController fbController = TextEditingController();

   late TextEditingController phoneController = TextEditingController();


   late TextEditingController locationController = TextEditingController();
   bool isLoading = false;
   FirebaseController firebaseController = Get.find<FirebaseController>();
   GlobalKey<FormState> formKey = GlobalKey();
    @override
  void initState() {
    initialControllers();
    super.initState();
  }
  initialControllers(){
    Store store = widget.store;
    nameController.text = store.name;
    fbController.text = store.facebook;
    phoneController.text = store.phone;
    locationController.text = store.location;
  }
   @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('store_profile'.tr),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const SizedBox(height: 100,),
                    CustomInputField(
                      hint:'store_name'.tr,
                      controller: nameController,
                      validator: (value){
                        if(value.toString().isEmpty){
                          return 'Please add store name';
                        }else{
                          return null;
                        }
                      },
                    ),
                    CustomInputField(
                      hint:'phone number',
                      controller: phoneController,
                      isNumber: true,
                      validator: (value){
                        if(value.toString().isEmpty){
                          return 'Please add Phone number';
                        }else{
                          return null;
                        }
                      },
                    ),
                    CustomInputField(
                      hint:'facebook page',
                      controller: fbController,
                      validator: (value){

                      },
                    ),
                    CustomInputField(
                      hint:'Location',
                      controller: locationController,
                      validator: (value){

                      },
                    ),
                    const SizedBox(height: 100,),
                    MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: (){
                       if(formKey.currentState!.validate()){
                         setState(() {
                           isLoading = true;
                         });
                         Store store = Store(
                             name: nameController.text,
                             facebook: fbController.text.trim(),
                             phone: phoneController.text.trim(),
                             location: locationController.text.trim());
                         firebaseController.createStoreProfile(store);
                         setState(() {
                           isLoading = false;
                         });
                       }
                      },
                      child: const Text('Update',style: TextStyle(color: Colors.white,fontSize: 20),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        isLoading?SizedBox.expand(
          child: Container(
              alignment: Alignment.center,
              color: Colors.black12,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                content: Row(
                  children: [
                    Image.asset('assets/images/loading.gif',height: 60,width: 60,),
                    const Text('Updating Details')
                  ],
                ),
              )
          ),
        ):const SizedBox(),
      ],
    );
  }
}
