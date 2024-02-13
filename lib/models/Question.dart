class Question {
  String? query;
  String? answer;
  DateTime? timeCreated;

  Question();

  Map<String, dynamic> toJson() =>
      {'query': query, 'answer': answer, 'timeCreated': timeCreated};

  Question.fromSnapshot(snapshot)
      : query = snapshot.data()['query'],
        answer = snapshot.data()['answer'],
        timeCreated = snapshot.data()['timeCreated'].toDate();
}
