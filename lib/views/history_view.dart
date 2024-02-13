import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads_purchase_bestcase/models/Question.dart';
import 'package:flutter_ads_purchase_bestcase/services/auth_service.dart';
import 'package:flutter_ads_purchase_bestcase/views/helpers/question_card.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserQuestionsList();
  }

  List<Object> _historyList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Past Decisions', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: _historyList.length,
        itemBuilder: (context, index) {
          return QuestionCard(question: _historyList[index] as Question);
        },
      )),
    );
  }

  Future getUserQuestionsList() async {
    final uid = AuthService().currentUser?.uid;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('questions')
        .orderBy('timeCreated', descending: true)
        .get();

    setState(() {
      _historyList = List.from(data.docs.map(
        (e) => Question.fromSnapshot(e),
      ));
    });
  }
}
