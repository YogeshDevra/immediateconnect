// ignore_for_file: deprecated_member_use, file_names, depend_on_referenced_packages, library_private_types_in_public_api, non_constant_identifier_names, unused_field, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/CoinPerformance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'AddCoinScreen.dart';
import 'HomePage.dart';
import 'db/WishListDatabase.dart';
import 'package:collection/collection.dart';
import 'localization/app_localization.dart';
import 'models/CryptoData.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  double diffRate = 0;
  List <CryptoData> Wishlist = [];
  List<CartData> currencyData = [];
  String name = "";
  String icon = "";
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
  SharedPreferences? sharedPreferences;
  List <CryptoData> bitcoinDataList = [];
  final dbHelperr = WishListDatabase.instancee;
  bool favouriteIcon = false;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    dbHelperr.queryAllRows().then((notes) {
      for (var note in notes) {
        Wishlist.add(CryptoData.fromJson(note));
      }
      setState(() {
        // loading = false;
      });
    });
    callGraphApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back,
              color: Color(0xffFFFFFF)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.translate('trend')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xffffffff))) :
        bitcoinDataList.isEmpty ? const Center(child: Text('No Record Found.'))
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
                            // color: const Color(0xffBDCADB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage(
                              width: 50, height: 50,
                              placeholder: const AssetImage('assets/image/cob.png'),
                              image: NetworkImage(icon),
                            ),
                          ),
                        ),
                        const SizedBox(width:3),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/2.5,
                          child: Text('$fullName ',
                              style:GoogleFonts.openSans(textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w600),
                              )
                          ),
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
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child:FavoriteButton(
                      isFavorite: favouriteIcon,
                      iconColor: const Color(0xffEF466F),
                      iconDisabledColor: Colors.grey,
                      valueChanged: (isFavorite) {
                        if(isFavorite){
                          _addSaveWistListCoinsToLocalStorage(name, fullName, icon, coin, diffRate);
                        } else {
                          _deleteCoinsToLocalStorage(name);
                        }
                        print('Is Favorite : $isFavorite');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child:Container(
                  color: const Color(0xffffffff),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
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
                      AreaSeries<CartData, String>(
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
                            textStyle: TextStyle(color: Color(0xff7B39FB))
                        ),
                        // markerSettings: const MarkerSettings(
                        //   isVisible: true,
                        //   height: 20,
                        //   width: 20,
                        //
                        // ),
                        gradient: LinearGradient(
                            colors:  [ const Color(0xFF7B39FB).withOpacity(0.90), const Color(0xFF777E90).withOpacity(0.10)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter),
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
                  child: Text("4D" , style: TextStyle(fontSize: 15, color: graphButton == 0 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
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
                  child: Text("1W" , style: TextStyle(fontSize: 15, color: graphButton == 1 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
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
                  child: Text("15D" , style: TextStyle(fontSize: 15, color: graphButton == 2 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
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
                  child: Text("1M" , style: TextStyle(fontSize: 15, color: graphButton == 3 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
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
                  child: Text("2M" , style: TextStyle(fontSize: 15, color: graphButton == 4 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
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
                  child: Text("1Y" , style: TextStyle(fontSize: 15, color: graphButton == 5 ? const Color(0xff7B39FB) : const Color(0xffFFFFFF))
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCoinScreen(name, fullName, icon, diffRate.toString(), coin)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('+ ${AppLocalizations.of(context)!.translate('add_coin')!}',
                        style: const TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoinPerformance()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(AppLocalizations.of(context)!.translate('home_14')!,
                        style: const TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
                            fontWeight: FontWeight.w400, color: Color(0xffffffff)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> callGraphApi() async {
    final SharedPreferences prefs = await _sprefs;
    var currName = prefs.getString("currencyName") ?? 'BTC';
    var currIcon = prefs.getString("currencyIcon") ?? 'https://assets.coinlayer.com/icons/BTC.png';
    name = currName;
    icon = currIcon;
    var uri = '${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoGraph?type=$_type&name=$name&currency=USD';
    if(await ApiConfigConnect.internetConnection()) {
      try {
        print(uri);
        var response = await get(Uri.parse(uri));
        //  print(response.body);
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          //print(data);
          if(data['error'] == false){
            setState(() {
              bitcoinDataList = data['data'].map<CryptoData>((json) =>
                  CryptoData.fromJson(json)).toList();
              diffRate = double.parse(data['diffRate']);
              if(diffRate < 0) {
                result = double.parse(data['diffRate'].replaceAll("-", "")).toStringAsFixed(2);
              } else {
                result = double.parse(data['diffRate']).toStringAsFixed(2);
              }
              fullName = data['fullname'];
              print(Wishlist.length);
              for(int j= 0; j < Wishlist.length; j++){
                if(name.contains(Wishlist[j].symbol!)){
                  favouriteIcon = true;
                  print("first condition add $j");
                }
              }
              print("first condition add $favouriteIcon");
              currencyData = [];
              print("bitcoinDataList.length ${bitcoinDataList.length}");
              for(var element in bitcoinDataList){
                print('${element.date} ${element.rate}');
                currencyData.add(CartData(element.date!, double.parse(element.rate!.toStringAsFixed(2))));
                String step2 = element.rate!.toStringAsFixed(2);
                print(step2);
                double step3 = double.parse(step2);
                coin = step3;
              }
              // for (var element in bitcoinDataList) {
              //   print('bitcoinDataList ${element.rate}');
              //   currencyData.add(CartData(element.date!, double.parse(element.rate!.toStringAsFixed(2))));
              //   name = element.symbol!;
              //   coin = element.rate!;
              //   String step2 = element.rate!.toStringAsFixed(2);
              //   print(step2);
              //   double step3 = double.parse(step2);
              //   coin = step3;
              // }
              print(currencyData.length);

              isLoading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        } else {
          // ApiConfigConnect.toastMessage(message: 'Under Maintenance');
          setState(() {
            loading = false;
          });
        }
      } on TimeoutException catch(e) {
        setState(() {
          loading = false;
        });
        print(e);
      }
      catch (e) {
        setState(() {
          loading = false;
        });
      }
    } else {
      ApiConfigConnect.toastMessage(message: 'No Internet');
      setState(() {
        loading = false;
      });
    }
    ApiConfigConnect.internetConnection();
  }

  _deleteCoinsToLocalStorage(String symbol) async {
    setState(() async {
      final  id = await dbHelperr.delete(symbol);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '$symbol ${AppLocalizations.of(context)!.translate('delete_watchlist')}');
    });
  }

  _addSaveWistListCoinsToLocalStorage(String symbol, String fullName, String icon, double rate, double diffRate) async {
    print(Wishlist.length);
    if (Wishlist.isNotEmpty) {
      CryptoData? bitcoinLocal = Wishlist.firstWhereOrNull((element) => element.symbol == symbol);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          WishListDatabase.columnSymbol: bitcoinLocal.symbol!,
          WishListDatabase.columnFullName: bitcoinLocal.fullName!,
          WishListDatabase.columnIcon: bitcoinLocal.icon!,
          WishListDatabase.columnRate:rate,
          WishListDatabase.columnDiffRate:diffRate.toString(),
        };
        final id = await dbHelperr.update(row);
        print('1. updated row id: $id');
        print('${bitcoinLocal.fullName} is Already Added');
        ApiConfigConnect.toastMessage(message: '${bitcoinLocal.fullName} ${AppLocalizations.of(context)!.translate('already_add_watchlist')!}');
      } else {
        Map<String, dynamic> row = {
          WishListDatabase.columnSymbol: symbol,
          WishListDatabase.columnFullName: fullName,
          WishListDatabase.columnIcon: icon,
          WishListDatabase.columnRate: rate,
          WishListDatabase.columnDiffRate: diffRate.toString(),
        };
        final id = await dbHelperr.insert(row);
        print('2. inserted row id: $id');
        ApiConfigConnect.toastMessage(message: '$fullName ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
      }
    }
    else {
      Map<String, dynamic> row = {
        WishListDatabase.columnSymbol: symbol,
        WishListDatabase.columnFullName: fullName,
        WishListDatabase.columnIcon: icon,
        WishListDatabase.columnRate: rate,
        WishListDatabase.columnDiffRate: diffRate.toString(),
      };
      final id = await dbHelperr.insert(row);
      print('3. inserted row id: $id');
      ApiConfigConnect.toastMessage(message: '$fullName ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
    }
  }
}
class CartData {
  final String date;
  final double rate;

  CartData(this.date, this.rate);
}