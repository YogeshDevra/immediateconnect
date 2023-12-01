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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp();
  ImmAppLanguage appLanguage = ImmAppLanguage();
   appLanguage.fetchLocale();
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
                    // This is the theme of your application.
                    //
                    // TRY THIS: Try running your application with "flutter run". You'll see
                    // the application has a purple toolbar. Then, without quitting the app,
                    // try changing the seedColor in the colorScheme below to Colors.green
                    // and then invoke "hot reload" (save your changes or press the "hot
                    // reload" button in a Flutter-supported IDE, or press "r" if you used
                    // the command line to start the app).
                    //
                    // Notice that the counter didn't reset back to zero; the application
                    // state is not lost during the reload. To reset the state, use hot
                    // restart instead.
                    //
                    // This works for code too, not just values: Most code changes can be
                    // tested with just a hot reload.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

      ImmApiConfig.ImmApiUrl = remoteConfig.getString('apiUrl_immediateConnect').trim();

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
    //StateonBording();
    super.initState();
  }

  void StateonBording() async{
    Future.delayed(Duration(milliseconds: 1000)).then((_){
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
