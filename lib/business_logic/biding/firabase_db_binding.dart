import 'package:get/get.dart';

import '../controllers/firebase_db_controller.dart';


class FirebaseBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(FirebaseController());

  }

}