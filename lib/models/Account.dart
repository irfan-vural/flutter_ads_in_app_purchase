class Account {
  String? uid;
  int bank = 0;

  Account();

  Map<String, dynamic> toJson() => {
        'bank': bank,
      };

  Account.fromSnapshot(snapshot, this.uid) : bank = snapshot.data()['bank'];
}
