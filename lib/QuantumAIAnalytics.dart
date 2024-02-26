// ignore_for_file: file_names, constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';

class QuantumAIAnalytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  static void setCurrentScreen(String screenName, String className) {
    analytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: className);
  }

  static const String HOME_SCREEN = 'Home Screen';
  static const String CRYPTO_SCREEN = 'Coins Screen';
  static const String ADDED_COINS_SCREEN = 'Added Coin Screen';
  static const String SWAP_SCREEN = 'Swap Screen';
  static const String TRENDS_SCREEN = 'Trends Screen';
  static const String COIN_PERFORMANCE_SCREEN = 'Coin Performance Screen';
  static const String QuantumAI_Iframe_SCREEN = 'QuantumAI Iframe Screen';

}