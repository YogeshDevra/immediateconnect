import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_helper.dart';
import 'dashboard_home.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';
import 'portfoliopage.dart';
import 'topcoin.dart';
import 'trendsPage.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  _CoinsPageState createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller = new TextEditingController();
  bool isLoading = false;
  List<Bitcoin> bitcoinList = [];
  List<Bitcoin> _searchResult = [];
  SharedPreferences? sharedPreferences;
  num _size = 0;
  double totalValuesOfPortfolio = 0.0;
  final _formKey2 = GlobalKey<FormState>();
  String? URL;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];
  TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    fetchRemoteValue();
    coinCountTextEditingController = TextEditingController();
    coinCountEditTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {});
    });
    super.initState();
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
      URL = remoteConfig.getString('immediate_connect_port_url').trim();
      print(URL);
      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callBitcoinApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 50),
        child:
        AppBar(
            centerTitle: true,
            // shadowColor: Colors.white,
            // elevation: 0.0,
            backgroundColor: const Color(0xffd76614),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _modalBottomMenu();
                    });
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Color(0xFFFFFFFF),)
              ),
            ),
            title: Text(AppLocalizations.of(context).translate('coins'),
                style: GoogleFonts.openSans(textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),)
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xffd76614)
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(40)
                ),
              ),
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search,color: Color(0xffd76614)),
                    title: new TextField(
                      controller: _controller,
                      decoration: new InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('search')!, border: InputBorder.none,
                      ),
                      onChanged: onSearchTextChanged,
                    ),
                    // trailing: new IconButton(icon: new Icon(Icons.cancel_outlined,color: Color(0xffd76614)), onPressed: () {
                    //   _controller.clear();
                    //   onSearchTextChanged('');
                    // },),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context).translate('swipe'),textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white,fontSize: 15),),
            ),
            Expanded(
              child:Container(
                decoration: const BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40),)),
                padding: const EdgeInsets.only(
                    left: 10, right: 10,  top: 20),
                child:
                LazyLoadScrollView(
                  isLoading: isLoading,
                  onEndOfPage: () => callBitcoinApi(),
                  child: bitcoinList.length <= 0
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResult.length != 0 ||
                      _searchController.text.isNotEmpty
                      ?ListView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
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
                                        callCurrencyDetails(_searchResult[i].name);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                    height: 70,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: FadeInImage(
                                                        placeholder: const AssetImage('assets/image/cob.png'),
                                                        image: NetworkImage("$URL/Bitcoin/resources/icons/${_searchResult[i].name!.toLowerCase()}.png"),
                                                      ),
                                                    )),
                                              ]),
                                          Padding(
                                              padding: const EdgeInsets.only(left:10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('${_searchResult[i].name}',
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
                                        callCurrencyDetails(_searchResult[i].name);
                                      },
                                      child: Container(
                                        width:MediaQuery.of(context).size.width/4,
                                        height: 40,
                                        child: charts.LineChart(
                                          _createSampleData(_searchResult[i].historyRate, double.parse(bitcoinList[i].diffRate!)),
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
                                          callCurrencyDetails(_searchResult[i].name);
                                        },
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('\$${double.parse(_searchResult[i].rate!.toStringAsFixed(2))}',
                                                style: const TextStyle(fontSize: 18,color: Colors.black)),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(double.parse(_searchResult[i].diffRate!) < 0 ? '-' : '+',
                                                      style: TextStyle(fontSize: 12, color: double.parse(_searchResult[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                                  Icon(Icons.attach_money, size: 12, color: double.parse(_searchResult[i].diffRate!) < 0 ? Colors.red : Colors.green),
                                                  Text(double.parse(_searchResult[i].diffRate!) < 0 ? double.parse(_searchResult[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                      : double.parse(_searchResult[i].diffRate!).toStringAsFixed(2),
                                                      style: TextStyle(fontSize: 12, color: double.parse(_searchResult[i].diffRate!) < 0 ? Colors.red : Colors.green)),
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
                          background : Container(
                            color: Colors.green,
                            child: InkWell(
                                onTap: () {
                                  showPortfolioDialog(_searchResult[i]);
                                }, // Image tapped
                                child: const Icon(Icons.add,color: Colors.white,size:20)
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction){
                            setState(() {
                              showPortfolioDialog(_searchResult[i]);
                            });
                          },
                        );
                      }
                      )
                      :ListView.builder(
                      itemCount: bitcoinList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Dismissible(
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
                                        callCurrencyDetails(bitcoinList[i].name);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Stack(
                                              children: <Widget>[
                                                Container(
                                                    height: 70,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: FadeInImage(
                                                        placeholder: const AssetImage('assets/image/cob.png'),
                                                        image: NetworkImage("$URL/Bitcoin/resources/icons/${bitcoinList[i].name!.toLowerCase()}.png"),
                                                      ),
                                                    )),
                                              ]),
                                          Padding(
                                              padding: const EdgeInsets.only(left:10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('${bitcoinList[i].name}',
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
                                        callCurrencyDetails(bitcoinList[i].name);
                                      },
                                      child: Container(
                                        width:MediaQuery.of(context).size.width/4,
                                        height: 40,
                                        child: charts.LineChart(
                                          _createSampleData(bitcoinList[i].historyRate, double.parse(bitcoinList[i].diffRate!)),
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
                                          callCurrencyDetails(bitcoinList[i].name);
                                        },
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('\$${double.parse(bitcoinList[i].rate!.toStringAsFixed(2))}',
                                                style: const TextStyle(fontSize: 18,color: Colors.black)),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(double.parse(bitcoinList[i].diffRate!) < 0 ? '-' : '+',
                                                      style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                                  Icon(Icons.attach_money, size: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green),
                                                  Text(double.parse(bitcoinList[i].diffRate!) < 0 ? double.parse(bitcoinList[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                      : double.parse(bitcoinList[i].diffRate!).toStringAsFixed(2),
                                                      style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
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
                          background : Container(
                            color: Colors.green,
                            child: InkWell(
                                onTap: () {
                                  showPortfolioDialog(bitcoinList[i]);
                                }, // Image tapped
                                child: const Icon(Icons.add,color: Colors.white,size:20)
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction){
                            setState(() {
                              showPortfolioDialog(bitcoinList[i]);
                            });
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
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
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.count,
        measureFn: (LinearSales sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  Future<void> callBitcoinApi() async {
    // var uri = '$URL/Bitcoin/resources/getBitcoinList?size=${_size}';
    var uri = '$URL/Bitcoin/resources/getBitcoinList?size=${_size}';
    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList());
        isLoading = false;
        _size = _size + data['data'].length;
      });
    } else {
      setState(() {});
    }
  }


  Future<void> showPortfolioDialog(Bitcoin bitcoin) async {
    showModalBottomSheet(
        context: context,
        builder: (ctxt) => ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffc1580b),
                      // borderRadius: BorderRadius.vertical(top: Radius.circular(40))
                    ),
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
                                                  placeholder: const AssetImage('assets/image/cob.png'),
                                                  image: NetworkImage(
                                                      "$URL/Bitcoin/resources/icons/${bitcoin.name!.toLowerCase()}.png")
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      Text(bitcoin.name!,
                                        style: const TextStyle(fontSize: 25, color: Colors.black),),
                                      const SizedBox(
                                        height:10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(double.parse(bitcoin.diffRate!) < 0 ? '-' : "+", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: double.parse(bitcoin.diffRate!) < 0 ? Colors.red : Colors.green)),
                                          Icon(Icons.attach_money, size: 20, color: double.parse(bitcoin.diffRate!) < 0 ? Colors.red : Colors.green),
                                          Text(double.parse(bitcoin.diffRate!) < 0
                                              ? "${double.parse(bitcoin.diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                              : "${double.parse(bitcoin.diffRate!).toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 20,
                                                  color: double.parse(bitcoin.diffRate!) < 0
                                                      ? Colors.red
                                                      : Colors.green)
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
                          decoration: BoxDecoration(color: Color(0xffc1580b),
                              border: Border.all(color: Colors.white, width: 2)
                          ),
                          child: Form(
                            key: _formKey2,
                            child: TextFormField(
                              controller: coinCountTextEditingController,
                              style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).translate('enter_coins'),
                                  labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                  fillColor: Colors.white,
                                ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) {
                                if (coinCountTextEditingController!.text == "" || int.parse(coinCountTextEditingController!.value.text) <= 0) {
                                  return AppLocalizations.of(context).translate('invalid_coins');
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
                              decoration: BoxDecoration(color: Color(0xffc1580b),border: Border.all(color: Colors.white,width: 2)),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(AppLocalizations.of(context).translate('add_coins'),textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
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
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/driftPage', (r) => false);
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _addSaveCoinsToLocalStorage(Bitcoin bitcoin) async {
    if (_formKey2.currentState!.validate()) {
      if (items.length > 0) {
        PortfolioBitcoin? bitcoinLocal =
        items.firstWhereOrNull(
                (element) => element.name == bitcoin.name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.name,
            DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (bitcoin.rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.name,
            DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (bitcoin.rate!),
          };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: bitcoin.name,
          DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
          DatabaseHelper.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          DatabaseHelper.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (bitcoin.rate!),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name!);
        sharedPreferences!.setString("title", AppLocalizations.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
  }

  getCurrentRateDiff(PortfolioBitcoin items, List<Bitcoin> bitcoinList) {
    Bitcoin j = bitcoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! - items.rateDuringAdding;
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
                    image: AssetImage("assets/image/Group 33770.png",),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DashboardHome()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33764.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('home'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TopCoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33765.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33766.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('coins'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TrendsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33767.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('trends'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PortfolioPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33768.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 25),
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
    _searchResult.clear();
    text = text.toLowerCase();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bitcoinList.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }

}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
