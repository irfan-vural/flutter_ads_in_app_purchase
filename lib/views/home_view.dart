import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads_purchase_bestcase/extensions/string_extension.dart';
import 'package:flutter_ads_purchase_bestcase/models/Account.dart';
import 'package:flutter_ads_purchase_bestcase/models/Question.dart';
import 'package:flutter_ads_purchase_bestcase/services/auth_service.dart';
import 'package:flutter_ads_purchase_bestcase/views/history_view.dart';
import 'package:provider/provider.dart';

enum AppStatus { ready, waiting }

class HomeView extends StatefulWidget {
  final Account account;
  const HomeView({super.key, required this.account});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _answer = "";
  TextEditingController _questionController = TextEditingController();
  bool _askBtnActive = false;
  Question _question = Question();
  AppStatus? _appStatus;
  @override
  Widget build(BuildContext context) {
    _setAppStatus();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Desicions Left: ${widget.account.bank}"),
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
              Text("${context.read<AuthService>().currentUser?.uid}")
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildQuestForm() {
    if (_appStatus == AppStatus.ready) {
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
              decoration: const InputDecoration(
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
    } else {
      return _questionAndAnswer();
    }
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

  void _setAppStatus() {
    if (widget.account.bank > 0) {
      setState(() {
        _appStatus = AppStatus.ready;
      });
    } else {
      setState(() {
        _appStatus = AppStatus.waiting;
      });
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

    widget.account.bank -= 1;
    widget.account.nextFreeQuestion =
        DateTime.now().add(const Duration(seconds: 5));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.account.uid)
        .collection("questions")
        .add(_question.toJson());
    _questionController.text = "";
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.account.uid)
        .update(widget.account.toJson());
  }
}
