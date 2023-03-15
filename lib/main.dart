// ignore_for_file: depend_on_referenced_packages



import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'localization/ImmAppLanguage.dart';
import 'localization/ImmAppLocalizations.dart';
import 'PortfolioImmediateScreen.dart';
import 'TrendsImmediateScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ImmAppLanguage immAppLanguage = ImmAppLanguage();
  await immAppLanguage.fetchLocale();
  runApp(MyApp(
    immAppLanguage: immAppLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final ImmAppLanguage? immAppLanguage;
  MyApp({this.immAppLanguage});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<ImmAppLanguage>(
      create: (_) => immAppLanguage!,
      child: Consumer<ImmAppLanguage>(
        builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: const [
              // FirebaseAnalyticsObserver(analytics: analytics)
            ],
            title: 'Immediate Connect App',
            theme: ThemeData(
              textTheme: GoogleFonts.openSansTextTheme(),
            ),
            locale: model.appLocal,
            localizationsDelegates: const [
              ImmAppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'UK'),
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
              '/myHomePage': (BuildContext context) => MyHomePage(),
              '/homePage': (BuildContext context) => const PortfolioImmediateScreen(),
              '/trendsPage': (BuildContext context) => const TrendsImmediateScreen(),
            },
            home: ShowCaseWidget(
              builder: Builder(builder: (context) => MyHomePage()),
            ),
          //   Provider<FirebaseAnalytics>(
          //       create: (context) => analytics, child: MyHomePage()),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'immediateAsset/connectImage/connectSplash.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
            ),
            Image.asset(
              'immediateAsset/connectImage/logo_ver.png',
              width: MediaQuery.of(context).size.width * .3,
            )
          ],
        )
    );
  }

  @override
  void initState() {
    homePage();
    super.initState();
  }

  Future<void> homePage() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      Navigator.of(context).pushReplacementNamed('/homePage');
    });
  }
}
