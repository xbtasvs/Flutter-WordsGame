import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

import 'package:words/const/help_text.dart';
import 'package:words/const/images_name.dart';
import 'package:words/const/screen_size.dart';
import 'package:words/view/main_page.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  //HelpPageModel _viewModel = Get.put(HelpPageModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Get.offAll(() => MainPage()),
        tooltip: 'Close app',
        child: new Icon(Icons.home),
        backgroundColor: Colors.pink[800],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesName.helpTxtIcon,
              width: wp(6),
              height: hp(6),
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: wp(5),
            ),
            Text(
              'How to play',
              style: TextStyle(
                fontSize: 37,
                fontFamily: 'Fredoka One',
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Get.offAll(
              () => MainPage(),
            );
          },
          child: Icon(
            CupertinoIcons.back,
            size: 32,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[0],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(2)),
            Center(
              child: Image.asset(
                ImagesName.helpImage1,
                width: wp(90),
                height: hp(40),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: hp(2)),
            Text(
              HelpText.text[1],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[2],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[3],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[4],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(2)),
            Center(
              child: Image.asset(
                ImagesName.helpImage2,
                width: wp(90),
                height: hp(40),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: hp(2)),
            Text(
              HelpText.text[5],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[6],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[7],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(2)),
            Center(
              child: Image.asset(
                ImagesName.helpImage3,
                width: wp(90),
                height: hp(40),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: hp(2)),
            Text(
              HelpText.text[8],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(2)),
            Center(
              child: Image.asset(
                ImagesName.helpImage4,
                width: wp(90),
                height: hp(40),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: hp(2)),
            Text(
              HelpText.text[9],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[10],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[11],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[12],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: hp(1)),
            Text(
              HelpText.text[13],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.purple[700],
    );
  }
}
