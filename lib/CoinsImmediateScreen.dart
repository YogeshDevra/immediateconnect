// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api, camel_case_types

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'DatabaseHelper.dart';
import 'ImmediateConnect.dart';
import 'localization/ImmAppLocalizations.dart';
import 'models/ImmediateBitcoin.dart';
import 'models/ImmediatePortfolio.dart';
import 'PortfolioImmediateScreen.dart';
import 'TopCoinsImmediateScreen.dart';
import 'TrendsImmediateScreen.dart';

class CoinsImmediateScreen extends StatefulWidget {
  const CoinsImmediateScreen({Key? key}) : super(key: key);

  @override
  _CoinsImmediateScreenState createState() => _CoinsImmediateScreenState();
}

class _CoinsImmediateScreenState extends State<CoinsImmediateScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  bool loading = false;
  List<ImmediateBitcoin> immediateBitcoins = [];
  List<ImmediateBitcoin> searchImmediateBitcoins = [];
  SharedPreferences? sharedPrefer;
  num size = 0;
  double totalPortfolioValue = 0.0;
  final coinAddKey = GlobalKey<FormState>();
  String? tomcatUrl;
  TextEditingController? coinAddedTextController;
  TextEditingController? coinEditTextController;
  final dbHelp = DatabaseHelper.instance;
  List<ImmediatePortfolio> immediatePortfolios = [];
  final _key1 = GlobalKey();
  BuildContext? myContext;

  @override
  void initState() {
    fetchTomcatUrlValue();
    coinAddedTextController = TextEditingController();
    coinEditTextController = TextEditingController();

    dbHelp.queryAllRows().then((notes) {
      for (var note in notes) {
        immediatePortfolios.add(ImmediatePortfolio.fromMap(note));
        totalPortfolioValue = totalPortfolioValue + note["total_value"];
      }
      setState(() {});
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ShowCaseWidget.of(myContext!)!.startShowCase([_key1]);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchTomcatUrlValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      tomcatUrl = remoteConfig.getString('immediate_connect_tomcat_url').trim();
      print(tomcatUrl);
      setState(() {});
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    callCoinApi();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder: Builder(
            builder: (context) {
              myContext = context;
              return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 50),
        child: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xffd76614),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    setState(() {_modalBottomMenu();});
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Color(0xFFFFFFFF),)
              ),
            ),
            title: Text(ImmAppLocalizations.of(context).translate('coins'),
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                )
            )
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xffd76614)),
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search,color: Color(0xffd76614)),
                    title: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: ImmAppLocalizations.of(context)!.translate('search')!, border: InputBorder.none,
                      ),
                      onChanged: onSearchTextChanged,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(ImmAppLocalizations.of(context).translate('swipe'),
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.white,fontSize: 15),),
            ),
            Expanded(
              child:Container(
                decoration: const BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40),)),
                padding: const EdgeInsets.only(left: 10, right: 10,  top: 20),
                child: LazyLoadScrollView(
                  isLoading: loading,
                  onEndOfPage: () => callCoinApi(),
                  child: immediateBitcoins.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : searchImmediateBitcoins.isNotEmpty || _searchController.text.isNotEmpty
                      ?Showcase(
                      key: _key1!,
                      // title: 'Tap to Add Coin',
                      description:
                      'Slide left to Add Coins',
                      textColor: Colors.black,
                      child: ListView.builder(
                      itemCount: searchImmediateBitcoins.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
                          background : Container(
                            color: Colors.green,
                            child: InkWell(
                                onTap: () {showPortfolioDialog(searchImmediateBitcoins[i]);}, // Image tapped
                                child: const Icon(Icons.add,color: Colors.white,size:20)
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction){
                            setState(() {
                              showPortfolioDialog(searchImmediateBitcoins[i]);
                            });
                          },
                          child: Card(
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left:0, right:0),
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {callCurrencyDetails(searchImmediateBitcoins[i].immBitName);},
                                      child: Row(
                                        children: <Widget>[
                                          Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: 70,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: FadeInImage(
                                                        placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                        image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${searchImmediateBitcoins[i].immBitName!.toLowerCase()}.png"),
                                                      ),
                                                    )
                                                ),
                                              ]
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left:10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('${searchImmediateBitcoins[i].immBitName}',
                                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black), textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {callCurrencyDetails(searchImmediateBitcoins[i].immBitName);},
                                      child: SizedBox(
                                        width:MediaQuery.of(context).size.width/4,
                                        height: 40,
                                        child: charts.LineChart(
                                          _createSampleData(searchImmediateBitcoins[i].immBitHistoryRate, double.parse(immediateBitcoins[i].immBitDiffRate!)),
                                          layoutConfig: charts.LayoutConfig(
                                              leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                              topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                              rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                              bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                                          defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,),
                                          animate: true,
                                          domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                                          primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {callCurrencyDetails(searchImmediateBitcoins[i].immBitName);},
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('\$${double.parse(searchImmediateBitcoins[i].immBitRate!.toStringAsFixed(2))}',
                                                style: const TextStyle(fontSize: 18,color: Colors.black)),
                                            const SizedBox(height: 5,),
                                            Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(double.parse(searchImmediateBitcoins[i].immBitDiffRate!) < 0 ? '-' : '+',
                                                      style: TextStyle(fontSize: 12, color: double.parse(searchImmediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green)),
                                                  Icon(Icons.attach_money, size: 12, color: double.parse(searchImmediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green),
                                                  Text(double.parse(searchImmediateBitcoins[i].immBitDiffRate!) < 0
                                                      ? double.parse(searchImmediateBitcoins[i].immBitDiffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                      : double.parse(searchImmediateBitcoins[i].immBitDiffRate!).toStringAsFixed(2),
                                                      style: TextStyle(fontSize: 12, color: double.parse(searchImmediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      ))
                      :Showcase(
                      key: _key1!,
                      // title: 'Tap to Add Coin',
                      description:
              'Slide left to Add Coins',
              textColor: Colors.black,
              child: ListView.builder(
                      itemCount: immediateBitcoins.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
                          background : Container(
                            color: Colors.green,
                            child: InkWell(
                                onTap: () {
                                  showPortfolioDialog(immediateBitcoins[i]);
                                }, // Image tapped
                                child: const Icon(Icons.add,color: Colors.white,size:20)
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction){
                            setState(() {
                              showPortfolioDialog(immediateBitcoins[i]);
                            });
                          },
                          child: Card(
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left:0, right:0),
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        callCurrencyDetails(immediateBitcoins[i].immBitName);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                    height: 70,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: FadeInImage(
                                                        placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                        image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${immediateBitcoins[i].immBitName!.toLowerCase()}.png"),
                                                      ),
                                                    )
                                                ),
                                              ]
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left:10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('${immediateBitcoins[i].immBitName}',
                                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black), textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        callCurrencyDetails(immediateBitcoins[i].immBitName);
                                      },
                                      child: SizedBox(
                                        width:MediaQuery.of(context).size.width/4,
                                        height: 40,
                                        child: charts.LineChart(
                                          _createSampleData(immediateBitcoins[i].immBitHistoryRate, double.parse(immediateBitcoins[i].immBitDiffRate!)),
                                          layoutConfig: charts.LayoutConfig(
                                              leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                              topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                              rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                              bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                                          defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,),
                                          animate: true,
                                          domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                                          primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          callCurrencyDetails(immediateBitcoins[i].immBitName);
                                        },
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('\$${double.parse(immediateBitcoins[i].immBitRate!.toStringAsFixed(2))}',
                                                style: const TextStyle(fontSize: 18,color: Colors.black)),
                                            const SizedBox(height: 5,),
                                            Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(double.parse(immediateBitcoins[i].immBitDiffRate!) < 0 ? '-' : '+',
                                                      style: TextStyle(fontSize: 12, color: double.parse(immediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green)),
                                                  Icon(Icons.attach_money, size: 12, color: double.parse(immediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green),
                                                  Text(double.parse(immediateBitcoins[i].immBitDiffRate!) < 0
                                                      ? double.parse(immediateBitcoins[i].immBitDiffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                      : double.parse(immediateBitcoins[i].immBitDiffRate!).toStringAsFixed(2),
                                                      style: TextStyle(fontSize: 12, color: double.parse(immediateBitcoins[i].immBitDiffRate!) < 0 ? Colors.red : Colors.green)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ),
            ),
          ],
        ),
      ),
    );}));
  }

  List<charts.Series<LinearSales, int>> _createSampleData(historyRate, diffRate) {
    List<LinearSales> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(LinearSales(i, rate));
    }

    return [
      charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
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
    } else {
      setState(() {});
    }
  }

  Future<void> showPortfolioDialog(ImmediateBitcoin bitcoin) async {
    showModalBottomSheet(
        context: context,
        builder: (ctxt) => ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                body: Container(
                  decoration: const BoxDecoration(color: Color(0xffc1580b)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(40),
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
                                              child:FadeInImage(
                                                  height: 40,
                                                  placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                  image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${bitcoin.immBitName!.toLowerCase()}.png")
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  const SizedBox(width: 50,),
                                  Column(
                                    children: [
                                      Text(bitcoin.immBitName!, style: const TextStyle(fontSize: 25, color: Colors.black),),
                                      const SizedBox(height:10,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(double.parse(bitcoin.immBitDiffRate!) < 0 ? '-' : "+", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: double.parse(bitcoin.immBitDiffRate!) < 0 ? Colors.red : Colors.green)),
                                          Icon(Icons.attach_money, size: 20, color: double.parse(bitcoin.immBitDiffRate!) < 0 ? Colors.red : Colors.green),
                                          Text(double.parse(bitcoin.immBitDiffRate!) < 0
                                              ? "${double.parse(bitcoin.immBitDiffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                              : double.parse(bitcoin.immBitDiffRate!).toStringAsFixed(2),
                                              style: TextStyle(fontSize: 20, color: double.parse(bitcoin.immBitDiffRate!) < 0 ? Colors.red : Colors.green)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Container(
                          decoration: BoxDecoration(color: const Color(0xffc1580b),
                              border: Border.all(color: Colors.white, width: 2)
                          ),
                          child: Form(
                            key: coinAddKey,
                            child: TextFormField(
                              controller: coinAddedTextController,
                              style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: ImmAppLocalizations.of(context).translate('enter_coins'),
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                                  fillColor: Colors.white,
                                ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) {
                                if (coinAddedTextController!.text == "" || int.parse(coinAddedTextController!.value.text) <= 0) {
                                  return ImmAppLocalizations.of(context).translate('invalid_coins');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap:(){
                              _addSaveCoinsToLocalStorage(bitcoin);
                            } ,// Image tapped
                            child: Container(
                              decoration: BoxDecoration(color: const Color(0xffc1580b),border: Border.all(color: Colors.white,width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(ImmAppLocalizations.of(context).translate('add_coins'),textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  _saveProfileData(String name) async {
    sharedPrefer = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefer!.setString("currencyName", name);
      sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('trends'));
      sharedPrefer!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/driftPage', (r) => false);
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _addSaveCoinsToLocalStorage(ImmediateBitcoin bitcoin) async {
    if (coinAddKey.currentState!.validate()) {
      if (immediatePortfolios.isNotEmpty) {
        ImmediatePortfolio? bitcoinLocal = immediatePortfolios.firstWhereOrNull((element) => element.name == bitcoin.immBitName);
        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.immBitName,
            DatabaseHelper.columnRateDuringAdding: bitcoin.immBitRate,
            DatabaseHelper.columnCoinsQuantity: double.parse(coinAddedTextController!.value.text) + bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue: double.parse(coinAddedTextController!.value.text) * (bitcoin.immBitRate!) + bitcoinLocal.totalValue,
          };
          final id = await dbHelp.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.immBitName,
            DatabaseHelper.columnRateDuringAdding: bitcoin.immBitRate,
            DatabaseHelper.columnCoinsQuantity: double.parse(coinAddedTextController!.value.text),
            DatabaseHelper.columnTotalValue: double.parse(coinAddedTextController!.value.text) * (bitcoin.immBitRate!),
          };
          final id = await dbHelp.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: bitcoin.immBitName,
          DatabaseHelper.columnRateDuringAdding: bitcoin.immBitRate,
          DatabaseHelper.columnCoinsQuantity: double.parse(coinAddedTextController!.text),
          DatabaseHelper.columnTotalValue: double.parse(coinAddedTextController!.value.text) * (bitcoin.immBitRate!),
        };
        final id = await dbHelp.insert(row);
        print('inserted row id: $id');
      }

      sharedPrefer = await SharedPreferences.getInstance();
      setState(() {
        sharedPrefer!.setString("currencyName", bitcoin.immBitName!);
        sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('portfolio'));
        sharedPrefer!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("immediateAsset/connectImage/connectMenubg.png",),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height/1.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget> [
                      const SizedBox(height: 20,),
                      Center(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ImmediateConnect()));
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrendsImmediateScreen()));
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const PortfolioImmediateScreen()));
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

  onSearchTextChanged(String text) async {
    searchImmediateBitcoins.clear();
    text = text.toLowerCase();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var userDetail in immediateBitcoins) {
      if (userDetail.immBitName!.toLowerCase().contains(text)) {
        searchImmediateBitcoins.add(userDetail);
      }
    }
    setState(() {});
  }
}

class LinearSales {
  final int count;
  final double rate;
  LinearSales(this.count, this.rate);
}
