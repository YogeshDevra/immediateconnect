// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, sort_child_properties_last, use_build_context_synchronously, depend_on_referenced_packages, file_names, library_private_types_in_public_api, prefer_final_fields, prefer_typing_uninitialized_variables, sized_box_for_whitespace, avoid_print, prefer_is_empty, avoid_function_literals_in_foreach_calls, await_only_futures

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../ImmAnalyisConn.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmCryptListCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmCandleChartCon.dart';

class ImmDriftScnCon extends StatefulWidget {
  const ImmDriftScnCon({Key? key}) : super(key: key);

  @override
  _ImmDriftScnCon createState() => _ImmDriftScnCon();
}

class _ImmDriftScnCon extends State<ImmDriftScnCon> {

  bool imCndDftConn = false;
  bool imLoadDftConn = false;
  bool imChtChgDftConn = false;
  int imButTypDftConn = 3;
  double imCnDftConn = 0;
  String imRtDftConn = '';
  double imChgPctDftConn = 0;
  ZoomPanBehavior? _zoomPanBehavior;
  TrackballBehavior? _immTrkAraDftConn;
  TrackballBehavior? _immTrkCndDftConn;

  Future<SharedPreferences> _imSpfDftConn = SharedPreferences.getInstance();
  String? imCurrNmImgDftConn;
  String _imTypDftConn = "4Day";
  List<ImLnSlDftConn> imCurDtDftConn = [];
  List<ImCndSlConn> imDftCndConn = [];
  List<ImmBitCoinCon> imBnLtDftConn = [];
  List<ImmCryptListCon> imBnDtDftConn = [];
  ImmCryptListCon? bList;
  double imDfrtDftConn = 0.0;
  String? immDhConn;
  var imCurNmDftConn;
  String? imCurNmTrdConn;
  String? imCurrDftConn;
  double imHghDftConn = 0;
  double imLowDftConn = 0;
  double imCapDftConn = 0;
  double imVolDftConn = 0;
  SharedPreferences? imShdPrfDftConn;


  @override
  void initState() {
    setState(() {
      imLoadDftConn = true;
    });
    ImmAnalyisConn.setCurrentScreen(ImmAnalyisConn.ImmTrd_Conn, "ImmediateTrendPage");
    immLinkValConn();

    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enablePanning: true,
    );

    _immTrkAraDftConn = TrackballBehavior(
        enable: true,
        lineColor: getColorFromHex("#5EF865"),
        lineDashArray: const <double>[5, 5],
        lineWidth: 2,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
        shouldAlwaysShow: true,

        tooltipSettings: const InteractiveTooltip(
            arrowLength: 0,
            arrowWidth: 0,
            canShowMarker: true,
            color: Colors.transparent,
            enable: true
        ),

        tooltipAlignment: ChartAlignment.near,
        builder: (context, TrackballDetails trackballDetails) {
          //  setCoin(trackballDetails.point!.y);
          return SizedBox(
            height: 40,
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

    _immTrkCndDftConn = TrackballBehavior(
      enable: true,
      lineColor: getColorFromHex("#5EF865"),
      lineDashArray: const <double>[5, 5],
      lineWidth: 2,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      tooltipSettings: const InteractiveTooltip(
          arrowLength: 0,
          arrowWidth: 0,
          canShowMarker: true,
          color: Colors.transparent,
          enable: true
      ),
        builder: (context, TrackballDetails trackballDetails){
          return SizedBox(
            height: 90,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text("open:${trackballDetails.point!.open.toString()}\nclose:${trackballDetails.point!.close.toString()}\nhigh:${trackballDetails.point!.high.toString()}\nlow:${trackballDetails.point!.low.toString()}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    "date:${trackballDetails.point!.x.toString()}",
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          );
        }
    );

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
    imGtNmConn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getColorFromHex("#FAFAFA"),
        body: imLoadDftConn == true
            ? Center(child: SizedBox(height: 10, child: ImmLoadBitCon()))
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(2),
                            child:  SizedBox(
                                width: MediaQuery.of(context).size.width/3,
                                child: DropdownButtonFormField(
                                  dropdownColor: Colors.white,
                                  value:bList,
                                  items: imBnDtDftConn.map((e){
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 30,
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child:
                                                FadeInImage(
                                                  placeholder: const AssetImage('assets/images/cob.png'),
                                                  // image: NetworkImage("$ipValue/Bitcoin/resources/icons/${currencyNameForImage.toString().toLowerCase()}.png"),
                                                  image: NetworkImage("https://assets.coinlayer.com/icons/${e.sysmbol}.png"),
                                                ),
                                              )
                                          ),
                                          Text(
                                            e.sysmbol!,
                                            style: GoogleFonts.manrope(
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black)),
                                          ),
                                          // Spacer(),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  onChanged: (dynamic c){
                                    setState(()   {
                                      bList = c!;
                                      imCurNmDftConn = bList?.sysmbol;
                                      imCurNmTrdConn = imCurNmDftConn;
                                    });
                                    immBnApiDtConn();
                                  },
                                )
                            )
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () async {
                              imShdPrfDftConn =
                              await SharedPreferences.getInstance();
                              imShdPrfDftConn!
                                  .setBool("chartchange", imChtChgDftConn);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImCandleChtConn(imCurTrdConn: '$imCurNmDftConn')
                                  )
                              );
                            },
                            child: const Icon(Icons.zoom_out_map)),
                        const SizedBox(width: 20),
                        imChtChgDftConn == false
                            ? InkWell(
                            onTap: () async {
                              setState(() {
                                imChtChgDftConn == false
                                    ? imChtChgDftConn = true
                                    : imChtChgDftConn = false;
                              });
                            },
                            child: Image.asset(
                                "assets/images/Group 10.png"))
                            : InkWell(
                            onTap: () async {
                              setState(() {
                                imChtChgDftConn == false
                                    ? imChtChgDftConn = true
                                    : imChtChgDftConn = false;
                              });
                            },
                            child: Image.asset(
                                "assets/images/Group 12.png")),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imCurrDftConn == "USD"
                                ? SizedBox(
                              width: 130,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                "\$${imCnDftConn.toStringAsFixed(2)}",
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    )),
                              ),
                            )
                                : imCurrDftConn == "INR"
                                ? SizedBox(
                              width: 130,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                "₹${imCnDftConn.toStringAsFixed(2)}",
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    )),
                              ),
                            )
                                : imCurrDftConn == "EUR"
                                ? SizedBox(
                              width: 130,
                              child: Text(
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                "€${imCnDftConn.toStringAsFixed(2)}",
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 19,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.black,
                                    )),
                              ),
                            )
                                : const Text(""),
                            imDfrtDftConn >= 0
                                ? Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: getColorFromHex("#00BB07"),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "$imRtDftConn%",
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: getColorFromHex(
                                              "#00BB07"),
                                        )),
                                  ),
                                )
                              ],
                            )
                                : Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: getColorFromHex("#EA3A3D"),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "$imRtDftConn%",
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: getColorFromHex(
                                              "#EA3A3D"),
                                        )),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              ImmAppLocalCon.of(context)!
                                  .translate('High_Price')!,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14)),
                            ),
                            const SizedBox(height: 10),
                            imCurrDftConn == "USD"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "\$${imHghDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : imCurrDftConn == "INR"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "₹${imHghDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : imCurrDftConn == "EUR"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "€${imHghDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : const Text(""),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              ImmAppLocalCon.of(context)!
                                  .translate('Low_Price')!,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14)),
                            ),
                            const SizedBox(height: 10),
                            imCurrDftConn == "USD"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "\$${imLowDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : imCurrDftConn == "INR"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "₹${imLowDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : imCurrDftConn == "EUR"
                                ? SizedBox(
                              width: 60,
                              child: Text(
                                "€${imLowDftConn.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                            )
                                : const Text(""),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                        color:
                        getColorFromHex("#1264FF").withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Column(
                      children: [
                        imChtChgDftConn == false
                            ? Container(
                          width:
                          MediaQuery.of(context).size.width / 1,
                          height:
                          MediaQuery.of(context).size.height /
                              3,
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            trackballBehavior: _immTrkAraDftConn,
                            enableAxisAnimation: true,
                            zoomPanBehavior: _zoomPanBehavior,
                            enableSideBySideSeriesPlacement: true,

                            series: <ChartSeries<ImLnSlDftConn,
                                String>>[
                              AreaSeries<ImLnSlDftConn, String>(
                                enableTooltip: true,
                                dataSource: imCurDtDftConn,
                                xValueMapper:
                                    (ImLnSlDftConn data, _) =>
                                data.date,
                                yValueMapper:
                                    (ImLnSlDftConn data, _) =>
                                data.rate,
                                color: getColorFromHex("#5EF865"),
                                borderColor:
                                getColorFromHex("#5EF865"),
                                borderWidth: 2,
                                dataLabelMapper: (data, __) =>
                                '${data.date} \n ${data.rate}',
                                dataLabelSettings:
                                DataLabelSettings(
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
                            ),
                            primaryYAxis: NumericAxis(
                              interactiveTooltip: const InteractiveTooltip(
                                  enable: true),
                              isVisible: true,
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                            : Container(
                          width: double.infinity,

                          height:
                          MediaQuery.of(context).size.height /
                              3,
                          child: imCndDftConn == true
                              ? SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            enableAxisAnimation: true,
                            zoomPanBehavior: _zoomPanBehavior,
                            trackballBehavior:
                            _immTrkCndDftConn,
                            enableSideBySideSeriesPlacement:
                            true,
                            series: <ChartSeries<ImCndSlConn,
                                String>>[
                              CandleSeries<ImCndSlConn,
                                  String>(
                                dataSource: imDftCndConn,
                                xValueMapper:
                                    (ImCndSlConn data, _) =>
                                data.date,
                                lowValueMapper:
                                    (ImCndSlConn data, _) =>
                                data.low,
                                highValueMapper:
                                    (ImCndSlConn data, _) =>
                                data.high,
                                openValueMapper:
                                    (ImCndSlConn data, _) =>
                                data.open,
                                closeValueMapper:
                                    (ImCndSlConn data, _) =>
                                data.close,
                                dataLabelMapper: (data, __) =>
                                '${data.date} \n ${data.close}',
                                enableSolidCandles: true,
                                dataLabelSettings:
                                const DataLabelSettings(
                                    isVisible: false,
                                    borderColor:
                                    Colors.white),
                              )
                            ],
                            primaryXAxis: CategoryAxis(
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w400),
                              isVisible: true,
                            ),
                            primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w400),
                                majorGridLines:
                                const MajorGridLines(width: 0),
                                isVisible: true, rangePadding: ChartRangePadding.round
                            ),
                          )
                              : const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                width: 45.0,
                                height: 40.0,
                                child: TextButton(
                                  child: Text("4D",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'roboto',
                                          fontWeight: FontWeight.w600,
                                          color: imButTypDftConn == 3
                                              ? getColorFromHex("#1264FF")
                                              : Colors.black),
                                      softWrap: false),
                                  style: ButtonStyle(shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 3;
                                      _imTypDftConn = "4Day";
                                      immBnApiDtConn();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                width: 45.0,
                                height: 40.0,
                                child: TextButton(
                                  child: Text(
                                    "7D",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.w600,
                                        color: imButTypDftConn == 4
                                            ? getColorFromHex("#1264FF")
                                            : Colors.black),
                                    softWrap: false,
                                  ),
                                  style: ButtonStyle( shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 4;
                                      _imTypDftConn = "Week";
                                      immBnApiDtConn();
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
                                    "15D",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.w600,
                                        color: imButTypDftConn == 5
                                            ? getColorFromHex("#1264FF")
                                            : Colors.black),
                                    softWrap: false,
                                  ),
                                  style: ButtonStyle(shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 5;
                                      _imTypDftConn = "15Day";
                                      immBnApiDtConn();
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
                                        color: imButTypDftConn == 6
                                            ? getColorFromHex("#1264FF")
                                            : Colors.black),
                                    softWrap: false,
                                  ),
                                  style: ButtonStyle(shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 6;
                                      _imTypDftConn = "Month";
                                      immBnApiDtConn();
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
                                        color: imButTypDftConn == 7
                                            ? getColorFromHex("#1264FF")
                                            : Colors.black),
                                    softWrap: false,
                                  ),
                                  style: ButtonStyle(shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 7;
                                      _imTypDftConn = "2Month";
                                      immBnApiDtConn();
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
                                        color: imButTypDftConn == 8
                                            ? getColorFromHex("#1264FF")
                                            : Colors.black),
                                    softWrap: false,
                                  ),
                                  style: ButtonStyle(shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ))),
                                  onPressed: () {
                                    setState(() {
                                      imButTypDftConn = 8;
                                      _imTypDftConn = "Year";
                                      immBnApiDtConn();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 15,
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: getColorFromHex("#ECECEC").withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      ImmAppLocalCon.of(context)!
                          .translate('Market_Cap')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14)),
                    ),
                    const Spacer(),
                    imCurrDftConn == "USD"
                        ? Text(
                      "\$${imCapDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : imCurrDftConn == "INR"
                        ? Text(
                      "₹${imCapDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : imCurrDftConn == "EUR"
                        ? Text(
                      "€${imCapDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : const Text(""),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 15,
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  // color: getColorFromHex("#ECECEC").withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      ImmAppLocalCon.of(context)!
                          .translate('Volume_24hr')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14)),
                    ),
                    const Spacer(),
                    imCurrDftConn == "USD"
                        ? Text(
                      "\$${imVolDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : imCurrDftConn == "INR"
                        ? Text(
                      "₹${imVolDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : imCurrDftConn == "EUR"
                        ? Text(
                      "€${imVolDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 14)),
                    )
                        : const Text(""),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 15,
                margin: const EdgeInsets.only(left: 15, right: 15),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  // color: getColorFromHex("#ECECEC").withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      ImmAppLocalCon.of(context)!
                          .translate('%_Change_24hr')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14)),
                    ),
                    const Spacer(),
                    Text(
                      "%${imChgPctDftConn.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: imChgPctDftConn >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }

  Future<void> imValDropConn() async {

    var uri = '$immDhConn/Bitcoin/resources/getAllCrypto?flag=Active';
    var response = await get(Uri.parse(uri));
    print(response.body);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        imBnDtDftConn.addAll(data['data']
            .map<ImmCryptListCon>((json) => ImmCryptListCon.fromJson(json))
            .toList());
        bList =  imBnDtDftConn.firstWhereOrNull((element) => element.sysmbol == imCurNmDftConn);

      });
    } else {
      setState(() {});
    }
  }

  Future<void> imGtNmConn() async {
    final SharedPreferences prefs = await _imSpfDftConn;
    imCurNmDftConn = prefs.getString("currencyName") ?? 'BTC';
    var currencyExchange = prefs.getString("currencyExchange") ?? 'USD';
    setState(() {
      imCurrDftConn = currencyExchange;
      imCurrNmImgDftConn = imCurNmDftConn;
    });
    imValDropConn();
    immBnApiDtConn();
  }

  Future<void> immBnApiDtConn() async {
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoGraph?type=$_imTypDftConn&name=$imCurNmDftConn&currency=$imCurrDftConn';
    print(uri);
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        imBnLtDftConn = data['data']
            .map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json))
            .toList();
        double count = 0;
        imDfrtDftConn = double.parse(data['diffRate']);
        if (imDfrtDftConn < 0) {
          imRtDftConn = data['diffRate'].replaceAll("-", "");
        } else {
          imRtDftConn = data['diffRate'];
        }
        imCurDtDftConn = [];
        imDftCndConn = [];

        List<ImmBitCoinCon> templ = [];
        templ.addAll(imBnLtDftConn.where((element) => element.open != null));
        print("templ.length : ${templ.length}");

        imBnLtDftConn.forEach((element) {
          imCurDtDftConn.add(ImLnSlDftConn(
              element.date!, double.parse(element.rate!.toStringAsFixed(2))));

          if (templ.length > 0) {
            if (element.open != null && element.close != null) {
              imDftCndConn.add(ImCndSlConn(
                  element.date!.toString(),
                  double.parse(element.high!.toStringAsFixed(2)),
                  double.parse(element.low!.toStringAsFixed(2)),
                  double.parse(element.open!.toStringAsFixed(2)),
                  double.parse(element.close!.toStringAsFixed(2))));
              imCndDftConn = true;
            }
          } else {
            imCndDftConn = false;
          }
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          imCnDftConn = step3;
          count = count + 1;
        });

        imHghDftConn = imBnLtDftConn.last.high!;
        imLowDftConn = imBnLtDftConn.last.low!;
        imCapDftConn = imBnLtDftConn.last.cap!;
        imVolDftConn = imBnLtDftConn.last.volume!;
        imChgPctDftConn = imBnLtDftConn.last.changepct!;
      });

      imLoadDftConn = false;
    } else {
    }
  }

}

class ImLnSlDftConn {
  final String date;
  final double rate;

  ImLnSlDftConn(this.date, this.rate);
}

class ImCndSlConn {
  final String date;
  final double low;
  final double high;
  final double open;
  final double close;

  ImCndSlConn(
      this.date,
      this.low,
      this.high,
      this.open,
      this.close,
      );
}
