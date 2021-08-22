import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

import 'package:words/model/word_model.dart';
import 'package:words/const/game_setting.dart';

class GamePageModel extends GetxController {
  List<WordModel> firebase_words = [];

  @override
  void onInit() {
    getWords();
    super.onInit();
  }

  getWords() async {
    await Firebase.initializeApp();

    // get letter images from firebase
    var collection = FirebaseFirestore.instance.collection('words');
    collection.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((result) {
        List facts = result.data()["facts"];
        List letters = result.data()["letters"];

        letters.forEach((letter) {
          facts.forEach((fact) {
            WordModel newword = WordModel(fact: fact, letter: letter);
            firebase_words.add(newword);
          });
        });
      });
    });

    //make randomly
    var random = new Random();
    int n = firebase_words.length;
    while (n > 1) {
      n--;
      int k = random.nextInt(n + 1);

      WordModel temp = firebase_words[k];
      firebase_words[k] = firebase_words[n];
      firebase_words[n] = temp;
    }

    int count = GameSetting.max_player_num * GameSetting.max_round;
    int i = 0;
    if (firebase_words.length > 0) {
      while (firebase_words.length < count) {
        firebase_words.add(firebase_words[i]);
        i++;
      }
    }
    print(firebase_words);
  }
}
