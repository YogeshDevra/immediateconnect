// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:immediateconnectapp/IframeHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ImmediateConnectAnalytics.dart';
import 'coinsPage.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'portfoliopage.dart';
import 'topcoin.dart';
import 'trendsPage.dart';


class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  _DashboardHome createState() => _DashboardHome();
}

class _DashboardHome extends State<DashboardHome> {
  ScrollController? _controllerList;
  late WebViewController controller;

  bool isLoading = false;

  SharedPreferences? sharedPreferences;
  num _size = 0;
  List<Bitcoin> bitcoinList = [];
  String? iFrameUrl;
  bool? displayiframe;
  String? URL;


  @override
  void initState() {
    ImmediateConnectAnalytics.setCurrentScreen(ImmediateConnectAnalytics.HOME_SCREEN, "Home Page");
    _controllerList = ScrollController();
    super.initState();
    fetchRemoteValue();
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
      iFrameUrl = remoteConfig.getString('immediate_connect_iframe_url_sst').trim();
      displayiframe = remoteConfig.getBool('bool_immediate_connect_sst');
      print(iFrameUrl);
      setState(() {
      });
    } on PlatformException catch (exception){
      print("Platform Exception");
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    callBitcoinApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffcf2ea),
        leading:InkWell(
            onTap: () {
              setState(() {
                _modalBottomMenu();
              });
            }, // Image tapped
            child: const Icon(Icons.menu_rounded,color: Color(0xffd76614),)
        ),
        title: Image.asset("assets/image/logo_hor.png"),
      ),
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Color(0xfffcf2ea)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(AppLocalizations.of(context).translate('homesen1'),
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(AppLocalizations.of(context).translate('homesen2'),
                          style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 25),),
                      ),
                    ),
                    // if(displayiframe == true)
                    //   Container(
                    //     padding: const EdgeInsets.only(left: 10, right: 10),
                    //     height: 520,
                    //     child : WebViewWidget(controller: controller),
                    //     // child: WebView(
                    //     //   initialUrl: iFrameUrl,
                    //     //   gestureRecognizers: Set()
                    //     //     ..add(Factory<VerticalDragGestureRecognizer>(
                    //     //             () => VerticalDragGestureRecognizer())),
                    //     //   javascriptMode: JavascriptMode.unrestricted,
                    //     //   onWebViewCreated:
                    //     //       (WebViewController webViewController) {
                    //     //     _controllerForm.complete(webViewController);
                    //     //   },
                    //     //   // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                    //     //   // ignore: prefer_collection_literals
                    //     //   javascriptChannels: <JavascriptChannel>[
                    //     //     _toasterJavascriptChannel(context),
                    //     //   ].toSet(),
                    //     //
                    //     //   onPageStarted: (String url) {
                    //     //     print('Page started loading: $url');
                    //     //   },
                    //     //   onPageFinished: (String url) {
                    //     //     print('Page finished loading: $url');
                    //     //   },
                    //     //   gestureNavigationEnabled: true,
                    //     // ),
                    //   ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color:Color(0xffDD650D)),
                child: Column(
                  children:  <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen3'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen4'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen5'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen6'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen7'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('homesen8'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Color(0xfffcf2ea)),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen9'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen10'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen11'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen12'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height/4,
                              width: MediaQuery.of(context).size.width/.7,
                              child: bitcoinList.isEmpty
                                  ? const Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bitcoinList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child:Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(left:5.0),
                                                      child: FadeInImage(
                                                        width: 70,
                                                        height: 70,
                                                        placeholder: const AssetImage('assets/image/cob.png'),
                                                        image: NetworkImage("$URL/Bitcoin/resources/icons/${bitcoinList[i].name!.toLowerCase()}.png"),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 40,
                                                    ),
                                                    Padding(
                                                        padding:
                                                        const EdgeInsets.only(left:10.0),
                                                        child:Text('${bitcoinList[i].name}',
                                                          style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.black),
                                                          textAlign: TextAlign.left,
                                                        )
                                                    ),
                                                  ]
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text('\$${double.parse(bitcoinList[i].rate!.toStringAsFixed(2))}',
                                                      style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.black)
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.only(left:200),
                                                  //height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child:Row(
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children:[
                                                        double.parse(bitcoinList[i].diffRate!) < 0
                                                            ? const Icon(Icons.arrow_drop_down_sharp, color: Colors.red, size: 18,)
                                                            : const Icon(Icons.arrow_drop_up_sharp, color: Colors.green, size: 18,),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(double.parse(bitcoinList[i].diffRate!) < 0
                                                            ? "\$ ${double.parse(bitcoinList[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)}"
                                                            : "\$ ${double.parse(bitcoinList[i].diffRate!).toStringAsFixed(2)}",
                                                            style: TextStyle(fontSize: 18,
                                                                color: double.parse(bitcoinList[i].diffRate!) < 0
                                                                    ? Colors.red
                                                                    : Colors.green)
                                                        ),
                                                        const SizedBox(
                                                            height: 5,
                                                            width:15
                                                        ),
                                                      ]
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        callCurrencyDetails(bitcoinList[i].name);
                                      },
                                    );
                                  })
                          ),
                        ]
                    ),
                    if(displayiframe ==true)
                      const SizedBox(
                      height: 15,
                    ),
                    if(displayiframe ==true)
                      Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen13'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    if(displayiframe ==true)
                      const SizedBox(
                      height: 10,
                    ),
                    if(displayiframe ==true)
                      Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen14'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    if(displayiframe ==true)
                      const SizedBox(
                      height: 10,
                    ),
                    if(displayiframe ==true)
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:8.0,top:15),
                            child: Image.asset('assets/image/Frame 35.png'),
                          ),
                          Expanded(
                            flex:3,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalizations.of(context).translate('homesen15'),
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                          color:Colors.black,height:1.6)
                                  ),
                                  Text(AppLocalizations.of(context).translate('homesen16'),
                                    style:const TextStyle(fontSize:15,
                                        color:Color(0xff757575),height:1.6),softWrap: true,
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    if(displayiframe ==true)
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:8.0,top:15),
                            child: Image.asset('assets/image/Frame 36.png'),
                          ),
                          Expanded(
                            flex:3,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalizations.of(context).translate('homesen17'),
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                          color:Colors.black,height:1.6)),
                                  Text(AppLocalizations.of(context).translate('homesen18'),
                                      style:const TextStyle(fontSize:15,color:Color(0xff757575),height:1.6)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(displayiframe ==true)
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:8.0,top:15),
                            child: Image.asset('assets/image/Frame 37.png'),
                          ),
                          Expanded(
                            flex:3,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalizations.of(context).translate('homesen19'),
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                          color:Colors.black,height:1.6)),
                                  Text(AppLocalizations.of(context).translate('homesen20'),
                                      style:const TextStyle(fontSize:15,color:Color(0xff757575),height:1.6)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/image/iPhone 13.png"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen21'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen22'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/image/dist_crypto.png"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen23'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen24'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/image/close_hand.png"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen25'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen26'),textAlign: TextAlign.left,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/image/gold_bitcoin.png"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen27'),textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(AppLocalizations.of(context).translate('homesen28'),textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Color(0xffDD650D)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('homesen29'),
                          style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('homesen30'),
                          style: const TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset("assets/image/crypto_design.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> callBitcoinApi() async {
    var uri = '$URL/Bitcoin/resources/getBitcoinList?size=0';
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
      //  _ackAlert(context);
      setState(() {});
    }
  }


  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
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
                            if(displayiframe == true)
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
}

