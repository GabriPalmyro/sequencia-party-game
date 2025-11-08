import 'package:flutter/foundation.dart';

/// Central place to keep the AdMob identifiers used across the app.
///
/// Replace the release ad unit identifiers once production inventory
/// is created. Test identifiers remain available for debug/profile
/// builds so we do not accidentally generate invalid traffic.
class AdsConfig {
  const AdsConfig._();

  static const String androidAppId = 'ca-app-pub-7831186229252322~3161208353';

  static const String iosAppId =
      'ca-app-pub-7831186229252322~3492666253';

  // TODO(gabrielpalmyro): drop the nulls below once production ad units exist.
  static const String? _androidBannerAdUnitId =
      'ca-app-pub-7831186229252322/3372961345';
  static const String? _androidInterstitialAdUnitId = null;
  static const String? _iosBannerAdUnitId =
      'ca-app-pub-7831186229252322/8972772388';
  static const String? _iosInterstitialAdUnitId = null;

  static const String _androidTestBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _iosTestInterstitial =
      'ca-app-pub-3940256099942544/4411468910';

  static bool get _isRelease => kReleaseMode;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static String? get bannerAdUnitId {
    if (_isAndroid) {
      return _resolveUnit(
        releaseValue: _androidBannerAdUnitId,
        fallback: _androidTestBanner,
      );
    }
    if (_isIOS) {
      return _resolveUnit(
        releaseValue: _iosBannerAdUnitId,
        fallback: _iosTestBanner,
      );
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (_isAndroid) {
      return _resolveUnit(
        releaseValue: _androidInterstitialAdUnitId,
        fallback: _androidTestInterstitial,
      );
    }
    if (_isIOS) {
      return _resolveUnit(
        releaseValue: _iosInterstitialAdUnitId,
        fallback: _iosTestInterstitial,
      );
    }
    return null;
  }

  static String? _resolveUnit({
    required String? releaseValue,
    required String fallback,
  }) {
    if (_isRelease && releaseValue != null && releaseValue.isNotEmpty) {
      return releaseValue;
    }
    return fallback;
  }
}
