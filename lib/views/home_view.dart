import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ads_purchase_bestcase/models/Account.dart';
import 'package:flutter_ads_purchase_bestcase/models/Question.dart';
import 'package:flutter_ads_purchase_bestcase/services/admob_service.dart';
import 'package:flutter_ads_purchase_bestcase/services/auth_service.dart';
import 'package:flutter_ads_purchase_bestcase/views/history_view.dart';
import 'package:flutter/material.dart';
import "package:flutter_ads_purchase_bestcase/extensions/string_extension.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:intl/intl.dart';

enum AppStatus { ready, waiting }

class HomeView extends StatefulWidget {
  final Account account;

  const HomeView({super.key, required this.account});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController _questionController = TextEditingController();
  String _answer = "";
  bool _askBtnActive = false;
  Question _question = Question();
  AppStatus? _appStatus;
  int _timeTillNextFree = 0;
  CountdownController _countDownController = CountdownController();

  //ad related
  late AdMobService _adMobService;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _timeTillNextFree = widget.account.nextFreeQuestion
            ?.difference((DateTime.now()))
            .inSeconds ??
        0;
    _giveFreeDecision(widget.account.bank, _timeTillNextFree);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adMobService = context.read<AdMobService>();
    _adMobService.initialization.then((value) {
      setState(() {
        _bannerAd = BannerAd(
          adUnitId: _adMobService.bannerAdUnitId!,
          size: AdSize.fullBanner,
          request: const AdRequest(),
          listener: _adMobService.bannerAdListener,
        )..load();
        _createIntersitialAd();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _setAppStatus();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Decider",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HistoryView()));
                },
                child: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Decisions Left: ${widget.account.bank}"),
                ),
                _nextFreeCountdown(),
                const Spacer(),
                _buildQuestionForm(),
                const Spacer(flex: 3),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Account Type: Free"),
                ),
                Text("${context.read<AuthService>().currentUser?.uid}"),
                if (_bannerAd != null)
                  // ignore: sized_box_for_whitespace
                  Container(
                    height: 60,
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//----------------------------------------------------------------------------------
//  Widget Functions, which return a widget that's rendered in the view.
//----------------------------------------------------------------------------------
  Widget _buildQuestionForm() {
    if (_appStatus == AppStatus.ready) {
      return Column(
        children: [
          Text("Should I", style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
            child: TextField(
              decoration: const InputDecoration(
                helperText: 'Enter A Question',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _questionController,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  _askBtnActive = value.isNotEmpty ? true : false;
                });
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: _askBtnActive == true ? _answerQuestion : null,
            child: const Text(
              "Ask",
              style: TextStyle(color: Colors.white),
            ),
          ),
          _questionAndAnswer()
        ],
      );
    } else {
      return _questionAndAnswer();
    }
  }

  String _getAnswer() {
    var answerOptions = ['yes', 'no', 'definitely', 'not right now'];
    return answerOptions[Random().nextInt(answerOptions.length)];
  }

  Widget _questionAndAnswer() {
    if (_answer != "") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text("Should I ${_question.query}?"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "Answer: ${_answer.capitalize()}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _nextFreeCountdown() {
    if (_appStatus == AppStatus.waiting) {
      _countDownController.start();
      var f = NumberFormat("00", "en_US");
      return Column(
        children: [
          const Text("You will get one free decision in"),
          Countdown(
            controller: _countDownController,
            seconds: _timeTillNextFree,
            build: (BuildContext context, double time) => Text(
                "${f.format(time ~/ 3600)}:${f.format((time % 3600) ~/ 60)}:${f.format(time.toInt() % 60)}"),
            interval: const Duration(seconds: 1),
            onFinished: () {
              _giveFreeDecision(widget.account.bank, 0);
              setState(() {
                _timeTillNextFree = 0;
                _appStatus = AppStatus.ready;
              });
            },
          )
        ],
      );
    } else {
      return Container();
    }
  }

//----------------------------------------------------------------------------------
//  Void Functions, perform logical actions, change state, etc.
//----------------------------------------------------------------------------------
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

  void _giveFreeDecision(currentBank, timeTillNextFree) {
    if (currentBank <= 0 && timeTillNextFree <= 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.account.uid)
          .update({'bank': 1});
    }
  }

  void _answerQuestion() async {
    _showInterstitialAd();
    setState(() {
      _answer = _getAnswer();
    });

    _question.query = _questionController.text;
    _question.answer = _answer;
    _question.timeCreated = DateTime.now();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.account.uid)
        .collection('questions')
        .add(_question.toJson());

    //Update the document
    widget.account.bank -= 1;
    widget.account.nextFreeQuestion =
        DateTime.now().add(const Duration(seconds: 20));
    setState(() {
      _timeTillNextFree = widget.account.nextFreeQuestion
              ?.difference((DateTime.now()))
              .inSeconds ??
          0;
      if (widget.account.bank == 0) {
        _appStatus = AppStatus.waiting;
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.account.uid)
        .update(widget.account.toJson());

    _questionController.text = "";
  }

  _createIntersitialAd() {
    InterstitialAd.load(
        adUnitId: _adMobService.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            _interstitialAd = null;
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createIntersitialAd();
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createIntersitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createIntersitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
