// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, sort_child_properties_last, avoid_function_literals_in_foreach_calls, prefer_final_fields, non_constant_identifier_names, library_private_types_in_public_api, file_names, avoid_print, depend_on_referenced_packages, prefer_is_empty, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:ui';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../ImmDataBaseCon/ImmMainConn.dart';
import '../ImmDataBaseCon/ImmDeleteCon.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmDeleteDataCon.dart';
import '../ImmModelCon/ImmPortDataCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'package:collection/collection.dart';
import 'ImmDeleteSheetCon.dart';

class ImmPortSheetConn extends StatefulWidget {
  const ImmPortSheetConn({
    Key? key,
  }) : super(key: key);

  @override
  _ImmPortSheetConn createState() => _ImmPortSheetConn();
}

class _ImmPortSheetConn extends State<ImmPortSheetConn>
    with SingleTickerProviderStateMixin {


  bool imLoadPortConn = false;
  List<ImmBitCoinCon> imBnLtConn = [];
  List<ImLnSlDelConn> imDelChtPortConn = [];
  List<ImLnSlPortConn> imPortChtConn = [];
  String? imCurrPortConn;
  Future<SharedPreferences> _imSpfPortConn = SharedPreferences.getInstance();

  SharedPreferences? imShdPrfPortConn;
  num _imSzPortConn = 0;
  double imTotValPortConn = 0.0;
  double imDelTotValPortConn = 0.0;
  final _imFomKyConn = GlobalKey<FormState>();
  String? immDhConn;
  TextEditingController? imConCoutEdtTextEdtControlConn;
  final imDbMnConn = ImmMainConn.mainInst;
  final imDbDelConn = ImmDeleteCon.deleteInst;
  List<ImmPortDataCon> imItmConn = [];
  List<ImmDeleteDataCon> imDelItmConn = [];
  bool immHdNavConn = false;


  @override
  void initState() {
    setState(() {
      imLoadPortConn = true;
    });
    immLinkValConn();
    imConCoutEdtTextEdtControlConn = TextEditingController();
    imDbMnConn.queryAllRows().then((notes) {
      notes.forEach((note) {
        imItmConn.add(ImmPortDataCon.fromMap(note));
        imTotValPortConn = imTotValPortConn + note["total_value"];
      });
    });

    imDbDelConn.queryAllRows().then((notes) {
      notes.forEach((note) {
        imDelItmConn.add(ImmDeleteDataCon.fromMap(note));
        imDelTotValPortConn =
            imDelTotValPortConn + note["delete_total_value"];
        print(imDelItmConn.length);
      });
    });
    super.initState();
  }

  immLinkValConn() async{
    // ignore: await_only_futures
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      immDhConn = remoteConfig.getString('immediate_api_connect_url').trim();
      immHdNavConn = remoteConfig.getBool('immediate_bool_connect');


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    imBnApiConn();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: getColorFromHex("#FAFAFA"),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 5));
        },
        child: imLoadPortConn == true
            ? Center(child: SizedBox(height: 10, child: ImmLoadBitCon()))
            : Column(
          children: <Widget>[
            Container(
              height: Height / 6,
              decoration: BoxDecoration(
                color: getColorFromHex("#E9EDF6"),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        ImmAppLocalCon.of(context)!
                            .translate('total_portfolio')!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#868990"),
                                fontSize: 12)),
                      )),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Center(
                      child: imCurrPortConn == "USD"
                          ? Text(
                        '\$${imTotValPortConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 36,
                                color: getColorFromHex("#1264FF"))),
                        textAlign: TextAlign.left,
                      )
                          : imCurrPortConn == "INR"
                          ? Text(
                        '₹${imTotValPortConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 36,
                                color: getColorFromHex(
                                    "#1264FF"))),
                        textAlign: TextAlign.left,
                      )
                          : imCurrPortConn == "EUR"
                          ? Text(
                        '€${imTotValPortConn.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 36,
                                color: getColorFromHex(
                                    "#1264FF"))),
                        textAlign: TextAlign.left,
                      )
                          : const Text(""),
                    ),
                  )
                ],
              ),
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
                        ImmAppLocalCon.of(context)!
                            .translate('Statistics')!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#2D2E31"),
                                fontSize: 16)),
                      )),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImmDeleteSheetCon()));
                  },
                  child: Text(
                    ImmAppLocalCon.of(context)!.translate("see_all")!,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: getColorFromHex("#2D2E31"),
                            fontSize: 12)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  top: 0, left: 10, right: 10, bottom: 20),
              height: Height / 10,
              decoration: BoxDecoration(
                color: getColorFromHex("#272735"),
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
                        ImmAppLocalCon.of(context)!.translate("Text3")!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: getColorFromHex("#868990"),
                                fontSize: 12)),
                      ),
                      const SizedBox(height: 5),
                      imCurrPortConn == "USD"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '\$${imTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white)),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : imCurrPortConn == "INR"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '₹${imTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white)),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : imCurrPortConn == "EUR"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '€${imTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight:
                                  FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white)),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : const Text(""),
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
                        SplineSeries<ImLnSlPortConn, double>(
                          dataSource: imPortChtConn,
                          xValueMapper: (ImLnSlPortConn data, _) =>
                          data.date,
                          yValueMapper: (ImLnSlPortConn data, _) =>
                          data.rate,
                          color: Colors.white,
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
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
              height: Height / 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ImmAppLocalCon.of(context)!
                            .translate("Deleted_Coins")!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: getColorFromHex("#868990"),
                                fontSize: 12)),
                      ),
                      const SizedBox(height: 5),
                      imCurrPortConn == "USD"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '\$${imDelTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color:
                                  getColorFromHex("#2D2E31"))),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : imCurrPortConn == "INR"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '₹${imDelTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: getColorFromHex(
                                      "#2D2E31"))),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : imCurrPortConn == "EUR"
                          ? SizedBox(
                        width: 120,
                        child: Text(
                          '€${imDelTotValPortConn.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontWeight:
                                  FontWeight.w500,
                                  fontSize: 20,
                                  color: getColorFromHex(
                                      "#2D2E31"))),
                          textAlign: TextAlign.left,
                        ),
                      )
                          : const Text(""),
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
                          dataSource: imDelChtPortConn,
                          xValueMapper: (ImLnSlDelConn data, _) =>
                          data.date,
                          yValueMapper: (ImLnSlDelConn data, _) =>
                          data.rate,
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
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 10, left: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        ImmAppLocalCon.of(context)!.translate('Text3')!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#2D2E31"),
                                fontSize: 16)),
                      )),
                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    imPassDtToTrdConn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        ImmAppLocalCon.of(context)!.translate('add_coins')!,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#2D2E31"),
                                fontSize: 16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: imItmConn.length > 0
                    ? ListView.builder(
                    itemCount: imItmConn.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            imShwUpdPortDialConn(imItmConn[i]);
                          },
                          child: Container(
                            height: Height / 4.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: InkWell(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 31,
                                        width: 31,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              1.0),
                                          child: FadeInImage(
                                            placeholder: const AssetImage(
                                                'assets/images/cob.png'),
                                            image: NetworkImage(
                                                "https://assets.coinlayer.com/icons/${imItmConn[i].symbol}.png"),
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
                                            '${imItmConn[i].symbol} Coin',
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 20,
                                                    color: Colors
                                                        .black)),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${imItmConn[i].numberOfCoins}',
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontSize: 14,
                                                    color: getColorFromHex(
                                                        "#808D90"))),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          _imShwDelPrtDialConn(
                                              imItmConn[i]);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(10),
                                              border: Border.all(
                                                  color:
                                                  getColorFromHex(
                                                      "#D9E1E7"))),
                                          child: Center(
                                            child: Text(
                                              ImmAppLocalCon.of(
                                                  context)!
                                                  .translate(
                                                  'Delete')!,
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      color: getColorFromHex(
                                                          "#1264FF"),
                                                      fontSize: 14)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    height: Height / 9,
                                    decoration: BoxDecoration(
                                      color:
                                      getColorFromHex("#217EFD")
                                          .withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(

                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 10),
                                          height: Height / 11.5,
                                          width: Width / 2.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                6),
                                          ),
                                          child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  imCurrPortConn == "USD"
                                                      ? Text(
                                                    '\$${imItmConn[i].totalValue.toStringAsFixed(0)}',
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
                                                      : imCurrPortConn == "INR"
                                                      ? Text(
                                                    '₹${imItmConn[i].totalValue.toStringAsFixed(0)}',
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: GoogleFonts
                                                        .roboto(
                                                        textStyle:
                                                        const TextStyle(
                                                          fontSize:
                                                          25,
                                                          color: Colors
                                                              .black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        )),
                                                  )
                                                      : imCurrPortConn ==
                                                      "EUR"
                                                      ? Text(
                                                    '€${imItmConn[i].totalValue.toStringAsFixed(0)}',
                                                    maxLines:
                                                    1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                        textStyle: const TextStyle(
                                                          fontSize:
                                                          25,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                        )),
                                                  )
                                                      : const Text(""),
                                                  Container(
                                                    height: 25,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10),
                                                        color: getColorFromHex(
                                                            "#1AD598")
                                                            .withOpacity(
                                                            0.1)),
                                                    child: imCurrPortConn ==
                                                        "USD"
                                                        ? SizedBox(
                                                      width: 80,
                                                      child: Center(
                                                        child: Text(
                                                          "\$${imItmConn[i].rateDuringAdding.toStringAsFixed(2)}",
                                                          maxLines:
                                                          1,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .roboto(
                                                              textStyle: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                color: getColorFromHex(
                                                                    "#1AD598"),
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                        : imCurrPortConn ==
                                                        "INR"
                                                        ? SizedBox(
                                                      width: 80,
                                                      child:
                                                      Center(
                                                        child:
                                                        Text(
                                                          "₹${imItmConn[i].rateDuringAdding.toStringAsFixed(2)}",
                                                          maxLines:
                                                          1,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: GoogleFonts.roboto(
                                                              textStyle: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                color:
                                                                getColorFromHex("#1AD598"),
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                        : imCurrPortConn ==
                                                        "EUR"
                                                        ? SizedBox(
                                                      width:
                                                      80,
                                                      child:
                                                      Center(
                                                        child:
                                                        Text(
                                                          "€${imItmConn[i].rateDuringAdding.toStringAsFixed(2)}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.roboto(
                                                              textStyle: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w700,
                                                                color: getColorFromHex("#1AD598"),
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                        : const Text(
                                                        ""),
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
                        ),
                      );
                    })
                    : Center(
                    child: InkWell(
                      onTap: () async {
                        imPassDtToTrdConn();
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          ImmAppLocalCon.of(context)!
                              .translate('no_coins_added')!,
                          style: TextStyle(
                              color: getColorFromHex("#1264FF")),
                        ),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Future<void> imBnApiConn() async {
    final SharedPreferences prefs = await _imSpfPortConn;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurrPortConn = currencyName;
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=$imCurrPortConn';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    double count = 0;
    if (data['error'] == false) {
      setState(() {
        imBnLtConn.addAll(
            data['data'].map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json)).toList());
        imDelItmConn.forEach((element) {
          imDelChtPortConn
              .add(ImLnSlDelConn(count, element.rateDuringAdding));
          count = count + 1;
        });
        imItmConn.forEach((element) {
          imPortChtConn.add(
              ImLnSlPortConn(count, element.rateDuringAdding));
          count = count + 1;
        });

        imLoadPortConn = false;
        _imSzPortConn = _imSzPortConn + data['data'].length;
      });
    }
    else {}
  }

  Future<void> imShwUpdPortDialConn(ImmPortDataCon bitcoin) async {
    imConCoutEdtTextEdtControlConn!.text =
        bitcoin.numberOfCoins.toInt().toString();
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
                ImmAppLocalCon.of(context)!.translate('update_coins')!,
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
              actions: const <Widget>[],
            ),
            body: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#1264FF"),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FadeInImage(
                                placeholder:
                                const AssetImage('assets/images/cob.png'),
                                image: NetworkImage(
                                    "https://assets.coinlayer.com/icons/${bitcoin.symbol}.png"),
                              ),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            bitcoin.symbol,
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
                        imCurrPortConn == "USD"
                            ? SizedBox(
                          width: 180,
                          child: Text(
                            '\$${bitcoin.totalValue.toStringAsFixed(2)}',
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
                            : imCurrPortConn == "INR"
                            ? SizedBox(
                          width: 180,
                          child: Text(
                            '₹${bitcoin.totalValue.toStringAsFixed(2)}',
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
                            : imCurrPortConn == "EUR"
                            ? SizedBox(
                          width: 180,
                          child: Text(
                            '€${bitcoin.totalValue.toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    fontWeight:
                                    FontWeight.w500,
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
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        width: 4,
                        color: getColorFromHex("#1264FF"),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ImmAppLocalCon.of(context)!
                                .translate('enter_coins')!,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8)),
                            textAlign: TextAlign.start,
                          ),
                          TextFormField(
                            key: _imFomKyConn,
                            controller: imConCoutEdtTextEdtControlConn,
                            style: const TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                            ], // O
                            //only numbers can be entered
                            validator: (val) {
                              if (imConCoutEdtTextEdtControlConn!
                                  .value.text ==
                                  "" ||
                                  double.parse(
                                      imConCoutEdtTextEdtControlConn!
                                          .value.text) <=
                                      0) {
                                return "at least 1 coin should be added";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Stack(children: [
                    Image.asset("assets/images/addcoinbottomi.png"),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 110),
                      child: InkWell(
                        onTap: () {
                          _imUpdConToLolStConn(bitcoin);
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                ImmAppLocalCon.of(context)!
                                    .translate('update_coins')!,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: getColorFromHex("#1264FF"),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }

  _imUpdConToLolStConn(ImmPortDataCon bitcoin) async {
    if (imConCoutEdtTextEdtControlConn!.text.isNotEmpty &&
        imConCoutEdtTextEdtControlConn!.text != 0) {
      int adf = int.parse(imConCoutEdtTextEdtControlConn!.text);
      print(adf);
      Map<String, dynamic> row = {
        ImmMainConn.columnName: bitcoin.name,
        ImmMainConn.columnRateDuringAdding: bitcoin.rateDuringAdding,
        ImmMainConn.columnCoinsQuantity:
        double.parse(imConCoutEdtTextEdtControlConn!.value.text),
        ImmMainConn.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await imDbMnConn.update(row);
      print('inserted row id: $id');
      imShdPrfPortConn = await SharedPreferences.getInstance();
      setState(() {
        imShdPrfPortConn!.setString("currencyName", bitcoin.symbol);
        imShdPrfPortConn!.setInt("index", immHdNavConn?2:1);
        // imShdPrfPortConn!.setBool("imHdCon", immHdNavConn);
        imShdPrfPortConn!.setString("title",
            ImmAppLocalCon.of(context)!.translate('portfolio') ?? '');
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/NavigationPage', (r) => false);
    }
  }

  void _imShwDelPrtDialConn(ImmPortDataCon item) {
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
              actions: const <Widget>[],
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
                      imCurrPortConn == "USD"
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
                          : imCurrPortConn == "INR"
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
                          : imCurrPortConn == "EUR"
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
                        _imDelConFromLolStConn(item);
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

  _imDelConFromLolStConn(ImmPortDataCon item) async {
    if (imDelItmConn.length > 0) {
      ImmDeleteDataCon? bitcoinLocal =
      imDelItmConn.firstWhereOrNull((element) => element.name == item.name);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          ImmDeleteCon.columnName: item.name,
          ImmDeleteCon.columnSymbol: item.symbol,
          ImmDeleteCon.columnRateDuringAdding: item.rateDuringAdding,
          ImmDeleteCon.columnCoinsQuantity: item.numberOfCoins,
          ImmDeleteCon.columnTotalValue: bitcoinLocal.totalValue -
              item.numberOfCoins * (item.rateDuringAdding)
        };
        final id = await imDbDelConn.update(row);
        print('inserted row id: $id');
      } else {
        Map<String, dynamic> row = {
          ImmDeleteCon.columnName: item.name,
          ImmDeleteCon.columnSymbol: item.symbol,
          ImmDeleteCon.columnRateDuringAdding: item.rateDuringAdding,
          ImmDeleteCon.columnCoinsQuantity: item.numberOfCoins,
          ImmDeleteCon.columnTotalValue:
          item.numberOfCoins * (item.rateDuringAdding)
        };
        final id = await imDbDelConn.insert(row);
        print('inserted row id: $id');
      }
    } else {
      Map<String, dynamic> row = {
        ImmDeleteCon.columnName: item.name,
        ImmDeleteCon.columnSymbol: item.symbol,
        ImmDeleteCon.columnRateDuringAdding: item.rateDuringAdding,
        ImmDeleteCon.columnCoinsQuantity: item.numberOfCoins,
        ImmDeleteCon.columnTotalValue:
        item.numberOfCoins * (item.rateDuringAdding)
      };
      final id = await imDbDelConn.insert(row);
      print('inserted row id: $id');
    }

    final id = await imDbMnConn.delete(item.name);
    print('inserted row id: $id');

    imShdPrfPortConn = await SharedPreferences.getInstance();
    setState(() {
      imShdPrfPortConn!.setInt("index", immHdNavConn?2:1);
      imShdPrfPortConn!.setString(
          "title", ImmAppLocalCon.of(context)!.translate('portfolio') ?? '');
      // imShdPrfPortConn!.setBool("imHdCon", immHdNavConn);
    });
    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

  Future<void> imPassDtToTrdConn() async {
    _imSvValForTrdPgConn();
  }

  _imSvValForTrdPgConn() async {
    imShdPrfPortConn = await SharedPreferences.getInstance();
    setState(() {
      imShdPrfPortConn!.setInt("index",immHdNavConn?1:0);
      // imShdPrfPortConn!.setBool("imHdCon", immHdNavConn);
      imShdPrfPortConn!.setString("title",
          ImmAppLocalCon.of(context)!.translate('Crypto_Market').toString());
    });

    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

}

class ImLnSlDelConn {
  final double date;
  final double rate;

  ImLnSlDelConn(this.date, this.rate);
}

class ImLnSlPortConn {
  final double date;
  final double rate;

  ImLnSlPortConn(this.date, this.rate);
}

class ImLnSlConnPort {
  final int count;
  final double rate;

  ImLnSlConnPort(this.count, this.rate);
}
