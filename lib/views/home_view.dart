import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads_purchase_bestcase/extensions/string_extension.dart';
import 'package:flutter_ads_purchase_bestcase/models/Question.dart';
import 'package:flutter_ads_purchase_bestcase/services/auth_service.dart';
import 'package:flutter_ads_purchase_bestcase/views/history_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _answer = "";
  TextEditingController _questionController = TextEditingController();
  bool _askBtnActive = false;
  Question _question = Question();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Decider",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HistoryView()));
                },
                child: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Desicions Left: ##"),
              ),
              const Spacer(),
              _buildQuestForm(),
              const Spacer(
                flex: 3,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Account type: Free"),
              ),
              Text("${AuthService().currentUser?.uid}")
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildQuestForm() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            "Should I",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextField(
            maxLines: null,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            controller: _questionController,
            onChanged: (value) {
              setState(() {
                _askBtnActive = value.isNotEmpty ? true : false;
                _questionController.text = value;
              });
            },
            decoration: InputDecoration(
              helperText: "Enter A Question",
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _askBtnActive ? answerQuestion : null,
              child: const Text(
                "Ask",
                style: TextStyle(color: Colors.white),
              )),
          _questionAndAnswer(),
        ],
      ),
    );
  }

  String _getAnswer() {
    var answerOptions = [
      "yes",
      "no",
      "definitely",
      "not right now",
    ];

    return answerOptions[Random().nextInt(answerOptions.length)];
  }

  Widget _questionAndAnswer() {
    if (_answer == "") {
      return Container();
    } else {
      return Column(
        children: [
          Text("Should I ${_questionController.text} ?"),
          Text(
            "Answer: ${_answer.capitalize()}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
    }
  }

  Future<void> answerQuestion() async {
    setState(() {
      _answer = _getAnswer();
    });

    // save to db
    _question.query = _questionController.text;
    _question.answer = _answer;
    _question.timeCreated = DateTime.now();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().currentUser?.uid)
        .collection("questions")
        .add(_question.toJson());
    _questionController.text = "";
  }
}