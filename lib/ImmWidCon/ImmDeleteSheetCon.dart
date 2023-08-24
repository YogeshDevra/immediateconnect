// ignore_for_file: avoid_print, use_build_context_synchronously, sort_child_properties_last, avoid_function_literals_in_foreach_calls, file_names, depend_on_referenced_packages, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, sized_box_for_whitespace, prefer_is_empty, await_only_futures

import 'dart:convert';
import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmDeleteDataCon.dart';
import '../ImmDataBaseCon/ImmDeleteCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmPortSheetCon.dart';

class ImmDeleteSheetCon extends StatefulWidget {
  const ImmDeleteSheetCon({
    Key? key,
  }) : super(key: key);

  @override
  _ImmDeleteSheetCon createState() => _ImmDeleteSheetCon();
}

class _ImmDeleteSheetCon extends State<ImmDeleteSheetCon>
    with SingleTickerProviderStateMixin {

  SharedPreferences? DelShdPRfImm;
  String? immDhConn;
  final immDBDelete = ImmDeleteCon.deleteInst;
  List<ImmDeleteDataCon> imDelCon = [];
  List<ImmBitCoinCon> immBtLtDelConn = [];
  List<ImLnSlDelConn> imDlChtDtConn = [];
  List<ImmDeleteDataCon> imItmDelConn = [];
  bool immHdNavConn = false;
  double imDelTotValConn = 0.0;
  bool immLoadConn = false;
  String? imCurrDelCon;
  Future<SharedPreferences> _imSpfDelCon = SharedPreferences.getInstance();

  @override
  void initState() {
    immLinkValConn();
    immDBDelete.queryAllRows().then((notes) {
      notes.forEach((note) {
        imDelCon.add(ImmDeleteDataCon.fromMap(note));
        imDelTotValConn =
            imDelTotValConn + note["delete_total_value"];
        print(imDelCon.length);
      });
    });
    immDBDelete.queryAllRows().then((notes) {
      notes.forEach((note) {
        imItmDelConn.add(ImmDeleteDataCon.fromMap(note));
      });
    });
    super.initState();
  }

  immLinkValConn() async{
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      immDhConn = remoteConfig.getString('immediate_api_connect_url');
      immHdNavConn = remoteConfig.getBool('immediate_bool_connect');


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    immBitConnApi();
  }

  Future<void> immBitConnApi() async {
    setState(() {
      immLoadConn = true;
    });
    final SharedPreferences prefs = await _imSpfDelCon;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurrDelCon = currencyName;
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=$imCurrDelCon';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      immBtLtDelConn.addAll(
          data['data'].map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json)).toList());
      double count = 0;

      imItmDelConn.forEach((element) {
        imDlChtDtConn
            .add(ImLnSlDelConn(count, element.rateDuringAdding));

        count = count + 1;
      });

      immLoadConn = false;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await _imSpfDelCon;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurrDelCon = currencyName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex("#FAFAFA"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColorFromHex("#F6E9E9"),
        centerTitle: true,
        title: Text(
          ImmAppLocalCon.of(context)!.translate('Deleted_Coins')!,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        ),
        leading: InkWell(
          child: Container(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        leadingWidth: 35,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!.translate('Statistics')!,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: getColorFromHex("#2D2E31"),
                              fontSize: 16)),
                    )),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
            height: MediaQuery.of(context).size.height / 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ImmAppLocalCon.of(context)!.translate("Deleted_Coins")!,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: getColorFromHex("#868990"),
                              fontSize: 12)),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 120,
                      child: imCurrDelCon == "USD"
                          ? Text(
                        '\$${imDelTotValConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: getColorFromHex("#2D2E31"))),
                        textAlign: TextAlign.left,
                      )
                          : imCurrDelCon == "INR"
                          ? Text(
                        '₹${imDelTotValConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: getColorFromHex("#2D2E31"))),
                        textAlign: TextAlign.left,
                      )
                          : imCurrDelCon == "EUR"
                          ? Text(
                        '€${imDelTotValConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color:
                                getColorFromHex("#2D2E31"))),
                        textAlign: TextAlign.left,
                      )
                          : const Text(""),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 160,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    enableAxisAnimation: true,
                    enableSideBySideSeriesPlacement: true,
                    series: <ChartSeries>[
                      SplineSeries<ImLnSlDelConn, double>(
                        dataSource: imDlChtDtConn,
                        xValueMapper: (ImLnSlDelConn data, _) => data.date,
                        yValueMapper: (ImLnSlDelConn data, _) => data.rate,
                        color: getColorFromHex("#5EF865"),
                      )
                    ],
                    primaryXAxis: NumericAxis(
                      isVisible: false,
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10, left: 20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!.translate('Deleted_Coins')!,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: getColorFromHex("#2D2E31"),
                              fontSize: 16)),
                    )),
              ),
            ],
          ),
          Expanded(
            child: imDelCon.length > 0
                ? ListView.builder(
              itemCount: imDelCon.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 31,
                                  width: 31,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/images/cob.png'),
                                      image: NetworkImage(
                                          "https://assets.coinlayer.com/icons/${imDelCon[i].symbol}.png"),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${imDelCon[i].symbol} Coin',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: Colors.black)),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${imDelCon[i].numberOfCoins}',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: getColorFromHex(
                                                  "#808D90"))),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    _imShDlDialConn(
                                        imDelCon[i]);
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey)),
                                    child: Center(
                                      child: Text(
                                        ImmAppLocalCon.of(context)!
                                            .translate('Delete')!,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: getColorFromHex(
                                                    "#1264FF"),
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              height:
                              MediaQuery.of(context).size.height / 9,
                              decoration: BoxDecoration(
                                color: getColorFromHex("#FD2121")
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3,
                                      height: 70,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: immLoadConn == true
                                          ? Center(
                                          child: SizedBox(
                                              height: 10,
                                              child: ImmLoadBitCon()))
                                          : charts.LineChart(
                                        _createSampleData(
                                            immBtLtDelConn[i]
                                                .historyRate,
                                            double.parse(
                                                immBtLtDelConn[i]
                                                    .diffRate!)),
                                        layoutConfig: charts
                                            .LayoutConfig(
                                            leftMarginSpec: charts
                                                .MarginSpec.fixedPixel(
                                                5),
                                            topMarginSpec: charts
                                                .MarginSpec.fixedPixel(
                                                10),
                                            rightMarginSpec: charts
                                                .MarginSpec.fixedPixel(
                                                5),
                                            bottomMarginSpec: charts
                                                .MarginSpec.fixedPixel(
                                                10)),
                                        defaultRenderer: charts
                                            .LineRendererConfig(
                                          includeArea: true,
                                          stacked: true,
                                        ),
                                        animate: true,
                                        domainAxis:
                                        const charts.NumericAxisSpec(
                                            showAxisLine: false,
                                            renderSpec: charts
                                                .NoneRenderSpec()),
                                        primaryMeasureAxis:
                                        const charts.NumericAxisSpec(
                                            renderSpec: charts
                                                .NoneRenderSpec()),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                  const SizedBox(width: 2),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: MediaQuery.of(context)
                                        .size
                                        .height /
                                        11.5,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        2.5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            imCurrDelCon == "USD"
                                                ? Text(
                                              '\$${imDelCon[i].totalValue.toStringAsFixed(0)}',
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  )),
                                            )
                                                : imCurrDelCon == "INR"
                                                ? Text(
                                              '₹${imDelCon[i].totalValue.toStringAsFixed(0)}',
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: GoogleFonts
                                                  .roboto(
                                                  textStyle:
                                                  const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  )),
                                            )
                                                : imCurrDelCon == "EUR"
                                                ? Text(
                                              '€${imDelCon[i].totalValue.toStringAsFixed(0)}',
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              style: GoogleFonts
                                                  .roboto(
                                                  textStyle:
                                                  const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )),
                                            )
                                                : const Text(""),
                                            Container(
                                              height: 25,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                                  color: getColorFromHex(
                                                      "#1AD598")
                                                      .withOpacity(0.1)),
                                              child: imCurrDelCon == "USD"
                                                  ? SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child: Text(
                                                    "\$${imDelCon[i].rateDuringAdding.toStringAsFixed(2)}",
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .roboto(
                                                        textStyle:
                                                        TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          color:
                                                          getColorFromHex(
                                                              "#1AD598"),
                                                        )),
                                                    textAlign:
                                                    TextAlign.left,
                                                  ),
                                                ),
                                              )
                                                  : imCurrDelCon == "INR"
                                                  ? SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child: Text(
                                                    "₹${imDelCon[i].rateDuringAdding.toStringAsFixed(2)}",
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .roboto(
                                                        textStyle:
                                                        TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          color: getColorFromHex(
                                                              "#1AD598"),
                                                        )),
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                  ),
                                                ),
                                              )
                                                  : imCurrDelCon == "EUR"
                                                  ? SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child: Text(
                                                    "€${imDelCon[i].rateDuringAdding.toStringAsFixed(2)}",
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .roboto(
                                                        textStyle:
                                                        TextStyle(
                                                          fontSize:
                                                          13,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          color: getColorFromHex(
                                                              "#1AD598"),
                                                        )),
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                  ),
                                                ),
                                              )
                                                  : const Text(""),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ImmAppLocalCon.of(context)!
                        .translate('no_coins_added')!,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _imDlCnFmStgConn(ImmDeleteDataCon items) async {
    setState(() async {
      final id = await immDBDelete.delete(items.name.toString());
      print('inserted row id: $id');
      DelShdPRfImm = await SharedPreferences.getInstance();
      setState(() {
        DelShdPRfImm!.setInt("index", immHdNavConn?2:1);
        // DelShdPRfImm!.setBool("imHdCon", immHdNavConn);
        DelShdPRfImm!.setString("title",
            ImmAppLocalCon.of(context)!.translate('portfolio').toString());
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/NavigationPage', (r) => false);

      Fluttertoast.showToast(
          msg: "${items.name} is Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  List<charts.Series<ImLnSlConnPort, int>> _createSampleData(
      historyRate, diffRate) {
    List<ImLnSlConnPort> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(ImLnSlConnPort(i, rate));
    }

    return [
       charts.Series<ImLnSlConnPort, int>(
        id: 'Tablet',
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        domainFn: (ImLnSlConnPort sales, _) => sales.count,
        measureFn: (ImLnSlConnPort sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  void _imShDlDialConn(ImmDeleteDataCon item) {
    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: getColorFromHex("#FAFAFA"),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: getColorFromHex("#FAFAFA"),
              centerTitle: true,
              title: Text(
                ImmAppLocalCon.of(context)!.translate('Delete_Coins')!,
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                textAlign: TextAlign.start,
              ),
              leading: InkWell(
                child: Container(
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              leadingWidth: 35,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: getColorFromHex("#FF1212"),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Row(
                    children: [
                      Container(
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FadeInImage(
                              placeholder:
                              const AssetImage('assets/images/cob.png'),
                              image: NetworkImage(
                                  "https://assets.coinlayer.com/icons/${item.symbol}.png"),
                            ),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          item.symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                      const Spacer(),
                      imCurrDelCon == "USD"
                          ? SizedBox(
                        width: 180,
                        child: Text(
                          "\$${item.totalValue.toStringAsFixed(2)}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      )
                          : imCurrDelCon == "INR"
                          ? SizedBox(
                        width: 180,
                        child: Text(
                          "₹${item.totalValue.toStringAsFixed(2)}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      )
                          : imCurrDelCon == "EUR"
                          ? SizedBox(
                        width: 180,
                        child: Text(
                          "€${item.totalValue.toStringAsFixed(2)}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      )
                          : const Text(""),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.red,
                      ),
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        item.numberOfCoins.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 41,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    )),
                const Spacer(),
                Stack(children: [
                  Image.asset("assets/images/Rectangle.png"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 110),
                    child: InkWell(
                      onTap: () {
                        _imDlCnFmStgConn(item);
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              ImmAppLocalCon.of(context)!
                                  .translate('Delete_CoinsButt')!,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12)),
                              textAlign: TextAlign.start,
                            ),
                          )),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }
}