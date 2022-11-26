
import 'package:flutter/animation.dart';
import 'package:get/get.dart';


import '../business_logic/biding/auth_controller_binding.dart';
import '../business_logic/biding/firabase_db_binding.dart';
import '../business_logic/biding/realtime_db_controller_binding.dart';
import '../presentation/screens/add_device/add_device.dart';
import '../presentation/screens/auth_screen.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/splash_screen.dart';
const String splashScreen = '/splash';
const String authScreen = '/auth';
const String dashboardScreen = '/dashboard';
const String addDevice = '/add';
const String newPassword = '/newPassword';
const String cartScreen = '/cart';
const String detailsScreen = '/details';



final List<GetPage> appPages = [
  GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transitionDuration:
      const Duration(milliseconds: 500),
      curve: Curves.linear,
      transition: Transition.fade,
      binding: AuthControllerBinding()


  ),
  GetPage(
      name: authScreen,
      page: () =>  AuthScreen(),
      transitionDuration:
      const Duration(milliseconds: 500),
      curve: Curves.linear,
      transition: Transition.fade,

  ),
  GetPage(
      name: dashboardScreen,
      page: () =>  const DashboardScreen(),
      transitionDuration:
      const Duration(milliseconds: 500),
      curve: Curves.linear,
      transition: Transition.fade,
      binding:FirebaseBinding()

  ),

  GetPage(
      name: addDevice,
      page: () => const AddDevice(),
      transitionDuration:
      const Duration(milliseconds: 500),
      curve: Curves.linear,
      transition: Transition.fade,
      binding:RealTimeBbBinding()

  ),



];
