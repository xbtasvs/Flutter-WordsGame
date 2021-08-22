import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_button/animated_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:words/const/images_name.dart';
import 'package:words/const/screen_size.dart';
import 'package:words/model/user_model.dart';
import 'package:words/view/main_page.dart';
import 'package:words/view/game_page.dart';
import 'package:words/view_model/start_page_model.dart';
import 'package:words/const/game_setting.dart';
import 'package:words/view_model/game_page_model.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String new_userName = '';
  StartPageModel _viewModel = Get.put(StartPageModel());
  GamePageModel _gamePageViewModel = Get.put(GamePageModel());

  static const int numItems = 20;
  var allPlayers = [];
  var selectedPlayers = [];
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  void initState() {
    _viewModel.onInit();
    _viewModel.getUserList();
    super.initState();
  }

  final nameTextControllor = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameTextControllor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        //onPressed: () => Get.offAll(() => MainPage()),
        onPressed: () {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Confirm ALERT",
            desc: "Would you like to finish Game?",
            buttons: [
              DialogButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.blueGrey,
              ),
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => Get.offAll(() => MainPage()),
                color: Colors.red,
              )
            ],
          ).show();
        },
        tooltip: 'Close app',
        child: new Icon(Icons.home),
        backgroundColor: Colors.pink[800],
      ),
      body: _startBody(context),
    );
  }

  Widget _startBody(context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: hp(100),
            width: wp(100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.2, 1],
                  colors: [Colors.teal, Colors.green]),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: hp(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: wp(40),
                    child: TextField(
                      controller: nameTextControllor,
                      obscureText: false,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  AnimatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.add_box_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        new_userName = nameTextControllor.text;
                        if (new_userName == '') {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Warning",
                            desc: "Insert the name!",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: Colors.blueGrey,
                              ),
                            ],
                          ).show();
                        } else {
                          _viewModel.addUserName(new_userName);
                          nameTextControllor.clear();

                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Success",
                            desc: "New name of player/team is added.",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _viewModel.getUserList();
                                    selected = List<bool>.generate(
                                        numItems, (int index) => false);
                                    selectedPlayers.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                width: 120,
                                color: Colors.green,
                              )
                            ],
                          ).show();
                        }
                      });
                    },
                    shadowDegree: ShadowDegree.light,
                    color: Colors.green,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              SizedBox(height: hp(1)),
              selectedPlayers.length > 0
                  ? FloatingActionButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Confirm ALERT",
                          desc: "Would you like to delete selected players?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.blueGrey,
                            ),
                            DialogButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                List ids = [];
                                for (var user in selectedPlayers) {
                                  ids.add(user.id);
                                }

                                setState(() {
                                  _viewModel.deleteUser(ids);
                                  _viewModel.getUserList();
                                  selectedPlayers.clear();
                                });
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Success",
                                  desc: "Deleted successfully.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _viewModel.getUserList();
                                          selected = List<bool>.generate(
                                              numItems, (int index) => false);
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      width: 120,
                                      color: Colors.green,
                                    )
                                  ],
                                ).show();
                              },
                              color: Colors.red,
                            )
                          ],
                        ).show();
                      },
                      tooltip: 'Delete names.',
                      child: new Icon(Icons.delete_rounded),
                      backgroundColor: Colors.blue,
                    )
                  : SizedBox(height: hp(8)),
              _viewModel.userList.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: wp(90),
                          height: hp(55),
                          child: Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.green[100],
                            shadowColor: Colors.blueGrey,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _table(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: hp(55),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Enter new player’s name',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontFamily: 'RobotoMono',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'or select from the list',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontFamily: 'RobotoMono',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: hp(40),
                              width: wp(60),
                              child:
                                  Lottie.asset('assets/lotte/select-user.json'),
                            ),
                          ]),
                    ),
              SizedBox(height: hp(2)),
              AnimatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(width: 3),
                      Icon(
                        Icons.star_outline,
                        color: Colors.white,
                        size: 45,
                      ),
                      Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3),
                    ],
                  ),
                ),
                onPressed: () {
                  if (selectedPlayers.length > GameSetting.max_player_num) {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Warning",
                      desc: "Up to " +
                          GameSetting.max_player_num.toString() +
                          " people can participate!",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blueGrey,
                        ),
                      ],
                    ).show();
                  } else if (selectedPlayers.length < 2) {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Warning",
                      desc: "There must be a minimum of 2 players!",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blueGrey,
                        ),
                      ],
                    ).show();
                  } else {
                    print(selectedPlayers.length);

                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Confirm ALERT",
                      desc: "Would you like to start Game?",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () => Navigator.pop(context),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(116, 116, 191, 1.0),
                            Color.fromRGBO(52, 138, 199, 1.0),
                          ]),
                        ),
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            _gamePageViewModel.getWords();
                            Get.to(
                              () => GamePage(
                                selectedPlayers: selectedPlayers,
                              ),
                              transition: Transition.fade,
                            );
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        )
                      ],
                    ).show();
                  }
                },
                shadowDegree: ShadowDegree.light,
                color: Colors.blue,
                width: 150,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _table() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Select the name (' +
                selectedPlayers.length.toString() +
                '/' +
                _viewModel.userList.length.toString() +
                ')',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
      ],
      rows: List<DataRow>.generate(
        _viewModel.userList.length,
        (int index) => DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // All rows will have the same selected color.
            if (states.contains(MaterialState.selected)) {
              return Colors.blue.withOpacity(0.2);
            }
            // Even rows will have a grey color.
            if (index.isEven) {
              return Colors.grey.withOpacity(0.3);
            }
            return null; // Use default value for other states and odd rows.
          }),
          cells: <DataCell>[
            DataCell(Text(
              _viewModel.userList[index].name,
              style: TextStyle(
                fontSize: 20,
              ),
            ))
          ],
          selected: selected[index],
          onSelectChanged: (bool? value) {
            setState(() {
              selected[index] = value!;

              if (selected[index] == true) {
                selectedPlayers.add(_viewModel.userList[index]);
              } else {
                selectedPlayers.remove(_viewModel.userList[index]);
              }
            });
          },
        ),
      ),
    );
  }
}
