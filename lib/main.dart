import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads_purchase_bestcase/firebase_options.dart';
import 'package:flutter_ads_purchase_bestcase/models/Account.dart';
import 'package:flutter_ads_purchase_bestcase/services/auth_service.dart';
import 'package:flutter_ads_purchase_bestcase/views/home_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService().getOrCreateUser();
  runApp(MultiProvider(providers: [
    Provider.value(value: AuthService()),
  ], child: const DeciderApp()));
}

class DeciderApp extends StatelessWidget {
  const DeciderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Decider',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(context.read<AuthService>().currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Account account = Account.fromSnapshot(
                  snapshot.data,
                  context.read<AuthService>().currentUser?.uid,
                );
                return HomeView(account: account);
              }
              return const CircularProgressIndicator();
            }));
  }
}
