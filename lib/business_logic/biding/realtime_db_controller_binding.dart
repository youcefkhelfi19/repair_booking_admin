import 'package:get/get.dart';

import '../controllers/real_time_db_controller.dart';


class RealTimeBbBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>RealTimeDbController());
  }

}