// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immediateconnectapp/coinsImmediateScreen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ImmediateConnect.dart';
import 'localization/ImmAppLocalizations.dart';
import 'models/ImmediateBitcoin.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'models/ImmediatePortfolio.dart';
import 'DatabaseHelper.dart';
import 'TopCoinsImmediateScreen.dart';
import 'TrendsImmediateScreen.dart';
import 'localization/ImmAppLanguage.dart';
import 'models/LanguageModel.dart';

class PortfolioImmediateScreen extends StatefulWidget {
  const PortfolioImmediateScreen({Key? key}) : super(key: key);

  @override
  _PortfolioImmediateScreenState createState() => _PortfolioImmediateScreenState();
}

class _PortfolioImmediateScreenState extends State<PortfolioImmediateScreen> with SingleTickerProviderStateMixin {
  bool loading = false;
  List<ImmediateBitcoin> immediateBitcoins = [];
  List<ImmediateBitcoin> gainerLooserCoins = [];
  SharedPreferences? sharedPrefer;
  Future<SharedPreferences> sPrefs = SharedPreferences.getInstance();
  num size = 0;
  double totalPortfolioValues = 0.0;
  final coinEditKey = GlobalKey<FormState>();
  String? tomcatUrl;
  String _lable = "Coins";
  final PageStorageBucket bucket = PageStorageBucket();
  String? langCodeSaved;
  bool? isHideForm;
  String? formIFrame;
  late WebViewController controller;
  final _key0 = GlobalKey();
  BuildContext? myContext;

  TextEditingController? coinAddedTextController;
  TextEditingController? coinEditTextController;
  final dbHelp = DatabaseHelper.instance;
  List<ImmediatePortfolio> immediatePortfolios = [];

  List<LanguageModel> languages = [
    LanguageModel(langCode: "en", langName: "English"),
    LanguageModel(langCode: "it", langName: "Italian"),
    LanguageModel(langCode: "de", langName: "German"),
    LanguageModel(langCode: "sv", langName: "Swedish"),
    LanguageModel(langCode: "fr", langName: "French"),
    LanguageModel(langCode: "nb", langName: "Norwegian"),
    LanguageModel(langCode: "es", langName: "Spanish"),
    LanguageModel(langCode: "nl", langName: "Dutch"),
    LanguageModel(langCode: "fi", langName: "Finnish"),
    LanguageModel(langCode: "ru", langName: "Russian"),
    LanguageModel(langCode: "pt", langName: "Portuguese"),
    LanguageModel(langCode: "ar", langName: "Arabic"),
  ];

  @override
  void initState() {
    coinAddedTextController = TextEditingController();
    coinEditTextController = TextEditingController();
    dbHelp.queryAllRows().then((notes) {
      for (var note in notes) {
        immediatePortfolios.add(ImmediatePortfolio.fromMap(note));
        totalPortfolioValues = totalPortfolioValues + note["total_value"];
      }
      setState(() {});
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ShowCaseWidget.of(myContext!)!.startShowCase([_key0]);
    });
    super.initState();
    getSharedPrefData();
    fetchRemoteValue();

  }

  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await sPrefs;
    setState(() {
      _lable = prefs.getString("title") ?? ImmAppLocalizations.of(context).translate('portfolio');
      langCodeSaved = prefs.getString('language_code') ?? "en";
      _saveLangData();
    });
  }

  _saveLangData() async {
    sharedPrefer = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefer!.setInt("index", 0);
      sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('portfolio'));
      // sharedPreferences.commit();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      formIFrame = remoteConfig.getString('immediate_connect_form_url').trim();
      tomcatUrl = remoteConfig.getString('immediate_connect_tomcat_url').trim();
      isHideForm = remoteConfig.getBool('hide_immediate_connect');
      print(tomcatUrl);
      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(formIFrame!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(formIFrame!));
    callCoinApi();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<ImmAppLanguage>(context);
    return SingleChildScrollView(
      child: ShowCaseWidget(
          builder: Builder(
              builder: (context) {
                myContext = context;
                return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffd76614)
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              setState(() {_modalBottomMenu();});
                            }, // Image tapped
                            child: const Icon(Icons.menu_rounded,color: Colors.white,)
                        ),
                      ),
                      const Spacer(),
                      Text(ImmAppLocalizations.of(context).translate('portfolio'),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(child: Text(ImmAppLocalizations.of(context).translate('select_language'))),
                                  content: Container(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: languages.length,
                                          itemBuilder: (BuildContext context, int i) {
                                            return Column(
                                              children: <Widget>[
                                                InkWell(
                                                    onTap: () async {
                                                      appLanguage.changeLanguage(Locale(languages[i].langCode!));
                                                      await getSharedPrefData();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text(languages[i].langName!),
                                                        langCodeSaved == languages[i].langCode
                                                        ? const Icon(Icons.radio_button_checked, color: Colors.deepOrange,)
                                                        : const Icon(Icons.radio_button_unchecked, color: Colors.deepOrange,),
                                                      ],
                                                    )),
                                                const Divider()
                                              ],
                                            );
                                          })),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Navigator.pop(context);},
                                      child: Text(ImmAppLocalizations.of(context).translate('cancel')),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '\$${totalPortfolioValues.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(ImmAppLocalizations.of(context).translate('portfolio_value'),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if(isHideForm == true)
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 520,
                      child : WebViewWidget(controller: controller),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      width: MediaQuery.of(context).size.width/.7,
                      child: gainerLooserCoins.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: gainerLooserCoins.length,
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height:160,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffc1580b),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left:5.0),
                                                  child: FadeInImage(
                                                    width: 50,
                                                    height: 50,
                                                    placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                    image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${gainerLooserCoins[i].immBitName!.toLowerCase()}.png"),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(left:10.0),
                                                    child:Text('${gainerLooserCoins[i].immBitName}',
                                                      style: const TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color:Color(0xffa0bef8)),
                                                      textAlign: TextAlign.left,
                                                    )
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:65),
                                                  child: Text('\$ ${double.parse(gainerLooserCoins[i].immBitRate!.toStringAsFixed(2))}',
                                                    style: const TextStyle(fontSize: 20,color:Colors.white),textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                                crossAxisAlignment:CrossAxisAlignment.end,
                                                mainAxisAlignment:MainAxisAlignment.end,
                                                children:[
                                                  double.parse(gainerLooserCoins[i].immBitDiffRate!) < 0
                                                      ? const Icon(Icons.arrow_downward, color: Colors.red, size: 20,)
                                                      : const Icon(Icons.arrow_upward, color: Colors.green, size: 20,),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(double.parse(gainerLooserCoins[i].immBitDiffRate!) < 0
                                                      ? "${double.parse(gainerLooserCoins[i].immBitDiffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                                      : "${double.parse(gainerLooserCoins[i].immBitDiffRate!).toStringAsFixed(2)} %",
                                                      style: TextStyle(fontSize: 18,
                                                          color: double.parse(gainerLooserCoins[i].immBitDiffRate!) < 0
                                                              ? Colors.red
                                                              : Colors.green)
                                                  ),
                                                ]
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                child: Container(
                                                  width:MediaQuery.of(context).size.width/2,
                                                  height: 80,
                                                  child: charts.LineChart(
                                                    _createSampleData(gainerLooserCoins[i].immBitHistoryRate, double.parse(gainerLooserCoins[i].immBitDiffRate!)),
                                                    layoutConfig: charts.LayoutConfig(
                                                        leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                                        topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                                        rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                                        bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                                                    defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,roundEndCaps: true),
                                                    animate: true,
                                                    domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                                                    primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ImmAppLocalizations.of(context).translate('swipe_delete'),
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                  Expanded(
                    child: Container(
                    decoration: const BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25))
                    ),
                    child: immediatePortfolios.isNotEmpty && immediateBitcoins.isNotEmpty
                        ? Showcase(
                        key: _key0!,
                        // title: 'Tap to Add Coin',
                        description:
                        ImmAppLocalizations.of(context).translate('swipe_delete'),
                        textColor: Colors.black,
                        child: ListView.builder(
                        itemCount: immediatePortfolios.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Dismissible(
                            background : Container(
                              color: Colors.red,
                              child: InkWell(
                                  onTap: () {_showDeleteCoinFromPortfolioDialog(immediatePortfolios[i]);}, // Image tapped
                                  child: const Icon(Icons.delete,color: Colors.white,size:20)
                              ),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction){
                              setState(() {_showDeleteCoinFromPortfolioDialog(immediatePortfolios[i]);});
                            },
                            child: Card(
                              color: const Color(0xffd76614),
                              elevation: 1,
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffd76614)),
                                height: MediaQuery.of(context).size.height/11,
                                width: MediaQuery.of(context).size.width/.5,
                                child:GestureDetector(
                                    onTap: () {showPortfolioEditDialog(immediatePortfolios[i]);},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              height: 40,
                                              width:40,
                                              child: FadeInImage(
                                                placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${immediatePortfolios[i].name.toLowerCase()}.png"),
                                              ),
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(1),
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(immediatePortfolios[i].name,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white), textAlign: TextAlign.left,
                                                ),
                                                Text('\$${immediatePortfolios[i].rateDuringAdding.toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                              ],
                                            )
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Text(' ${immediatePortfolios[i].numberOfCoins.toStringAsFixed(0)}',
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                                  textAlign: TextAlign.end,),
                                              ),
                                              Text('\$${immediatePortfolios[i].totalValue.toStringAsFixed(2)}',
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                                textAlign: TextAlign.end,),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width:10),
                                        const SizedBox(
                                          width: 2,
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ),
                          );
                        }))
                        :Center(
                      child: ElevatedButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CoinsImmediateScreen()),
                          );
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffd76614),),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                )
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(ImmAppLocalizations.of(context).translate('add_coins')),
                        ),
                      ),
                    ),
                  ),
                  )
                ],
              ),
            )
        ),
      );})),
    );
  }

  List<charts.Series<LinearSales, int>> _createSampleData(
      historyRate, diffRate) {
    List<LinearSales> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(LinearSales(i, rate));
    }

    return [
      charts.Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        // areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.count,
        measureFn: (LinearSales sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  Future<void> callCoinApi() async {
    var uri = '$tomcatUrl/Bitcoin/resources/getBitcoinList?size=$size';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if (data['error'] == false) {
      setState(() {
        immediateBitcoins.addAll(data['data'].map<ImmediateBitcoin>((json) => ImmediateBitcoin.fromJson(json)).toList());
        loading = false;
        size = size + data['data'].length;
      });
      callGainerLooserCoinApi();
    }
    else {
      setState(() {});
    }
  }

  Future<void> showPortfolioEditDialog(ImmediatePortfolio bitcoin) async {
    coinEditTextController!.text = bitcoin.numberOfCoins.toInt().toString();
    showModalBottomSheet(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  color: Color(0xffc1580b),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40))
              ),
              child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(ImmAppLocalizations.of(context).translate('update_coins'),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                children:<Widget>[
                                  Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: FadeInImage(
                                            height: 40,
                                            placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                            image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${bitcoin.name.toLowerCase()}.png"),
                                          ),
                                        ),
                                      ]
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Text(bitcoin.name,
                                    style: const TextStyle(fontSize: 25, color: Colors.black),),
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:15),
                          child: Text(ImmAppLocalizations.of(context).translate('enter_coins'),textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15, color: Color(0xffdca076), fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            decoration: BoxDecoration(color: const Color(0xffc1580b),
                                border: Border.all(color: Colors.white, width: 2)
                            ),
                            child: Form(
                              key: coinEditKey,
                              child: TextFormField(
                                controller: coinEditTextController,
                                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ], // O
                                //only numbers can be entered
                                validator: (val) {
                                  if (coinEditTextController!.value.text == "" ||
                                      int.parse(coinEditTextController!.value.text) <= 0) {
                                    return ImmAppLocalizations.of(context).translate('invalid_coins');
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap:(){
                                _updateSaveCoinsToLocalStorage(bitcoin);
                              } ,// Image tapped
                              child: Container(
                                decoration: BoxDecoration(color: const Color(0xffc1580b),border: Border.all(color: Colors.white,width: 2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(ImmAppLocalizations.of(context).translate('update_coins'),textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),]
              ),
            ),
          ),
        )
    );
  }

  getCurrentRateDiff(ImmediatePortfolio items, List<ImmediateBitcoin> bitcoinList) {
    ImmediateBitcoin j = bitcoinList.firstWhere((element) => element.immBitName == items.name);
    double newRateDiff = j.immBitRate! - items.rateDuringAdding;
    return newRateDiff;
  }

  _modalBottomMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ), builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, setState) =>
              SingleChildScrollView(
                child:Container(
                  decoration: const BoxDecoration(image: DecorationImage(
                    image: AssetImage("immediateAsset/connectImage/connectMenubg.png",),
                    fit: BoxFit.fill,
                  ),),
                  height: MediaQuery.of(context).size.height/1.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget> [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ImmediateConnect()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image.asset("immediateAsset/connectImage/connectHome.png",height: 60,width: 60,)
                                  ),
                                  Text(ImmAppLocalizations.of(context).translate('home'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const TopCoinsImmediateScreen()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("immediateAsset/connectImage/connectTopCoins.png",height: 60,width: 60,)
                                  ),
                                  Text(ImmAppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const CoinsImmediateScreen()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("immediateAsset/connectImage/connectCoins.png",height: 60,width: 60,)
                                  ),
                                  Text(ImmAppLocalizations.of(context).translate('coins'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrendsImmediateScreen()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("immediateAsset/connectImage/connectTrends.png",height: 60,width: 60,)
                                  ),
                                  Text(ImmAppLocalizations.of(context).translate('trends'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const PortfolioImmediateScreen()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("immediateAsset/connectImage/connectPortfolio.png",height: 60,width: 60,)
                                  ),
                                  Text(ImmAppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
      );});
  }

  Future<void> callGainerLooserCoinApi() async {

    var uri = '$tomcatUrl/Bitcoin/resources/getBitcoinListLoser?size=0';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          gainerLooserCoins.addAll(data['data'].map<ImmediateBitcoin>((json) => ImmediateBitcoin.fromJson(json)).toList());
          loading = false;
        });
      }
      else {
        setState(() {});
      }
    }
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _saveProfileData(String name) async {
    sharedPrefer = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefer!.setString("currencyName", name);
      sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('trends'));
      sharedPrefer!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, 'driftPage', (r) => false);
  }

  _updateSaveCoinsToLocalStorage(ImmediatePortfolio bitcoin) async {
    if (coinEditKey.currentState!.validate()) {
      int adf = int.parse(coinEditTextController!.text);
      print(adf);
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: bitcoin.name,
        DatabaseHelper.columnRateDuringAdding: bitcoin.rateDuringAdding,
        DatabaseHelper.columnCoinsQuantity: double.parse(coinEditTextController!.value.text),
        DatabaseHelper.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await dbHelp.update(row);
      print('inserted row id: $id');
      sharedPrefer = await SharedPreferences.getInstance();
      setState(() {
        sharedPrefer!.setString("currencyName", bitcoin.name);
        sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('portfolio'));
        sharedPrefer!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
  }

  void _showDeleteCoinFromPortfolioDialog(ImmediatePortfolio item) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40))
      ),
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  color: Color(0xffc1580b),borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
              child: ListView(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(ImmAppLocalizations.of(context).translate('remove_coins'),
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(ImmAppLocalizations.of(context).translate('do_you'),
                              style: const TextStyle(color: Colors.white,fontSize: 18),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  children:<Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: FadeInImage(
                                                height: 70,
                                                placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${item.name.toLowerCase()}.png"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height:10,
                                            ),
                                          ]
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        Text(item.name,
                                          style: const TextStyle(fontSize: 25, color: Colors.black),),
                                        const SizedBox(
                                          height:10,
                                        ),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap:(){
                                  _deleteCoinsToLocalStorage(item);
                                } ,// Image tapped
                                child: Container(
                                  decoration: BoxDecoration(color: const Color(0xffc1580b),border: Border.all(color: Colors.white,width: 2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(ImmAppLocalizations.of(context).translate('remove'),textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }

  _deleteCoinsToLocalStorage(ImmediatePortfolio item) async {
    final id = await dbHelp.delete(item.name);
    print('inserted row id: $id');
    sharedPrefer = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('portfolio'));
      sharedPrefer!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
  }
}