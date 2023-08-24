// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, sized_box_for_whitespace, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types, await_only_futures, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ImmLocalCon/ImmAppLangCon.dart';
import 'ImmLocalCon/ImmAppLocalCon.dart';
import 'ImmWidCon/ImmCoinSheetUpCon.dart';
import 'ImmWidCon/ImmDashPageCon.dart';
import 'ImmWidCon/ImmDeleteSheetCon.dart';
import 'ImmWidCon/ImmDriftScnCon.dart';
import 'ImmWidCon/ImmMenuSheetCon.dart';
import 'ImmWidCon/ImmNavSheetCon.dart';
import 'ImmWidCon/ImmPortSheetCon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "package:flutter_localizations/flutter_localizations.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ImmAppLangCon appLanguage = ImmAppLangCon();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ImmConApp(
    appLanguage: appLanguage,
  ));
}

class ImmConApp extends StatefulWidget{

  final ImmAppLangCon? appLanguage;
  const ImmConApp({this.appLanguage});
  @override
  State<ImmConApp> createState() => _ImmConApp();
}

class _ImmConApp extends State<ImmConApp> {

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImmAppLangCon>(
      create: (_) => widget.appLanguage!,
      child: Consumer<ImmAppLangCon>(
        builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Immediate Connect',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: model.appLocal,
            localizationsDelegates: const [
              ImmAppLocalCon.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', ''),
              Locale('de', ''),
              Locale('es', ''),
              Locale('fi', ''),
              Locale('fr', ''),
              Locale('it', ''),
              Locale('nl', ''),
              Locale('nb', ''),
              Locale('pt', ''),
              Locale('ru', ''),
              Locale('sv', '')
            ],
            routes: <String, WidgetBuilder>{
              '/myHome': (BuildContext context) => const MyHome(),
              '/HomePage': (BuildContext context) => const ImmDashPgConn(),
              '/NavigationPage': (BuildContext context) => ImmNavSheetCon(),
              '/trendPage': (BuildContext context) => const ImmDriftScnCon(),
              '/coinPage': (BuildContext context) => const ImmCoinSheetUpConn(),
              '/PortfolioPage': (BuildContext context) => const ImmPortSheetConn(),
              '/DeleteListScreen': (BuildContext context) => const ImmDeleteSheetCon(),
              '/MenuPage': (BuildContext context) => const ImmMenuSheetCoin(),
            },
            home: Provider<FirebaseAnalytics>(
              create: (context) => analytics,child: const MyHome()),
          );
        },
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {


  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/Splash@bg.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Image.asset(
              'assets/images/logo_ver.png',
              width: MediaQuery.of(context).size.width * .3,
            )
          ],
        ));
  }

  @override
  void initState() {
    StateOnbording();
    super.initState();
  }

  Future<void> StateOnbording() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((_)  {
      Navigator.of(context).pushReplacementNamed('/NavigationPage');
    });
  }
}
