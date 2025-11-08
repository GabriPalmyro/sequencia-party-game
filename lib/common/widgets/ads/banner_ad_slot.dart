import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/core/ads/ads_config.dart';
import 'package:sequencia/core/ads/ads_service.dart';

class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({
    required this.placement,
    this.placeholderHeight,
    this.size = AdSize.banner,
    super.key,
  });

  final AdBannerPlacement placement;
  final double? placeholderHeight;
  final AdSize size;

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _bannerAd;
  bool _isLoading = false;

  double get _defaultHeight =>
      widget.placeholderHeight ?? widget.size.height.toDouble();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeLoadAd();
  }

  @override
  void didUpdateWidget(covariant BannerAdSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placement != widget.placement) {
      _scheduleAdClear();
      _maybeLoadAd(force: true);
    }
  }

  void _maybeLoadAd({bool force = false}) {
    final adsService = context.read<AdsService>();
    if (!adsService.canShowBanner(widget.placement)) {
      _scheduleAdClear();
      return;
    }

    if (!force && (_bannerAd != null || _isLoading || kIsWeb)) {
      return;
    }

    final adUnitId = AdsConfig.bannerAdUnitId;
    if (adUnitId == null) {
      return;
    }

    _isLoading = true;
    final banner = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );

    banner.load();
  }

  void _scheduleAdClear() {
    if (_bannerAd == null && !_isLoading) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _disposeBanner();
        return;
      }
      setState(_disposeBanner);
    });
  }

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final adsService = context.watch<AdsService>();
    final canShowAds = adsService.canShowBanner(widget.placement);

    if (!canShowAds) {
      _scheduleAdClear();
      return SizedBox(height: _defaultHeight);
    }

    if (_bannerAd == null && !_isLoading) {
      _maybeLoadAd();
    }

    final bannerAd = _bannerAd;
    if (bannerAd == null) {
      return SizedBox(height: _defaultHeight);
    }

    return SizedBox(
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  @override
  void dispose() {
    _disposeBanner();
    super.dispose();
  }
}
