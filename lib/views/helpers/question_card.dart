import 'package:flutter/material.dart';
import 'package:flutter_ads_purchase_bestcase/extensions/string_extension.dart';
import 'package:flutter_ads_purchase_bestcase/models/Question.dart';
import 'package:intl/intl.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Should I ${question.query!}",
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question.answer!.capitalize(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      // Format the DateTime using DateFormat
                      DateFormat('dd/MM/yyyy')
                          .format(question.timeCreated!.toLocal()),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
