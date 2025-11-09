import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

@singleton
class PurchaseService extends ChangeNotifier {
  bool isPremium = false;

  Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      // TODO: Replace with your Google Play API key
      configuration =
          PurchasesConfiguration('goog_REPLACE_WITH_YOUR_API_KEY');
    } else if (Platform.isIOS) {
      // TODO: Replace with your Apple App Store API key
      configuration =
          PurchasesConfiguration('appl_REPLACE_WITH_YOUR_API_KEY');
    }
    await Purchases.configure(configuration);

    await _updatePremiumStatus();

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updatePremiumStatus();
    });
  }

  Future<void> _updatePremiumStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();
    // TODO: Replace 'premium' with your actual entitlement identifier from RevenueCat
    final newStatus = customerInfo.entitlements.all['premium']?.isActive ?? false;

    if (newStatus != isPremium) {
      isPremium = newStatus;
      notifyListeners();
    }
  }

  Future<void> presentPaywall() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      if (currentOffering != null) {
        await RevenueCatUI.presentPaywall(offering: currentOffering);
      }
    } catch (e) {
      // Handle error
    }
  }
}
