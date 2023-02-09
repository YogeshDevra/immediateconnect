// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'CoinsImmediateScreen.dart';
import 'ImmediateConnect.dart';
import 'localization/ImmAppLocalizations.dart';
import 'models/ImmediateBitcoin.dart';
import 'PortfolioImmediateScreen.dart';
import 'TopCoinsImmediateScreen.dart';

class TrendsImmediateScreen extends StatefulWidget {
  const TrendsImmediateScreen({super.key});

  @override
  _TrendsImmediateScreenState createState() => _TrendsImmediateScreenState();

}

class _TrendsImmediateScreenState extends State<TrendsImmediateScreen> {
  Future<SharedPreferences> sPrefs = SharedPreferences.getInstance();
  List<ImmediateBitcoin> bitcoinDataList = [];
  double iDiffRate = 0;
  List<CartData> currencyData = [];
  String name = "";
  double coin = 0;
  String result = '';
  int graphButton = 1;
  String _type = 'Week';
  String? tomcatUrl;
  bool loading = false;

  @override
  void initState() {
    fetchFirebaseValue();
    super.initState();
  }

  fetchFirebaseValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      tomcatUrl = remoteConfig.getString('immediate_connect_tomcat_url').trim();
      print(tomcatUrl);
      setState(() {
      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    callGraphApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 50),
        child: AppBar(
            centerTitle: true,
            shadowColor: Colors.white,
            elevation: 0.0,
            backgroundColor: const Color(0xFFFFFFFF),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _modalBottomMenu();
                    });
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Color(0xffd76614),)
              ),
            ),
            title: Text(ImmAppLocalizations.of(context).translate('trends'),
                style: GoogleFonts.openSans(textStyle: const TextStyle(
                color: Color(0xffd76614),
                fontSize: 22,
                fontWeight: FontWeight.bold),)
            )),
      ),
      body: SafeArea(
        child: loading ? const Center(child: CircularProgressIndicator(color: Color(0xffd76614)))
            : Column(
          children: [
            const SizedBox(height: 5,),
            Card(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Row(
                          children: [
                            FadeInImage(
                              width: 50, height: 50,
                              placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                              image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${name.toLowerCase()}.png"),
                            ),
                            const SizedBox(width:3,),
                            Text('$name ',
                                style:GoogleFonts.openSans(textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w600),)
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text('\$ $coin $name ',
                                style:GoogleFonts.openSans(textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w600
                                ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(iDiffRate < 0 ? '-' : "+", style: TextStyle(fontSize: 16, color: iDiffRate < 0 ? Colors.red : Colors.green)),
                                  Icon(Icons.attach_money, size: 16, color: iDiffRate < 0 ? Colors.red : Colors.green),
                                  Text(result, style: TextStyle(fontSize: 16, color: iDiffRate < 0 ? Colors.red : Colors.green)),
                                ],
                              ),
                            ]
                        ),
                        ]),
                )
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 50.0, height: 40.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? Colors.white:const Color(0xff50af95)),
                        backgroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? const Color(0xff50af95) : Colors.white,),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        graphButton = 1;
                        _type = "Week";
                        callGraphApi();
                      });
                    },
                    child: const Text("Week" , style: TextStyle(fontSize: 15)),
                  ),
                ),
                ButtonTheme(
                  minWidth: 50.0, height: 40.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? Colors.white:const Color(0xff50af95)),
                        backgroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff50af95) : Colors.white,),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        graphButton = 2;
                        _type = "Month";
                        callGraphApi();
                      });
                    },
                    child: const Text("Month" , style: TextStyle(fontSize: 15)),
                  ),
                ),
                ButtonTheme(
                  minWidth: 50.0, height: 40.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? Colors.white:const Color(0xff50af95)),
                        backgroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff50af95) : Colors.white,),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        graphButton = 3;
                        _type = "Year";
                        callGraphApi();
                      });
                    },
                    child: const Text("Year" , style: TextStyle(fontSize: 15)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child:Container(
                height: MediaQuery.of(context).size.height/2.5,
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(),
                            child:  Row(children: <Widget>[
                              SizedBox(
                                  width: MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height / 1.51,
                                  child: SfCartesianChart(
                                    isTransposed: false,
                                    plotAreaBorderWidth: 0,
                                    enableAxisAnimation: true,
                                    enableSideBySideSeriesPlacement: true,
                                    series: <ChartSeries>[
                                      SplineSeries<CartData, double>(
                                        dataSource: currencyData,
                                        xValueMapper: (CartData data, _) => data.date,
                                        yValueMapper: (CartData data, _) => data.rate,
                                        color: const Color(0xff50af95),
                                        splineType: SplineType.monotonic,
                                        dataLabelSettings: const DataLabelSettings(
                                          isVisible: true,
                                          useSeriesColor: true,
                                          showCumulativeValues: true,
                                        ),
                                      ),
                                    ],
                                    primaryXAxis: NumericAxis(
                                      isVisible: false,
                                      borderColor: Colors.blue,
                                    ),
                                    primaryYAxis: NumericAxis(
                                        isVisible: false,
                                        borderColor: Colors.blue
                                    ),
                                  )
                              )
                            ],),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> callGraphApi() async {
    setState(() {loading = true;});
    final SharedPreferences prefs = await sPrefs;
    var currName = prefs.getString("Name") ?? 'BTC';
    name = currName;
    var uri = '$tomcatUrl/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$name';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if(data['error'] == false){
      setState(() {
        bitcoinDataList = data['data'].map<ImmediateBitcoin>((json) => ImmediateBitcoin.fromJson(json)).toList();
        double count = 0;
        iDiffRate = double.parse(data['diffRate']);
        if(iDiffRate < 0) {
          result = data['diffRate'].replaceAll("-", "");
        } else {
          result = data['diffRate'];
        }
        currencyData = [];
        for (var element in bitcoinDataList) {
          currencyData.add(CartData(count, element.immBitRate!));
          name = element.immBitName!;
          String step2 = element.immBitRate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          coin = step3;
          count = count+1;
        }
        loading = false;
      });
    }
    else {}

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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrendsImmediateScreen()));
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("immediateAsset/connectImage/connectTrends.png",height: 60,width: 60,)),
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

}
class CartData {
  final double date;
  final double rate;

  CartData(this.date, this.rate);
}