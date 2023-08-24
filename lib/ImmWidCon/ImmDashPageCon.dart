// ignore_for_file: import_of_legacy_library_into_null_safe, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, depend_on_referenced_packages, prefer_final_fields, avoid_function_literals_in_foreach_calls, prefer_is_empty, file_names, library_private_types_in_public_api, await_only_futures

import 'dart:convert';
import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../ImmDataBaseCon/ImmFavCon.dart';
import '../ImmDataBaseCon/ImmMainConn.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmFavDataCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmCoinSheetUpCon.dart';

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}

class ImmDashPgConn extends StatefulWidget {
  const ImmDashPgConn({Key? key}) : super(key: key);

  @override
  _ImmDashPgConn createState() => _ImmDashPgConn();
}

class _ImmDashPgConn extends State<ImmDashPgConn>
    with SingleTickerProviderStateMixin {


  bool imLdGpFvConn = false;
  List<ImmFavDataCon> imItmWshConn = [];
  List<ImmBitCoinCon> imBnLstConn = [];
  final imDbFavConn = ImmFavCon.favInst;

  String? imCurFavConn;
  Future<SharedPreferences> _imSpfDhConn = SharedPreferences.getInstance();

  bool imLdFvConn = false;
  SharedPreferences? sharedPreferences;
  String? immDhConn;
  bool immHdNavConn = false;
  double totalValuesOfPortfolio = 0.0;
  final dbHelper = ImmMainConn.mainInst;

  @override
  void initState() {
    setState(() {
      imLdGpFvConn = true;
    });
    immLinkValConn();

    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {
        imLdGpFvConn = false;
      });
    });
    imDbFavConn.queryAllRows().then((notes) {
      notes.forEach((note) {
        imItmWshConn.add(ImmFavDataCon.fromMap(note));
      });
      setState(() {
        imLdGpFvConn = false;
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
      immDhConn = remoteConfig.getString('immediate_api_connect_url').trim();
      immHdNavConn = remoteConfig.getBool('immediate_bool_connect');


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    immBnApiConn();
  }

  Future<void> immBnApiConn() async {
    setState(() {
      imLdFvConn = true;
    });
    final SharedPreferences prefs = await _imSpfDhConn;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurFavConn = currencyName;
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=$imCurFavConn';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        imBnLstConn.addAll(
            data['data'].map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json)).toList());
        imLdFvConn = false;
      });
    }
  }

  List<charts.Series<LinearSales, int>> _imCtSmDtConn(
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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await _imSpfDhConn;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurFavConn = currencyName;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: getColorFromHex("#FAFAFA"),
        body: imLdGpFvConn
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: height / 5,
                decoration: BoxDecoration(
                  color: getColorFromHex("#E9EDF6"),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          ImmAppLocalCon.of(context)!
                              .translate('total_portfolio')!,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: getColorFromHex("#868990"),
                                  fontSize: 16)),
                        )),
                    const SizedBox(height: 10),
                    imCurFavConn == "USD"
                        ? Text(
                      '\$${totalValuesOfPortfolio.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                              color: getColorFromHex("#1264FF"))),
                      textAlign: TextAlign.left,
                    )
                        : imCurFavConn == "INR"
                        ? Text(
                      '₹${totalValuesOfPortfolio.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                              color:
                              getColorFromHex("#1264FF"))),
                      textAlign: TextAlign.left,
                    )
                        : imCurFavConn == "EUR"
                        ? Text(
                      '€${totalValuesOfPortfolio.toStringAsFixed(2)}',
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
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!
                          .translate('Favorites')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16)),
                    )),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 11,
                  alignment: Alignment.centerLeft,
                  child: imItmWshConn.length > 0
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ImmCoinSheetUpConn()));
                        },
                        child: Container(
                          margin:
                          const EdgeInsets.only(left: 20, right: 10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: getColorFromHex("#1264FF"),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imItmWshConn.length,
                          itemBuilder:
                              (BuildContext context, int i) {
                            return Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.only(right: 10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    'assets/images/cob.png'),
                                image: NetworkImage(
                                    "https://assets.coinlayer.com/icons/${imItmWshConn[i].symbol}.png"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                      : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ImmCoinSheetUpConn()));
                    },
                    child: Row(
                      children: [
                        Container(
                          margin:
                          const EdgeInsets.only(left: 20, right: 10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: getColorFromHex("#1264FF"),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          ImmAppLocalCon.of(context)!
                              .translate('Favorities_coin_add')!,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16)),
                        )
                      ],
                    ),
                  )),
              Padding(
                padding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!
                          .translate('Favorities_List')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16)),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: imItmWshConn.length > 0
                    ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: imItmWshConn.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        width: double.infinity,
                        height:
                        MediaQuery.of(context).size.height / 4.2,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: 35,
                                      width: 35,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/images/cob.png'),
                                          image: NetworkImage(
                                              "https://assets.coinlayer.com/icons/${imItmWshConn[i].symbol}.png"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      imItmWshConn[i].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontWeight:
                                              FontWeight.w500,
                                              fontSize: 18,
                                              color: Colors.black)),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        _immShwDelFavDialConn(
                                            imItmWshConn[i]);
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                getColorFromHex(
                                                    "#D9E1E7")),
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            color: Colors.white),
                                        child: Center(
                                          child: Text(
                                            ImmAppLocalCon.of(
                                                context)!
                                                .translate('Delete')!,
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color:
                                                    getColorFromHex(
                                                        "#1264FF"),
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: imCurFavConn == "USD"
                                          ? Text(
                                        '\$${double.parse(imItmWshConn[i].rateDuringAdding.toStringAsFixed(2))}',
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                        style:
                                        GoogleFonts.roboto(
                                            textStyle:
                                            const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w400,
                                            )),
                                      )
                                          : imCurFavConn == "INR"
                                          ? Text(
                                        '₹${double.parse(imItmWshConn[i].rateDuringAdding.toStringAsFixed(2))}',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: GoogleFonts
                                            .roboto(
                                            textStyle:
                                            const TextStyle(
                                              fontSize: 22,
                                              color:
                                              Colors.black,
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                            )),
                                      )
                                          : imCurFavConn == "EUR"
                                          ? Text(
                                        '€${double.parse(imItmWshConn[i].rateDuringAdding.toStringAsFixed(2))}',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: GoogleFonts
                                            .roboto(
                                            textStyle:
                                            const TextStyle(
                                              fontSize: 22,
                                              color: Colors
                                                  .black,
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                            )),
                                      )
                                          : const Text(""),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      imItmWshConn[i].symbol,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: getColorFromHex(
                                                "#809FB8"),
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    double.parse(imItmWshConn[i].diffRate) <
                                        0
                                        ? Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(10),
                                          color:
                                          getColorFromHex(
                                              "#FF775C")
                                              .withOpacity(
                                              0.1)),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          const Icon(
                                            Icons.trending_down,
                                            color: Colors.red,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${double.parse(imItmWshConn[i].diffRate.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
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
                                                      .w400,
                                                  color:
                                                  getColorFromHex(
                                                      "#595959"),
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(10),
                                          color:
                                          getColorFromHex(
                                              "#1AD598")
                                              .withOpacity(
                                              0.1)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center,
                                        children: [
                                          const Icon(
                                            Icons.trending_up,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${double.parse(imItmWshConn[i].diffRate.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
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
                                                      .w400,
                                                  color:
                                                  getColorFromHex(
                                                      "#1AD598"),
                                                )),
                                            textAlign:
                                            TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            3.5,
                                        height: 60,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: imLdFvConn == true
                                            ? Center(
                                            child: SizedBox(
                                                height: 10,
                                                child:
                                                ImmLoadBitCon()))
                                            : charts.LineChart(
                                          _imCtSmDtConn(
                                              imBnLstConn[i]
                                                  .historyRate,
                                              double.parse(
                                                  imBnLstConn[i]
                                                      .diffRate!)),
                                          layoutConfig: charts
                                              .LayoutConfig(
                                              leftMarginSpec:
                                              charts
                                                  .MarginSpec.fixedPixel(
                                                  5),
                                              topMarginSpec:
                                              charts
                                                  .MarginSpec.fixedPixel(
                                                  10),
                                              rightMarginSpec:
                                              charts
                                                  .MarginSpec.fixedPixel(
                                                  5),
                                              bottomMarginSpec:
                                              charts
                                                  .MarginSpec.fixedPixel(
                                                  10)),
                                          defaultRenderer:
                                          charts
                                              .LineRendererConfig(
                                            includeArea: true,
                                            stacked: true,
                                          ),
                                          animate: true,
                                          domainAxis: const charts
                                              .NumericAxisSpec(
                                              showAxisLine:
                                              false,
                                              renderSpec: charts
                                                  .NoneRenderSpec()),
                                          primaryMeasureAxis: const charts
                                              .NumericAxisSpec(
                                              renderSpec: charts
                                                  .NoneRenderSpec()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
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
                    )),
              )
            ],
          ),
        ));
  }

  void _immShwDelFavDialConn(ImmFavDataCon item) {
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
                      Column(
                        children: [
                          imCurFavConn == "USD"
                              ? SizedBox(
                            width: 180,
                            child: Text(
                              "\$${item.rateDuringAdding.toStringAsFixed(2)}",
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
                              : imCurFavConn == "INR"
                              ? SizedBox(
                            width: 180,
                            child: Text(
                              "₹${item.rateDuringAdding.toStringAsFixed(2)}",
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
                              : imCurFavConn == "EUR"
                              ? SizedBox(
                            width: 180,
                            child: Text(
                              "€${item.rateDuringAdding.toStringAsFixed(2)}",
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
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Spacer(),
                Stack(children: [
                  Image.asset("assets/images/Rectangle.png"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 110),
                    child: InkWell(
                      onTap: () {
                        _imDelFavConFroLolStConn(item);
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

  _imDelFavConFroLolStConn(ImmFavDataCon itemsW) async {
    setState(() async {
      final id = await imDbFavConn.delete(itemsW.name.toString());
      print('inserted row id: $id');

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setInt("index", immHdNavConn?4:3);
        // sharedPreferences!.setBool("imHdCon", immHdNavConn);
        sharedPreferences!.setString("title",
            ImmAppLocalCon.of(context)!.translate('Dashboard').toString());
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/NavigationPage', (r) => false);

      Fluttertoast.showToast(
          msg: "${itemsW.name} is Delete from Favorites list",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
