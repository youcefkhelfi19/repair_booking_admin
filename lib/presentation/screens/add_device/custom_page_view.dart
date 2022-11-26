import 'package:flutter/material.dart';
import 'package:repair_booking_admin/presentation/screens/add_device/upload_images.dart';

import 'brand_model.dart';
import 'device_problem.dart';
import 'owner_details.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView({Key? key,required this.pageController}) : super(key: key);
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        UploadImages(pageController: pageController,),
         BrandAndModel(pageController: pageController),
        DeviceProblem(pageController: pageController),
        OwnerDetails(pageController: pageController),
      ],
    );
  }
}
