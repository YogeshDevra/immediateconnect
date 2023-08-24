// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, library_private_types_in_public_api, prefer_final_fields, non_constant_identifier_names, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, avoid_function_literals_in_foreach_calls, prefer_is_empty, file_names, await_only_futures, use_key_in_widget_constructors

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../ImmLoadCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';



class ImCandleChtConn extends StatefulWidget {
  final String imCurTrdConn;
  const ImCandleChtConn({required this.imCurTrdConn});

  @override
  _ImCandleChtConn createState() => _ImCandleChtConn();
}

class _ImCandleChtConn extends State<ImCandleChtConn> {


  bool immLoadChtCon = false;
  int immCndButtConn = 5;
  int immAraButtConn = 5;
  String imNmChtConn = "";
  double imRtChtConn = 0.0;
  double imCnChtConn = 0;
  String imRstChtConn = '';
  TrackballBehavior? _trackballBehavior;
  ZoomPanBehavior? _zoomPanBehavior;
  List<Candle> imCndChtConn = [];

  Future<SharedPreferences> _imSpfChtConn = SharedPreferences.getInstance();
  String _imTypConn = "15Day";
  List<ImmBitCoinCon> imBtLtChtConn = [];
  double imDfRtChtConn = 0.0;
  String? immDhConn;

  String? imCurrChtConn;
  bool? imChtNmChtConn;
  List<ImLnSlChtCon> imCurDtChtConn = [];
  SharedPreferences? imShdPrfChtConn;

  @override
  void initState() {
    setState(() {
      immLoadChtCon = true;
    });
    immLinkValConn();
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enablePanning: true,
    );

    _trackballBehavior = TrackballBehavior(
        enable: true,
        lineColor: getColorFromHex("#5EF865"),
        lineDashArray: const <double>[5, 5],
        lineWidth: 2,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
        shouldAlwaysShow: true,
        tooltipSettings: InteractiveTooltip(
            arrowLength: 0,
            arrowWidth: 0,
            canShowMarker: true,
            color: getColorFromHex("#5EF865"),
            enable: true),
        tooltipAlignment: ChartAlignment.near,
        builder: (context, TrackballDetails trackballDetails) {
          return SizedBox(
            height: 50,
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      "${trackballDetails.point?.y.toString()}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      "${trackballDetails.point?.x.toString()}",
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                )),
          );
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


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    ImCllChtConn();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await _imSpfChtConn;
    var chartData = prefs.getBool("chartchange");
    imChtNmChtConn = chartData!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: getColorFromHex("#FAFAFA"),
          // centerTitle: true,
          title: Text(
            imNmChtConn,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ),
          leading: InkWell(
            child: Container(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 35,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imCurrChtConn == "USD"
                      ? SizedBox(
                    // width: 150,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "\$${imCnChtConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),
                  )
                      : imCurrChtConn == "INR"
                      ? SizedBox(
                    // width: 150,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "₹${imCnChtConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),
                  )
                      : imCurrChtConn == "EUR"
                      ? SizedBox(
                    // width: 150,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "€${imCnChtConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),
                  )
                      : const Text(""),
                  imDfRtChtConn >= 0
                      ? immLoadChtCon == true
                      ? Center(
                      child:
                      SizedBox(height: 10, child: ImmLoadBitCon()))
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_drop_up,
                        color: getColorFromHex("#00BB07"),
                      ),
                      SizedBox(
                        // width: 50,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "${double.parse(imRstChtConn).toStringAsFixed(2)}%",
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#00BB07"),
                              )),
                        ),
                      )
                    ],
                  )
                      : immLoadChtCon == true
                      ? Center(
                      child:
                      SizedBox(height: 10, child: ImmLoadBitCon()))
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_drop_down,
                        color: getColorFromHex("#EA3A3D"),
                      ),
                      SizedBox(
                        // width: 50,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "${double.parse(imRstChtConn).toStringAsFixed(2)}%",
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: getColorFromHex("#EA3A3D"),
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
        imChtNmChtConn == false ? bottomNavigationBar : const Text(""),
        backgroundColor: getColorFromHex("#FAFAFA"),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: imChtNmChtConn == true
                          ? Candlesticks(
                        candles: imCndChtConn,
                        actions: [
                          ToolBarAction(
                              child: Text(
                                "15D",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w600,
                                    color: immCndButtConn == 5
                                        ? getColorFromHex("#1264FF")
                                        : Colors.black),
                                softWrap: false,
                              ),
                              onPressed: () {
                                setState(() {
                                  immCndButtConn = 5;
                                  _imTypConn = "15Day";
                                });
                                ImCllChtConn();
                              }),
                          ToolBarAction(
                              child: Text(
                                "1M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w600,
                                    color: immCndButtConn == 6
                                        ? getColorFromHex("#1264FF")
                                        : Colors.black),
                                softWrap: false,
                              ),
                              onPressed: () {
                                setState(() {
                                  immCndButtConn = 6;
                                  _imTypConn = "Month";
                                  ImCllChtConn();
                                });
                              }),
                          ToolBarAction(
                              child: Text(
                                "2M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w600,
                                    color: immCndButtConn == 7
                                        ? getColorFromHex("#1264FF")
                                        : Colors.black),
                                softWrap: false,
                              ),
                              onPressed: () {
                                setState(() {
                                  immCndButtConn = 7;
                                  _imTypConn = "2Month";
                                  ImCllChtConn();
                                });
                              }),
                          ToolBarAction(
                              child: Text(
                                "1Y",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w600,
                                    color: immCndButtConn == 8
                                        ? getColorFromHex("#1264FF")
                                        : Colors.black),
                                softWrap: false,
                              ),
                              onPressed: () {
                                setState(() {
                                  immCndButtConn = 8;
                                  _imTypConn = "Year";
                                  ImCllChtConn();
                                });
                              }),
                        ],
                      )
                          : SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        trackballBehavior: _trackballBehavior,
                        enableAxisAnimation: true,
                        zoomPanBehavior: _zoomPanBehavior,
                        enableSideBySideSeriesPlacement: true,

                        series: <ChartSeries>[
                          AreaSeries<ImLnSlChtCon, String>(
                            enableTooltip: true,
                            dataSource: imCurDtChtConn,
                            xValueMapper: (ImLnSlChtCon data, _) =>
                            data.date,
                            yValueMapper: (ImLnSlChtCon data, _) =>
                            data.rate,
                            color: getColorFromHex("#5EF865"),
                            borderColor: getColorFromHex("#5EF865"),
                            borderWidth: 2,
                            dataLabelMapper: (data, __) =>
                            '${data.date} \n ${data.rate}',
                            dataLabelSettings: DataLabelSettings(
                              isVisible: false,
                              color: getColorFromHex("#5EF865"),
                            ),
                            markerSettings: MarkerSettings(
                              isVisible: false,
                              color: getColorFromHex("#E5692C"),
                              height: 11,
                              width: 11,
                              borderWidth: 3,
                              borderColor: Colors.transparent,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                getColorFromHex("#1264FF"),
                                getColorFromHex("#1264FF")
                                    .withOpacity(.5),
                                getColorFromHex("#1264FF")
                                    .withOpacity(0.1),
                              ],
                            ),
                          ),
                        ],
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                          labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          // labelRotation: 90,
                        ),
                        primaryYAxis: NumericAxis(
                          interactiveTooltip: const InteractiveTooltip(enable: true),
                          isVisible: true,
                          labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }

  DateTime imAlLDtChtCon = DateTime.now();

  Future<void> ImCllChtConn() async {

    final SharedPreferences prefs = await _imSpfChtConn;
    var currencyExchange = prefs.getString("currencyExchange") ?? 'USD';
    imCurrChtConn = currencyExchange;

    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoGraph?type=$_imTypConn&name=${widget.imCurTrdConn}&currency=$imCurrChtConn';
    print(uri);
    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        imBtLtChtConn = data['data']
            .map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json))
            .toList();
        double count = 0;
        imDfRtChtConn = double.parse(data['diffRate']);
        if (imDfRtChtConn < 0) {
          imRstChtConn = data['diffRate'].replaceAll("-", "");
        } else {
          imRstChtConn = data['diffRate'];
        }
        imCurDtChtConn = [];
        imCndChtConn = [];

        List<ImmBitCoinCon> templ = [];
        templ.addAll(imBtLtChtConn.where((element) => element.open != null));
        print("templ.length : ${templ.length}");

        imBtLtChtConn.forEach((element) {
          imCurDtChtConn.add(ImLnSlChtCon(
              element.date!, double.parse(element.rate!.toStringAsFixed(2))));
          String formattedDate = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(element.date!.toString()));
          if (templ.length > 0) {
            if (element.open != null && element.close != null) {
              imCndChtConn.add(Candle(
                  date: imAlLDtChtCon,
                  high: double.parse(element.high!.toStringAsFixed(2)),
                  low: double.parse(element.low!.toStringAsFixed(2)),
                  open: double.parse(element.open!.toStringAsFixed(2)),
                  close: double.parse(element.close!.toStringAsFixed(2)),
                  volume: double.parse(element.volume!.toStringAsFixed(2))));
            }
          } else {
          }
          imNmChtConn = element.name!;
          imAlLDtChtCon = DateTime.parse(formattedDate);
          imRtChtConn = double.parse(element.rate!.toStringAsFixed(2));
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          imCnChtConn = step3;
          count = count + 1;
        });
      });

      setState(() {
        immLoadChtCon = false;
      });
    } else {
    }
  }

  Widget get bottomNavigationBar {
    return Container(
      decoration: BoxDecoration(
        color: getColorFromHex("#1264FF").withOpacity(0.2),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 50.0, height: 40.0,
              // minWidth: 30.0, height: 40.0,
              child: TextButton(
                child: Text(
                  "15D",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600,
                      color: immAraButtConn == 5
                          ? getColorFromHex("#1264FF")
                          : Colors.black),
                  softWrap: false,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  setState(() {
                    immAraButtConn = 5;
                    _imTypConn = "15Day";
                    ImCllChtConn();
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 50.0, height: 40.0,
              // minWidth: 30.0, height: 40.0,
              child: TextButton(
                child: Text(
                  "1M",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600,
                      color: immAraButtConn == 6
                          ? getColorFromHex("#1264FF")
                          : Colors.black),
                  softWrap: false,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  setState(() {
                    immAraButtConn = 6;
                    _imTypConn = "Month";
                    ImCllChtConn();
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 50.0, height: 40.0,
              // minWidth: 30.0, height: 40.0,
              child: TextButton(
                child: Text(
                  "2M",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600,
                      color: immAraButtConn == 7
                          ? getColorFromHex("#1264FF")
                          : Colors.black),
                  softWrap: false,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  setState(() {
                    immAraButtConn = 7;
                    _imTypConn = "2Month";
                    ImCllChtConn();
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: 50.0, height: 40.0,
              // minWidth: 30.0, height: 40.0,
              child: TextButton(
                child: Text(
                  "1Y",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600,
                      color: immAraButtConn == 8
                          ? getColorFromHex("#1264FF")
                          : Colors.black),
                  softWrap: false,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                onPressed: () {
                  setState(() {
                    immAraButtConn = 8;
                    _imTypConn = "Year";
                    ImCllChtConn();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class ImLnSlChtCon {
  final String date;
  final double rate;

  ImLnSlChtCon(this.date, this.rate);

}