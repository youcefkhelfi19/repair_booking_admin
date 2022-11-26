import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../helper/app_colors.dart';
import '../../../helper/app_routes.dart';
import '../../widgets/dote_title.dart';
import '../../widgets/page_view_dote.dart';
import '../../widgets/toast.dart';
import 'custom_page_view.dart';


class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  late PageController pageController;
   int activeStep =0;
  @override
  void initState() {

    pageController = PageController(initialPage:0)
      ..addListener(() {

        setState(() {});
      });


    super.initState();
  }
  DateTime backPress = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        final difference = DateTime.now().difference(backPress);
        final isExitWarning = difference>=const Duration(seconds:2);
        backPress = DateTime.now();
        if(isExitWarning){
          showToast(msg: 'press_again_to_dashboard'.tr, color:blue);
          return false;
        }else{
          Get.offAllNamed(dashboardScreen);
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title:  Text('add_device'.tr),
          leading: IconButton(
            icon: const Icon(Ionicons.arrow_back),
            onPressed: (){
              Get.offAllNamed(dashboardScreen);
            },
          ),

        ),
        body: Column(
          children: [
            buildPagesStepper(),
            Expanded(
               flex: 4,
                child: CustomPageView(pageController: pageController,)),
          ],
        ),
      ),
    );
  }

  Expanded buildPagesStepper() {
    return Expanded(
         child:Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: SizedBox(
            height: 70,
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.09),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PageViewDote(text: '01',
                        color: pageController.hasClients ? pageController.page!>= 0 ? mainColor : blue:mainColor ,
                      ),
                       Expanded(
                        child: Divider(
                          thickness: 5,
                          color: pageController.hasClients ? pageController.page!>= 1? mainColor :blue:blue,
                        ),
                      ),PageViewDote(text: '02',
                        color: pageController.hasClients ? pageController.page!>= 1? mainColor :blue:blue ,

                      ),
                       Expanded(
                        child: Divider(
                          thickness: 5,
                          color: pageController.hasClients ? pageController.page!>= 2? mainColor :blue:blue,
                        ),
                      ),PageViewDote(text: '03',
                        color: pageController.hasClients ? pageController.page!>= 2? mainColor : blue:blue ,

                      ),
                       Expanded(
                        child: Divider(
                          thickness: 5,
                          color: pageController.hasClients ? pageController.page!>= 3? mainColor :blue:blue,
                        ),
                      ),PageViewDote(text: '04',
                        color: pageController.hasClients ? pageController.page!>= 3? mainColor : blue:blue ,

                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:   [

                      DoteTitle(
                        title: 'pictures'.tr,
                        color: pageController.hasClients ? pageController.page!>= 0? mainColor : blue:mainColor ,

                      ),
                      DoteTitle(
                        title: 'brand'.tr,
                        color: pageController.hasClients ? pageController.page!>= 1? mainColor : blue:blue ,

                      ),
                      DoteTitle(
                        title: 'issue'.tr,
                        color: pageController.hasClients ? pageController.page!>= 2? mainColor : blue:blue ,

                      ),
                      DoteTitle(
                        title: 'owner'.tr,
                        color: pageController.hasClients ? pageController.page!>= 3? mainColor : blue:blue ,

                      ),

                    ],),
                )



              ],
            ),
          ),
        )
        );
  }
}





