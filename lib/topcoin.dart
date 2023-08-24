// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, deprecated_member_use, library_private_types_in_public_api, prefer_is_empty

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'IframeHomePage.dart';
import 'ImmediateConnectAnalytics.dart';
import 'coinsPage.dart';
import 'dashboard_home.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'models/TopCoinData.dart';
import 'portfoliopage.dart';
import 'trendsPage.dart';

class TopCoinsPage extends StatefulWidget {
  const TopCoinsPage({super.key});

  @override
  _TopCoinsPageState createState() => _TopCoinsPageState();

}

class _TopCoinsPageState extends State<TopCoinsPage> {
  List<Bitcoin> _gainerlosserHTC = [];
  List<TopCoinData> _allDataTC = [];
  List<Bitcoin> gainerLooserCoinList = [];
  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  String? URL;

  @override
  void initState() {
    ImmediateConnectAnalytics.setCurrentScreen(ImmediateConnectAnalytics.TOPCOINS_SCREEN, "Top Coins Page");
    fetchRemoteValue();
    super.initState();
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
      URL = remoteConfig.getString('immediate_connect_port_url_sst').trim();

      print(URL);
      setState(() {

      });
    } on PlatformException catch (exception){
      print("Platform Exception");
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    _getDataForBitcoin();
    // callGainerLooserBitcoinApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading:InkWell(
            onTap: () {
              setState(() {
                _modalBottomMenu();
              });
            }, // Image tapped
            child: const Icon(Icons.menu_rounded,
              color: Colors.black,
              size: 30,
            )
        ),
        title: Text(AppLocalizations.of(context).translate('top_coin'),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.start,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading?const Center(child:CircularProgressIndicator(color: Color(0xFF4A42F3),),)
            :Container(
            margin: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             _modalBottomMenu();
                  //           });
                  //         }, // Image tapped
                  //         child: const Icon(Icons.menu_rounded,
                  //           color: Colors.black,
                  //           size: 30,
                  //         )
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 90,
                  //     ),
                  //     Text(AppLocalizations.of(context).translate('top_coin'),
                  //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  //       textAlign: TextAlign.start,
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height/4.5,
                      width: MediaQuery.of(context).size.width/.7,
                      child: _allDataTC.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _allDataTC.length,
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  height:60,
                                  padding: const EdgeInsets.all(10),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left:5.0),
                                            child: FadeInImage(
                                              width: 50,
                                              height: 50,
                                              placeholder: const AssetImage('assets/image/cob.png'),
                                              image: NetworkImage("$URL/Bitcoin/resources/icons/${_allDataTC[i].name!.toLowerCase()}.png"),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(left:10.0),
                                              child:Text('${_allDataTC[i].name}',
                                                style: const TextStyle(fontSize: 22,fontWeight:FontWeight.bold,color:Colors.black),
                                                textAlign: TextAlign.left,
                                              )
                                          ),
                                          const SizedBox(width: 35,)
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left:10),
                                        child: Text('\$${double.parse(_allDataTC[i].rate!.toStringAsFixed(2))}',
                                          style: const TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left:10),
                                        child: Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                  crossAxisAlignment:CrossAxisAlignment.center,
                                                  mainAxisAlignment:MainAxisAlignment.end,
                                                  children:[
                                                    double.parse(_allDataTC[i].diffRate!) < 0
                                                        ? const Icon(Icons.remove, color: Colors.red, size: 15,)
                                                        : const Icon(Icons.add, color: Colors.green, size: 15,),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(double.parse(_allDataTC[i].diffRate!) < 0
                                                        ? "${double.parse(_allDataTC[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                                        : "${double.parse(_allDataTC[i].diffRate!).toStringAsFixed(2)} %",
                                                        style: TextStyle(fontSize: 13,
                                                            color: double.parse(_allDataTC[i].diffRate!) < 0
                                                                ? Colors.red
                                                                : Colors.green)
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(AppLocalizations.of(context).translate('top_gain'),
                      style:GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold, color: Colors.black))
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.separated(
                      separatorBuilder: (_, __) =>  const SizedBox(width: 8),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _gainerlosserHTC.length,
                      itemBuilder: (BuildContext context, int i) {
                        return _gainerlosserHTC.length >= 0
                        ?InkWell(
                            child:
                            double.parse(_gainerlosserHTC[i].diffRate!) >= 0
                                ?
                            Card(
                              margin: const EdgeInsets.all(5),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.white10, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          savsDataForChart(_gainerlosserHTC[i].name);
                                        },
                                        child:Row(
                                          children: [
                                            FadeInImage(
                                              width: 60,
                                              height: 50,
                                              placeholder: const AssetImage('assets/image/cob.png'),
                                              image: NetworkImage("$URL/Bitcoin/resources/icons/${_gainerlosserHTC[i].name?.toLowerCase()}.png"),
                                            ),
                                            Text('${_gainerlosserHTC[i].name}',
                                              style:GoogleFonts.openSans(textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)
                                              ),),
                                          ],
                                        ),),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('\$${double.parse(_gainerlosserHTC[i].rate!.toStringAsFixed(2))}',
                                            style: GoogleFonts.openSans(textStyle:const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)
                                            ),),
                                          Text('+ ${_gainerlosserHTC[i].perRate!}',
                                            style: GoogleFonts.openSans(
                                                textStyle:const TextStyle(
                                                color: Colors.green, fontSize: 13,
                                                    fontWeight: FontWeight.w600),
                                            ),textAlign: TextAlign.right),
                                          // Row(
                                          //     crossAxisAlignment:CrossAxisAlignment.center,
                                          //     mainAxisAlignment:MainAxisAlignment.end,
                                          //     children:[
                                          //       double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //           ? const Icon(Icons.remove, color: Colors.red, size: 15,)
                                          //           : const Icon(Icons.add, color: Colors.green, size: 15,),
                                          //       const SizedBox(
                                          //         width: 2,
                                          //       ),
                                          //       Text(double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //           ? "${double.parse(_gainerlosserHTC[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                          //           : "${double.parse(_gainerlosserHTC[i].diffRate!).toStringAsFixed(2)} %",
                                          //           style: TextStyle(fontSize: 13,
                                          //               color: double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //                   ? Colors.red
                                          //                   : Colors.green)
                                          //       ),
                                          //     ]
                                          // ),
                                        ],
                                      ),
                                    ]
                                ),
                              ),
                            )
                                : const SizedBox()
                        ):Center(
                        child:Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(AppLocalizations.of(context).translate('no_coin_added')),
                        ),
                        );
                      }),),

                  Text(AppLocalizations.of(context).translate('top_lose'), style:GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 19,
                      fontWeight: FontWeight.bold, color: Colors.black))
                  ),
                  Expanded(
                    flex:3,
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _gainerlosserHTC.length,
                      itemBuilder: (BuildContext context, int i) {
                        return _gainerlosserHTC.length >= 0?
                        InkWell(
                            child: double.parse(
                                _gainerlosserHTC[i].diffRate!) < 0
                                ?
                            Card(
                              margin: const EdgeInsets.all(5),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.white10, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          savsDataForChart(_gainerlosserHTC[i].name);
                                        },
                                        child:Row(
                                          children: [
                                            FadeInImage(
                                              width: 60,
                                              height: 50,
                                              placeholder: const AssetImage('assets/image/cob.png'),
                                              image: NetworkImage("$URL/Bitcoin/resources/icons/${_gainerlosserHTC[i].name?.toLowerCase()}.png"),
                                            ),
                                            Text('${_gainerlosserHTC[i].name}',
                                              style:GoogleFonts.openSans(textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)
                                              ),),
                                          ],
                                        ),),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('\$${double.parse(_gainerlosserHTC[i].rate!.toStringAsFixed(2))}',
                                            style: GoogleFonts.openSans(textStyle:const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)
                                            ),),
                                          Text(_gainerlosserHTC[i].perRate!,
                                              style: GoogleFonts.openSans(
                                                textStyle:const TextStyle(
                                                    color: Colors.red, fontSize: 13,
                                                    fontWeight: FontWeight.w600),
                                              ),textAlign: TextAlign.right),
                                          // Row(
                                          //     crossAxisAlignment:CrossAxisAlignment.center,
                                          //     mainAxisAlignment:MainAxisAlignment.end,
                                          //     children:[
                                          //       double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //           ? const Icon(Icons.remove, color: Colors.red, size: 15,)
                                          //           : const Icon(Icons.add, color: Colors.green, size: 15,),
                                          //       const SizedBox(
                                          //         width: 2,
                                          //       ),
                                          //       Text(double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //           ? "${double.parse(_gainerlosserHTC[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                          //           : "${double.parse(_gainerlosserHTC[i].diffRate!).toStringAsFixed(2)} %",
                                          //           style: TextStyle(fontSize: 13,
                                          //               color: double.parse(_gainerlosserHTC[i].diffRate!) < 0
                                          //                   ? Colors.red
                                          //                   : Colors.green)
                                          //       ),
                                          //     ]
                                          // ),
                                        ],
                                      ),
                                    ]
                                ),
                              ),
                            )
                                : const SizedBox()
                        ):Center(
                          child:Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(AppLocalizations.of(context).translate('no_coin_added')),
                          ),
                        );
                      }),),

                ])),),


    );
  }

  void _modalBottomMenu() {
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
                  height: MediaQuery.of(context).size.height/1.4,
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
                                  MaterialPageRoute(builder: (context) => IframeHomePage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("assets/image/iframeicon.png",height: 60,width: 60,)),
                                  Text("Immediate Connect",textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DashboardHome()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33764.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('home'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TopCoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33765.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33766.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('coins'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TrendsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33767.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('trends'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PortfolioPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33768.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
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

  Future<void> _getDataForBitcoin() async {
    setState(() {
      isLoading = true;
    });
    var uri = '$URL/Bitcoin/resources/getBitcoinHistoryLists?size=0';
    var response = await get(Uri.parse(uri));
    print(response.body);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        _allDataTC.addAll(data['data']
            .map<TopCoinData>((json) => TopCoinData.fromJson(json))
            .toList());

      });
    } else {
      setState(() {});
    }
    _getForGainerLoserData();
  }

  Future<void> _getForGainerLoserData() async {

    var uri = '$URL/Bitcoin/resources/getBitcoinListLoser?size=0';

    print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    print(data['data']);
    if (data['error'] == false) {
      setState(() {
        _gainerlosserHTC.addAll(data['data'].map<Bitcoin>((json) => Bitcoin.fromJson(json)).toList());
        isLoading = false;
      });
    } else {
      //  _ackAlert(context);
      setState(() {});
    }
    callGainerLooserBitcoinApi();
  }

  Future<void> savsDataForChart(String? name) async {
    print('enter${name!}');
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("Name", name);
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrendsPage()),
    );
  }

  Future<void> callGainerLooserBitcoinApi() async {

    var uri =
        '$URL/Bitcoin/resources/getBitcoinListLoser?size=0';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          gainerLooserCoinList.addAll(data['data']
              .map<Bitcoin>((json) => Bitcoin.fromJson(json))
              .toList());
          isLoading = false;
          // _size = _size + data['data'].length;
        }
        );
      }

      else {
        //  _ackAlert(context);
        setState(() {});
      }
    }
  }
}


class CartData {
  final int count;
  final double rate;

  CartData(this.count, this.rate);
}