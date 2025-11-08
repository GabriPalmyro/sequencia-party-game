import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/core/ads/ads_config.dart';

@lazySingleton
class AdsService {
  AdsService();

  final ValueNotifier<BannerAd?> homeBannerAdNotifier =
      ValueNotifier<BannerAd?>(null);

  bool _isInitialized = false;
  bool _isBannerLoading = false;
  bool _isInterstitialLoading = false;

  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) {
      return;
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;
    unawaited(loadHomeBannerAd());
    unawaited(loadInterstitialAd());
  }

  Future<void> loadHomeBannerAd() async {
    if (_isBannerLoading || kIsWeb) {
      return;
    }
    final adUnitId = AdsConfig.bannerAdUnitId;
    if (adUnitId == null) {
      return;
    }

    _isBannerLoading = true;

    final banner = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerLoading = false;
          if (ad is BannerAd) {
            homeBannerAdNotifier.value?.dispose();
            homeBannerAdNotifier.value = ad;
          }
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerLoading = false;
          ad.dispose();
        },
      ),
    );

    await banner.load();
  }

  Future<void> loadInterstitialAd() async {
    if (_isInterstitialLoading || _interstitialAd != null || kIsWeb) {
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
    if (kIsWeb) {
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

  @disposeMethod
  void dispose() {
    homeBannerAdNotifier.value?.dispose();
    homeBannerAdNotifier.dispose();
    _interstitialAd?.dispose();
  }
}
