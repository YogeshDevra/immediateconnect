import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:newproject/Iframe.dart';
import 'package:newproject/api_config.dart';
import 'package:newproject/onboarding.dart';
import 'package:newproject/portfolio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bottom_navigation.dart';
import 'chart.dart';
import 'coins.dart';
import 'homepage.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final AppLanguage? appLanguage;

  const MyApp({super.key, this.appLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => widget.appLanguage!,
        child: Consumer<AppLanguage>(
            builder: (context, model, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Immediate Connect',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple),
                    useMaterial3: true,
                    visualDensity: VisualDensity.adaptivePlatformDensity,

                  ),
                  locale: model.appLocal,
                  localizationsDelegates:[
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

                    '/onboarding': (BuildContext context) => OnboardingScreen(),
                    '/HomePage': (BuildContext context) => const HomePage(),
                    '/NavigationPage': (BuildContext context) => NavigationPage(),
                    '/Iframe': (BuildContext context) => IframeHomePage(),

                  },
                  home: MyHomePage()
              );
            }
        ));
  }
}

  // This widget is the root of your application.

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      api_config.ApiUrl = remoteConfig.getString('apiUrl_immediateConnect').trim();
      api_config.PreventIframe=remoteConfig.getString('preventIframe_immediateConnect').trim();
      api_config.FrameLink = remoteConfig.getString('frameLink_immediateConnect').trim();
      api_config.hideIframe=remoteConfig.getBool('hideIframe_immediateConnect');

      print(api_config.hideIframe);
      setState(() {});
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    api_config.hideIframe == true
    ? IframePage()
    : StateonBording();
  }

  @override
  void initState(){
    fetchRemoteValue();
    //StateonBording();
    super.initState();
  }
  void StateonBording() async{
    Future.delayed(Duration(milliseconds: 1000)).then((_){
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  void IframePage() async{
    Future.delayed(Duration(milliseconds: 1000)).then((_){
      Navigator.of(context).pushReplacementNamed('/Iframe');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/OnBarding (1).png"),
              fit: BoxFit.fill),
        ),
      ),

    );
  }

}
