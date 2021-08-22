import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:words/const/screen_size.dart';
import 'package:words/main.dart';
import 'package:words/view/main_page.dart';
import 'package:words/const/images_name.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    navigateToHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: hp(100),
              width: wp(100),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(ImagesName.splashImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: new Container(
                  decoration:
                      new BoxDecoration(color: Colors.white.withOpacity(.2)),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                ImagesName.logoIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomePage() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offAll(() => MainPage(), binding: InitialBindings());
  }
}
