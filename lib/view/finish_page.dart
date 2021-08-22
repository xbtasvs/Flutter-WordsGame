//'Brush font'

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import 'package:words/const/screen_size.dart';
import 'package:words/model/score_model.dart';
import 'package:words/view/main_page.dart';
import 'package:words/const/images_name.dart';

class FinishPage extends StatefulWidget {
  final scorelist;
  FinishPage({Key? key, @required this.scorelist}) : super(key: key);
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  List<ScoreModel> scorelist = [];
  List winnerNameList = [];

  @override
  void initState() {
    scorelist = widget.scorelist;
    // Map map = scorelist.asMap();
    // print(map);
    scorelist.sort((a, b) => b.score.compareTo(a.score));
    print(scorelist);

    // list.sortedBy((it) => it.name);
    //map.sort((Map u1, Map u2) => u2['score'] - u1['score']);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Get.offAll(() => MainPage()),
        tooltip: 'Close app',
        child: new Icon(Icons.home),
        backgroundColor: Colors.pink[800],
      ),
      body: _pageBody(context),
      backgroundColor: Colors.brown[300],
    );
  }

  Widget _pageBody(context) {
    scorelist.sort((a, b) => b.score.compareTo(a.score));
    print(scorelist);
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        width: wp(100),
        height: hp(100),
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.red,
              Colors.blue
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Lottie.asset('assets/lotte/winner.json', fit: BoxFit.cover),
            Container(
              height: hp(40),
              width: wp(100),
              child: Lottie.asset('assets/lotte/winner.json'),
            ),
            Text(
              'Congratulations ',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'RobotoMono',
                fontSize: 40,
              ),
            ),
            Text(
              scorelist[0].userName + ' !',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'RobotoMono',
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(
              width: wp(80),
              height: hp(40),
              child: Card(
                margin: EdgeInsets.all(10),
                color: Colors.green[100],
                shadowColor: Colors.blueGrey,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Score',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(
                      scorelist.length,
                      (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Row(
                              children: [
                                Text(
                                  ' ' + scorelist[index].userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  scorelist[index].score.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                if (index == 0)
                                  Icon(
                                    Icons.star,
                                    size: 24,
                                    color: Colors.yellow,
                                  ),
                                if (index == 1)
                                  Icon(
                                    Icons.star,
                                    size: 24,
                                    color: Colors.grey[50],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
