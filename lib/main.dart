
// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:quantumaiapp/localization/AppLanguage.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:provider/provider.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'onbordingFor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp( MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage? appLanguage;
  const MyApp({super.key,this.appLanguage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage!,
        child: Consumer<AppLanguage>(
            builder: (context, model, child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Quantum AI App',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,

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
                  '/myHome': (BuildContext context) => const MyHomePage(),
                  '/OnBording': (BuildContext context) => OnBordingFor(),
                },
                home: const MyHomePage(),
              );
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Image.asset('assets/SplashScreen.png',fit: BoxFit.fill,height:  MediaQuery.of(context).size.height,),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    stateOnBoarding();
    super.initState();
  }
  Future<void> stateOnBoarding() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      Navigator.of(context).pushReplacementNamed('/OnBording');
    });
  }
}
