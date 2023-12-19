import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ImmApiConfig.dart';
import 'ImmHomePage.dart';
import 'ImmLocalization/ImmAppLanguage.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';
import 'ImmNavigationPage.dart';
import 'ImmOnboardPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ImmAppLanguage appLanguage = ImmAppLanguage();
  await appLanguage.fetchLocale();
  runApp( MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  final ImmAppLanguage? appLanguage;

  const MyApp({super.key, this.appLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

  // This widget is the root of your application.
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImmAppLanguage>(
        create: (_) => widget.appLanguage!,
        child: Consumer<ImmAppLanguage>(
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
                  localizationsDelegates: [
                    ImmAppLocalizations.delegate,
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
                    '/onboarding': (BuildContext context) => ImmOnboardPage(),
                    '/HomePage': (BuildContext context) => ImmHomePage(),
                    '/NavigationPage': (BuildContext context) => ImmNavigationPage(),
                  },
                  home: MyHomePage()
              );
            }));
  }
}

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
      ImmApiConfig.ImmApiUrl = remoteConfig.getString('ApiUrl_ImmediateConnect_Android').trim();
      ImmApiConfig.ImmPreventIframe=remoteConfig.getString('PreventIframe_ImmediateConnect_Android').trim();
      ImmApiConfig.ImmFrameLink = remoteConfig.getString('Iframe_ImmediateConnect_Android').trim();
      print(ImmApiConfig.ImmApiUrl);
      setState(() {});
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
     StateonBording();
  }
  @override
  void initState(){
    fetchRemoteValue();
    super.initState();
  }

  void StateonBording() async{
    Future.delayed(Duration(milliseconds: 1000)).then((_){
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/imOnBarding_(1).png"),
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}
