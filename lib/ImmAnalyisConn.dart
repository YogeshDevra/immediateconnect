// ignore_for_file: constant_identifier_names, file_names

import 'package:firebase_analytics/firebase_analytics.dart';

class ImmAnalyisConn {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static void setCurrentScreen(String imSnNmCon, String imClNmCon) {
    analytics.setCurrentScreen(
        screenName: imSnNmCon,screenClassOverride: imClNmCon);
  }

  static const String ImmFrm_Conn = 'Imm Frame Screen Conn';
  static const String ImmTrd_Conn = 'Imm Trend Screen Conn';
  static const String ImmHom_Conn = 'Imm Home Screen Conn';
}