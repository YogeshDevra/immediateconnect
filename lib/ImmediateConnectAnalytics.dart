import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class ImmediateConnectAnalytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  static void setCurrentScreen(String screenName, String className) {
    analytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: className);
  }


  static const String HOME_SCREEN = 'Home Screen';
  static const String COINS_SCREEN = 'Coins Screen';
  static const String Portfolio_SCREEN = 'Portfolio Screen';
  static const String TOPCOINS_SCREEN = 'Top Coins Screen';
  static const String TRENDS_SCREEN = 'Trends Screen';
  static const String ImmediateConnect_Iframe_SCREEN = 'Immediate Connect Iframe Screen';

}