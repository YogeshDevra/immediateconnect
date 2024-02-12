// ignore_for_file: deprecated_member_use, file_names, depend_on_referenced_packages, library_private_types_in_public_api, non_constant_identifier_names, unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/ApiConfigConnect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'HomePage.dart';
import 'models/Bitcoin.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  List<Bitcoin> bitcoinDataList = [];
  double diffRate = 0;
  List<CartData> currencyData = [];
  String name = "";
  double coin = 0;
  String result = '';
  int graphButton = 1;
  String _type = 'Week';
  bool isLoading = false;
  String fullName = '';
  late TrackballBehavior trackballBehavior;
  late CrosshairBehavior crossHairBehavior;
  late TooltipBehavior _tooltipBehavior;
  ZoomPanBehavior? _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    callGraphApi();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Trends',
          style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading ?
        const Center(child: CircularProgressIndicator(color: Color(0xffd76614)))
            : Column(
          children: [
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffBDCADB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage(
                              width: 50, height: 50,
                              placeholder: const AssetImage('assets/image/cob.png'),
                              image: NetworkImage("${ApiConfigConnect.apiUrl}/Bitcoin/resources/icons/${name.toLowerCase()}.png"),
                            ),
                          ),
                        ),
                        const SizedBox(width:3),
                        Text('$fullName ',
                            style:GoogleFonts.openSans(textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.5,
                                fontWeight: FontWeight.w600),
                            )
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            diffRate >= 0 ?
                            const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                : const Icon(
                              Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                            ),
                            Text(diffRate.toStringAsFixed(2),
                                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                    color: diffRate >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F))),
                          ],
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            width: MediaQuery.of(context).size.width/3.5,
                            child: Text("\$${coin.toStringAsFixed(2)}",
                                style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                    fontSize: 20,color: Color(0xffffffff)
                                )
                            )
                        ),
                      ],
                    ),
                    ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                        onTap: () {
                          // Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/heart-unfill.svg',
                            height: 20,
                            width: 20,
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child:SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  //   height :MediaQuery.of(context).size.height,
                  //     width: MediaQuery.of(context).size.width,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    enableSideBySideSeriesPlacement: true,
                    zoomPanBehavior: _zoomPanBehavior = ZoomPanBehavior(
                      // Enables pinch zooming
                      enablePinching: true,
                      zoomMode: ZoomMode.xy,
                      enablePanning: false,
                    ),
                    enableAxisAnimation: true,
                    trackballBehavior:trackballBehavior = TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      lineDashArray: const <double>[5,5],
                      lineColor: const Color(0xff7B39FB),
                      lineWidth: 2,
                      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
                      shouldAlwaysShow: true,
                      tooltipAlignment: ChartAlignment.near,
                      builder: (BuildContext context, TrackballDetails trackballDetails) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff7B39FB),
                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${trackballDetails.point!.x.toString()} \n\$${trackballDetails.point!.y.toString()}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(255, 255, 255, 1)
                                )
                            ),
                          ),
                        );
                      },
                    ),
                    //Enables the tooltip for all the series
                    tooltipBehavior: _tooltipBehavior = TooltipBehavior(
                      enable: true,
                    ),
                    series: <ChartSeries>[
                      // Renders spline chart
                      LineSeries<CartData, String>(
                        dataSource: currencyData,
                        xValueMapper: (CartData data, _) => data.date,
                        yValueMapper: (CartData data, _) => data.rate,
                        color: const Color(0xff7B39FB),
                        // splineType: SplineType.monotonic,
                        //cardinalSplineTension: 10,
                        dataLabelSettings: const DataLabelSettings(
                          // Renders the data label
                          //   isVisible: true,
                            useSeriesColor: true,
                            // labelAlignment: ChartDataLabelAlignment.bottom,
                            showCumulativeValues: true,
                            textStyle: TextStyle(color: Color(0xffffffff))
                        ),
                        // markerSettings: const MarkerSettings(
                        //   isVisible: true,
                        //   height: 20,
                        //   width: 20,
                        //
                        // ),
                      ),
                    ],
                    primaryXAxis: CategoryAxis(
                      isVisible: false,
                      borderColor: Colors.blue,
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: true,
                      borderColor: Colors.blue,
                      //Hide the gridlines of y-axis
                      // majorGridLines: MajorGridLines(width: 0),
                      //Hide the axis line of y-axis
                      axisLine: const AxisLine(width: 0),
                    ),
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 0;
                      _type = "4Day";
                      callGraphApi();
                    });
                  },
                  child: Text("4D" , style: TextStyle(fontSize: 15, color: graphButton == 0 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 1;
                      _type = "Week";
                      callGraphApi();
                    });
                  },
                  child: Text("1W" , style: TextStyle(fontSize: 15, color: graphButton == 1 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 2;
                      _type = "15Day";
                      callGraphApi();
                    });
                  },
                  child: Text("15D" , style: TextStyle(fontSize: 15, color: graphButton == 2 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 3;
                      _type = "Month";
                      callGraphApi();
                    });
                  },
                  child: Text("1M" , style: TextStyle(fontSize: 15, color: graphButton == 3 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 4;
                      _type = "2Month";
                      callGraphApi();
                    });
                  },
                  child: Text("2M" , style: TextStyle(fontSize: 15, color: graphButton == 4 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      graphButton = 5;
                      _type = "Year";
                      callGraphApi();
                    });
                  },
                  child: Text("1Y" , style: TextStyle(fontSize: 15, color: graphButton == 5 ? Color(0xff7B39FB) : Color(0xffFFFFFF))
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.61),
                        ),
                        backgroundColor: const Color(0xff5C428F)
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('+ Add Coin',
                        style: TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
                            fontWeight: FontWeight.w400, color: Color(0xffffffff)),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.61),
                        ),
                        backgroundColor: const Color(0xff777E90)
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrendsPage()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('View Trends',
                        style: TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
                            fontWeight: FontWeight.w400, color: Color(0xffffffff)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> callGraphApi() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await _sprefs;
    var currName = prefs.getString("currencyName") ?? 'BTC';
    name = currName;
    var uri = '${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoGraph?type=$_type&name=$name&currency=USD';
    print(uri);
    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
    if(data['error'] == false){
      setState(() {
        bitcoinDataList = data['data'].map<Bitcoin>((json) =>
            Bitcoin.fromJson(json)).toList();
        diffRate = double.parse(data['diffRate']);
        if(diffRate < 0) {
          result = double.parse(data['diffRate'].replaceAll("-", "")).toStringAsFixed(2);
        } else {
          result = double.parse(data['diffRate']).toStringAsFixed(2);
        }
        fullName = data['fullname'];
        currencyData = [];
        for (var element in bitcoinDataList) {
          currencyData.add(CartData(element.date!, double.parse(element.rate!.toStringAsFixed(2))));
          name = element.name!;
          // coin = element.rate!;
          String step2 = element.rate!.toStringAsFixed(2);
          print(step2);
          double step3 = double.parse(step2);
          coin = step3;
        }
        //  print(currencyData.length);
        isLoading = false;
      });

    }
    else {
      //  _ackAlert(context);
    }
  }
}
class CartData {
  final String date;
  final double rate;

  CartData(this.date, this.rate);
}