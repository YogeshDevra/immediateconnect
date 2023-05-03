// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localization.dart';
import 'portfoliopage.dart';
import 'trendsPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage? appLanguage;
  const MyApp({super.key, this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage!,
      child: Consumer<AppLanguage>(
        builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Immediate Connect',
            theme: ThemeData(
              textTheme: GoogleFonts.openSansTextTheme(),
            ),
            locale: model.appLocal,
            localizationsDelegates: const [
              AppLocalizations.delegate,
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
              '/myHomePage': (BuildContext context) => const MyHomePage(),
              '/homePage': (BuildContext context) => const PortfolioPage(),
              '/driftPage': (BuildContext context) => const TrendsPage(),
            },
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
              'assets/image/Splash.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
            ),
            Image.asset(
              'assets/image/logo_ver.png',
              width: MediaQuery.of(context).size.width * .3,
            )
          ],
        ));
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
