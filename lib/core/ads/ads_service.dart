import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/core/ads/ads_config.dart';
import 'package:sequencia/features/purchases/purchase_service.dart';

enum AdBannerPlacement {
  home,
  countdown,
  playerSorting,
}

@lazySingleton
class AdsService extends ChangeNotifier {
  AdsService(this._purchaseService);

  final PurchaseService _purchaseService;

  bool _isInitialized = false;
  bool _isInterstitialLoading = false;

  InterstitialAd? _interstitialAd;

  bool get canShowAds => !_purchaseService.isPremium;

  bool canShowBanner(AdBannerPlacement _) => !_purchaseService.isPremium;

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) {
      return;
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;
    unawaited(loadInterstitialAd());

    _purchaseService.addListener(_onPremiumStatusChanged);
  }

  void _onPremiumStatusChanged() {
    if (_purchaseService.isPremium) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
    } else {
      unawaited(loadInterstitialAd());
    }
    notifyListeners();
  }

  Future<void> loadInterstitialAd() async {
    if (_purchaseService.isPremium ||
        _isInterstitialLoading ||
        _interstitialAd != null ||
        kIsWeb) {
      return;
    }
    final adUnitId = AdsConfig.interstitialAdUnitId;
    if (adUnitId == null) {
      return;
    }

    _isInterstitialLoading = true;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          ad.setImmersiveMode(true);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              unawaited(loadInterstitialAd());
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialLoading = false;
              unawaited(loadInterstitialAd());
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  Future<void> showInterstitialIfAvailable() async {
    if (_purchaseService.isPremium || kIsWeb) {
      return;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      return;
    }

    await ad.show();
    _interstitialAd = null;
    unawaited(loadInterstitialAd());
  }

  @override
  @disposeMethod
  void dispose() {
    _purchaseService.removeListener(_onPremiumStatusChanged);
    _interstitialAd?.dispose();
    super.dispose();
  }
}
