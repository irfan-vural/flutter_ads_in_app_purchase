import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  Future<InitializationStatus> initialization;
  AdMobService(this.initialization);

  String? get bannerAdUnitId {
    if (kReleaseMode) {
      if (Platform.isIOS) {
        // TODO: Replace with actual iOS ad unit id
      } else if (Platform.isAndroid) {
        return "ca-app-pub-1285616310161075/5747902072";
      }
    } else {
      if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      } else if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      }
    }
    return null;
  }

  String? get interstitialAdUnitId {
    if (kReleaseMode) {
      if (Platform.isIOS) {
        // TODO: Replace with actual iOS ad unit id
      } else if (Platform.isAndroid) {
        return "ca-app-pub-1285616310161075/1808657067";
      }
    } else {
      if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/4411468910";
      } else if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
    }
    return null;
  }

  String? get rewardAdUnitId {
    if (kReleaseMode) {
      if (Platform.isIOS) {
        // TODO: Replace with actual iOS ad unit id
      } else if (Platform.isAndroid) {
        return "ca-app-pub-1285616310161075/8182493725";
      }
    } else {
      if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/1712485313";
      } else if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      }
    }
    return null;
  }

  final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) => ad.dispose(),
    onAdOpened: (ad) => debugPrint('Ad opened: ${ad.adUnitId}'),
    onAdClosed: (ad) => debugPrint('Ad closed: ${ad.adUnitId}'),
  );
}
