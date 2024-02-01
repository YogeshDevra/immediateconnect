import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:immediate_connect/localization/AppLanguage.dart';
import 'package:provider/provider.dart';

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
  MyApp({super.key,this.appLanguage});
  // MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage!,
      child: Consumer<AppLanguage>(
        builder: (context, model, child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Immediate Connect',
        routes: <String, WidgetBuilder>{
          '/myHome': (BuildContext context) => MyHomePage(),
          '/OnBording': (BuildContext context) => OnBordingFor(),

        },
        home: MyHomePage(),
      );

        }));



  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, });





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
          Container(
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
  StateOnbording();
  super.initState();
}
  Future<void> StateOnbording() async {
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      Navigator.of(context).pushReplacementNamed('/OnBording');
    });
  }
}
