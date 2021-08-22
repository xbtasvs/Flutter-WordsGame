import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:words/view_model/main_page_model.dart';
import 'package:words/view/splash_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Words',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashPage(),
      initialBinding: InitialBindings(),
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainPageModel());
  }
}
