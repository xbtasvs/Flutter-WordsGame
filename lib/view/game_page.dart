import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_button/animated_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';

//audio
import 'dart:async';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as ap;

import 'package:words/const/images_name.dart';
import 'package:words/const/screen_size.dart';
import 'package:words/model/score_model.dart';
import 'package:words/view/finish_page.dart';
import 'package:words/view/main_page.dart';
import 'package:words/const/game_setting.dart';
import 'package:words/view_model/game_page_model.dart';

class GamePage extends StatefulWidget {
  final selectedPlayers;
  // final void Function(String path) onStop;

  GamePage({Key? key, @required this.selectedPlayers}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GamePageModel _viewModel = Get.put(GamePageModel());

  List selectedPlayers = [];
  List<ScoreModel> scorelist = [];
  Rx<bool> isLoadedFirebase = true.obs;
  int current_round = 1;
  int current_palyer_index = 0;
  bool is_Started = false;
  bool is_paused = false;
  var challenge_winner_index = 0;
  int image_index = 0;
  // audio record
  final _audioRecorder = Record();
  ap.AudioSource? audioSource;
  CountDownController _controller = CountDownController();

  @override
  void initState() {
    //_viewModel.onInit();

    //  print(_viewModel.firebase_words);
    selectedPlayers = widget.selectedPlayers;
    for (var i = 0; i < selectedPlayers.length; i++) {
      ScoreModel thisScore = ScoreModel(
        userId: selectedPlayers[i].id,
        userName: selectedPlayers[i].name,
        score: 0,
      );

      scorelist.add(thisScore);
    }

    super.initState();
  }

  @override
  void dispose() {
    //audio record
    _audioRecorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
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
        body: (Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green, Colors.blue])),
          child: _gameBody(context, constraints),
        )),
      );
    });
  }

  Widget _gameBody(context, constraints) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          _headerSection(context),
          _bodySection(context, constraints),
        ],
      ),
    );
  }

  Widget _headerSection(context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                height: hp(10),
                width: wp(10),
                child: Lottie.asset(
                    'assets/lotte/rounded-square-spin-loading.json'),
              ),
              Text(
                ' Round $current_round',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Text(
          selectedPlayers[current_palyer_index].name,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _bodySection(context, constraints) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    //print(_viewModel.firebase_words);
    String imgurl = '';
    if (_viewModel.firebase_words.length > 0) {
      imgurl = _viewModel.firebase_words[image_index].letter;
    }

    if (is_Started) {
      return SafeArea(
        child: Center(
          child: Column(
            children: [
              // Image(
              //   image: FirebaseImage(
              //       "gs://words-e735d.appspot.com/Australia_1.jpg",
              //       shouldCache:
              //           true, // The image should be cached (default: True)
              //       maxSizeBytes:
              //           3000 * 1000, // 3MB max file size (default: 2.5MB)
              //       cacheRefreshStrategy:
              //           CacheRefreshStrategy.NEVER // Switch off update checking
              //       ),
              //   width: 100,
              // ),
              CircularCountDownTimer(
                // Countdown duration in Seconds.
                duration: GameSetting.round_duration,

                // Countdown initial elapsed Duration in Seconds.
                initialDuration: 0,

                // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                controller: _controller,

                // Width of the Countdown Widget.
                width: wp(30),

                // Height of the Countdown Widget.
                height: hp(30),

                // Ring Color for Countdown Widget.
                ringColor: Colors.grey[300]!,

                // Ring Gradient for Countdown Widget.
                ringGradient: null,

                // Filling Color for Countdown Widget.
                fillColor: Colors.purpleAccent[100]!,

                // Filling Gradient for Countdown Widget.
                fillGradient: null,

                // Background Color for Countdown Widget.
                backgroundColor: Colors.purple[500],

                // Background Gradient for Countdown Widget.
                backgroundGradient: null,

                // Border Thickness of the Countdown Ring.
                strokeWidth: 20.0,

                // Begin and end contours with a flat edge and no extension.
                strokeCap: StrokeCap.round,

                // Text Style for Countdown Text.
                textStyle: TextStyle(
                    fontSize: 33.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),

                // Format for the Countdown Text.
                textFormat: CountdownTextFormat.S,

                // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                isReverse: true,

                // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                isReverseAnimation: false,

                // Handles visibility of the Countdown Text.
                isTimerTextShown: true,

                // Handles the timer start.
                autoStart: true,

                // This Callback will execute when the Countdown Starts.
                onStart: () {
                  // Here, do whatever you want
                  print('Countdown Started');
                  _startRecording();
                },

                // This Callback will execute when the Countdown Ends.
                onComplete: () {
                  // Here, do whatever you want
                  print('Countdown Ended');
                  var random = new Random();
                  int soundNum = random.nextInt(13);
                  playSound(soundNum);
                  _stop();
                  // onStop:
                  // (path) {
                  //   setState(() {
                  //     audioSource = ap.AudioSource.uri(Uri.parse(path));
                  //   });
                  // };

                  _markScoreModal(context, constraints);
                },
              ),
              is_paused == false
                  ? AnimatedButton(
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
                              'Challenge',
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
                        _pause();
                      },
                      shadowDegree: ShadowDegree.light,
                      color: Colors.red,
                      width: 200,
                      height: 50,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AnimatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(width: 3),
                                Icon(
                                  Icons.import_contacts_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  'Dictionary',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                          onPressed: () => _launchURL(),
                          shadowDegree: ShadowDegree.light,
                          color: Colors.red,
                          width: 140,
                          height: 50,
                        ),
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
                                  size: 25,
                                ),
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "Confirm ALERT",
                              desc: "Is '" +
                                  selectedPlayers[challenge_winner_index].name +
                                  "' the winner of this challenge?",
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
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () {
                                    _resume();
                                    Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                )
                              ],
                            ).show();
                          },
                          shadowDegree: ShadowDegree.light,
                          color: Colors.green,
                          width: 140,
                          height: 50,
                        ),
                      ],
                    ),
              is_paused == false
                  ? Container(
                      height: hp(10),
                      width: wp(100),
                      child: Lottie.asset('assets/lotte/speak-wave.json'),
                    )
                  : Text(
                      "Who is the Winner?",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.yellow,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              is_paused == false
                  ? Image(
                      image: FirebaseImage(imgurl,
                          shouldCache:
                              false, // The image should be cached (default: True)
                          maxSizeBytes:
                              3000 * 1000, // 3MB max file size (default: 2.5MB)
                          cacheRefreshStrategy: CacheRefreshStrategy
                              .NEVER // Switch off update checking
                          ),
                      width: wp(50),
                    )
                  : SizedBox(
                      width: wp(60),
                      height: hp(28),
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
                          child: Column(
                            children: <Widget>[
                              for (int i = 0; i < selectedPlayers.length; i++)
                                ListTile(
                                  title: Text(
                                    selectedPlayers[i].name,
                                  ),
                                  leading: Radio(
                                    value: i,
                                    groupValue: challenge_winner_index,
                                    activeColor: Color(0xFF6200EE),
                                    onChanged: (var value) {
                                      setState(() {
                                        challenge_winner_index = i;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: hp(50),
                width: wp(80),
                child: Lottie.asset('assets/lotte/ready.json'),
              ),
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
                  isLoadedFirebase.value = false;

                  setState(() {
                    // audio record start
                    image_index++;
                    _viewModel.getWords();
                    is_Started = true;
                  });
                  Future.delayed(const Duration(seconds: 6), () {
                    setState(() {
                      is_Started = true;
                      isLoadedFirebase.value = true;
                    });
                  });
                },
                shadowDegree: ShadowDegree.light,
                color: Colors.green,
                width: 200,
                height: 50,
              ),
              Visibility(
                child: CupertinoActivityIndicator(
                  radius: 7,
                ),
                visible: (isLoadedFirebase.value == false),
              ),
            ],
          ),
        ),
      );
    }
  }

  _markScoreModal(context, constraints) {
    final scoreTextControllor = TextEditingController();
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    showGeneralDialog(
      context: context,
      barrierDismissible:
          false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(
          milliseconds:
              500), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Scaffold(
          backgroundColor: Colors.white.withOpacity(0.90),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Colors.deepOrangeAccent, Colors.green]),
            ),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        SizedBox(height: hp(3)),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: hp(10),
                                width: wp(10),
                                child: Lottie.asset(
                                    'assets/lotte/rounded-square-spin-loading.json'),
                              ),
                              Text(
                                ' Round $current_round',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: AnimatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(width: 3),
                                  Text(
                                    'Fact',
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
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Fact",
                                desc:
                                    _viewModel.firebase_words[image_index].fact,
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                    color: Colors.green,
                                  )
                                ],
                              ).show();
                            },
                            shadowDegree: ShadowDegree.light,
                            color: Colors.red,
                            width: 200,
                            height: 50,
                          ),
                        ),
                        SizedBox(height: hp(2)),
                        Center(
                          child: AnimatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(width: 3),
                                  Container(
                                    height: hp(10),
                                    width: wp(10),
                                    child: Lottie.asset(
                                        'assets/lotte/check_audio.json'),
                                  ),
                                  Text(
                                    'Check Record',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                ],
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return MyDialog(audioSource);
                                  });
                            },
                            shadowDegree: ShadowDegree.light,
                            color: Colors.green,
                            width: 200,
                            height: 50,
                          ),
                        ),
                        SizedBox(height: hp(3)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Center(
                                      widthFactor: 1,
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
                                        Text(
                                          scorelist[index].userName,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          scorelist[index].score.toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: hp(1)),
                        Center(
                          child: Text(
                            "Enter " +
                                selectedPlayers[current_palyer_index].name +
                                "'s score.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Overpass',
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(height: hp(2)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: wp(50),
                                child: TextField(
                                  controller: scoreTextControllor,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              AnimatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'Mark',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  if (scoreTextControllor.text.length > 0) {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "Confirm ALERT",
                                      desc: "Would you like to mark?",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          gradient: LinearGradient(colors: [
                                            Color.fromRGBO(116, 116, 191, 1.0),
                                            Color.fromRGBO(52, 138, 199, 1.0),
                                          ]),
                                        ),
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              int new_score = int.parse(
                                                  scoreTextControllor.text);
                                              new_score = new_score +
                                                  scorelist[
                                                          current_palyer_index]
                                                      .score;
                                              ScoreModel newScore = ScoreModel(
                                                userId: selectedPlayers[
                                                        current_palyer_index]
                                                    .id,
                                                userName: selectedPlayers[
                                                        current_palyer_index]
                                                    .name,
                                                score: new_score,
                                              );
                                              scorelist[current_palyer_index] =
                                                  newScore;
                                              scoreTextControllor.clear();
                                            });
                                            Alert(
                                              context: context,
                                              type: AlertType.success,
                                              title: "Success",
                                              desc: "Marked successfully.",
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  width: 120,
                                                  color: Colors.green,
                                                )
                                              ],
                                            ).show();
                                          },
                                          color:
                                              Color.fromRGBO(0, 179, 134, 1.0),
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: "Warning",
                                        desc: "Insert score first!",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(
                                                  116, 116, 191, 1.0),
                                              Color.fromRGBO(52, 138, 199, 1.0),
                                            ]),
                                          ),
                                        ]).show();
                                  }
                                },
                                shadowDegree: ShadowDegree.light,
                                color: Colors.green,
                                width: 100,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: hp(3)),
                        Center(
                          child: AnimatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(width: 3),
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (current_round < GameSetting.max_round) {
                                  if (current_palyer_index <
                                      selectedPlayers.length - 1) {
                                    current_palyer_index++;
                                    is_Started = false;
                                    Navigator.pop(context);
                                  } else {
                                    current_round++;
                                    current_palyer_index = 0;
                                    is_Started = false;
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (current_palyer_index <
                                      selectedPlayers.length - 1) {
                                    current_palyer_index++;
                                    is_Started = false;
                                    Navigator.pop(context);
                                  } else {
                                    //end
                                    Get.to(
                                      () => FinishPage(
                                        scorelist: scorelist,
                                      ),
                                      transition: Transition.fade,
                                    );
                                    //Get.offAll(() => MainPage());
                                  }
                                }
                              });
                            },
                            shadowDegree: ShadowDegree.light,
                            color: Colors.purple,
                            width: 200,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//record
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    // widget.onStop(path!);

    audioSource = ap.AudioSource.uri(Uri.parse(path!));

    print(path);
  }

// game pause | resume
  Future<void> _pause() async {
    await _audioRecorder.pause();
    _controller.pause();

    setState(() => is_paused = true);
  }

  Future<void> _resume() async {
    await _audioRecorder.resume();
    _controller.resume();
    challengeMark();
    setState(() => is_paused = false);
  }

// mark to challenger
  challengeMark() {
    setState(() {
      if (current_palyer_index == challenge_winner_index) {
        //currnet player is winner
        int new_score = 1 + scorelist[current_palyer_index].score;

        ScoreModel winnerScore = ScoreModel(
          userId: selectedPlayers[current_palyer_index].id,
          userName: selectedPlayers[current_palyer_index].name,
          score: new_score,
        );
        scorelist[current_palyer_index] = winnerScore;
      } else {
        print(current_palyer_index);
        print(challenge_winner_index);
        // +1 to challenger
        int new_score = 1 + scorelist[challenge_winner_index].score;

        ScoreModel winnerScore = ScoreModel(
          userId: selectedPlayers[challenge_winner_index].id,
          userName: selectedPlayers[challenge_winner_index].name,
          score: new_score,
        );
        scorelist[challenge_winner_index] = winnerScore;
        // -1 to current
        new_score = -1 + scorelist[current_palyer_index].score;

        ScoreModel faildScore = ScoreModel(
          userId: selectedPlayers[current_palyer_index].id,
          userName: selectedPlayers[current_palyer_index].name,
          score: new_score,
        );
        scorelist[current_palyer_index] = faildScore;
      }
      challenge_winner_index = 0;
    });
  }

  // mark and continue

  markContinue() {
    setState(() {
      // image_index = image_index + 1;
      if (current_round < GameSetting.max_round) {
        if (current_palyer_index < selectedPlayers.length - 1) {
          current_palyer_index++;
          is_Started = false;
          Navigator.pop(context);
        } else {
          current_round++;
          current_palyer_index = 0;
          is_Started = false;
          Navigator.pop(context);
        }
      } else {
        if (current_palyer_index < selectedPlayers.length - 1) {
          current_palyer_index++;
          is_Started = false;
          Navigator.pop(context);
        } else {
          //end
          Get.to(
            () => FinishPage(
              scorelist: scorelist,
            ),
            transition: Transition.fade,
          );
          //Get.offAll(() => MainPage());
        }
      }
    });
  }

  _launchURL() async {
    const url = 'https://thefreedictionary.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void playSound(int number) {
    final player = AudioCache();
    player.play('stop_msc/Stop_$number.mp3');
  }
}

class MyDialog extends StatefulWidget {
  @override
  ap.AudioSource? audioSource;
  MyDialog(this.audioSource);
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _audioPlayer = ap.AudioPlayer();
  static const double _controlSize = 56;
  // audio play

  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  @override
  void initState() {
    //audio play
    _playerStateChangedSubscription =
        _audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });
    _positionChangedSubscription =
        _audioPlayer.positionStream.listen((position) => setState(() {}));
    _durationChangedSubscription =
        _audioPlayer.durationStream.listen((duration) => setState(() {}));
    //audio play
    _audioinit();
    super.initState();
  }

  @override
  void dispose() {
    // audio play
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return AlertDialog(
      content: Column(
        children: [
          Container(
            height: hp(60),
            width: wp(60),
            child: Lottie.asset('assets/lotte/btn_li.json'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildControl(),
              _buildSlider(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.playerState.playing) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;

    final position = _audioPlayer.position;
    final duration = _audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = wp(65) - _controlSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).accentColor,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  //play record

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }

  // audio play
  Future<void> _audioinit() async {
    print(widget.audioSource);
    await _audioPlayer.setAudioSource(widget.audioSource!);
  }
}
