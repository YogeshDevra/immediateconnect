// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'CoinsImmediateScreen.dart';
import 'localization/ImmAppLocalizations.dart';
import 'models/ImmediateBitcoin.dart';
import 'PortfolioImmediateScreen.dart';
import 'TopCoinsImmediateScreen.dart';
import 'TrendsImmediateScreen.dart';


class ImmediateConnect extends StatefulWidget {
  const ImmediateConnect({Key? key}) : super(key: key);

  @override
  _ImmediateConnect createState() => _ImmediateConnect();
}

class _ImmediateConnect extends State<ImmediateConnect> {
  late WebViewController controller;
  bool loading = false;
  SharedPreferences? sharedPrefer;
  num size = 0;
  String? formIFrame;
  List<ImmediateBitcoin> immediateBitcoins = [];
  bool? isHideForm;
  String? tomcatUrl;

  @override
  void initState() {
    super.initState();
    fetchFirebaseValue();
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
      formIFrame = remoteConfig.getString('immediate_connect_form_url').trim();
      tomcatUrl = remoteConfig.getString('immediate_connect_tomcat_url').trim();
      isHideForm = remoteConfig.getBool('hide_immediate_connect');
      print(formIFrame);
      setState(() {
      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    callCoinApi();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(formIFrame!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(formIFrame!));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Color(0xfffcf2ea)),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              setState(() {_modalBottomMenu();});
                            }, // Image tapped
                            child: const Icon(Icons.menu_rounded,color: Color(0xffd76614),)
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset("immediateAsset/connectImage/logo_hor.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(ImmAppLocalizations.of(context).translate('immediate_connect1'),
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(ImmAppLocalizations.of(context).translate('immediate_connect2'),
                        style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                  ),
                  if(isHideForm == true)
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 520,
                      child : WebViewWidget(controller: controller),
                    ),
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
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect3'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect4'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect5'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect6'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect7'),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color(0xffFFFFFF)),),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect8'),style: const TextStyle(fontSize: 30 ,color: Color(0xffFFFFFF)),),
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
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect9'),textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect10'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect11'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect12'),textAlign: TextAlign.left,
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
                            child: immediateBitcoins.isEmpty
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: immediateBitcoins.length,
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
                                                      placeholder: const AssetImage('immediateAsset/connectImage/currencyPlaceholder.png'),
                                                      image: NetworkImage("$tomcatUrl/Bitcoin/resources/icons/${immediateBitcoins[i].immBitName!.toLowerCase()}.png"),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 40,),
                                                  Padding(
                                                      padding:
                                                      const EdgeInsets.only(left:10.0),
                                                      child:Text('${immediateBitcoins[i].immBitName}',
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
                                                Text('\$${double.parse(immediateBitcoins[i].immBitRate!.toStringAsFixed(2))}',
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
                                                      double.parse(immediateBitcoins[i].immBitDiffRate!) < 0
                                                          ? const Icon(Icons.arrow_drop_down_sharp, color: Colors.red, size: 18,)
                                                          : const Icon(Icons.arrow_drop_up_sharp, color: Colors.green, size: 18,),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(double.parse(immediateBitcoins[i].immBitDiffRate!) < 0
                                                          ? "\$${double.parse(immediateBitcoins[i].immBitDiffRate!.replaceAll('-', "")).toStringAsFixed(2)}"
                                                          : "\$${double.parse(immediateBitcoins[i].immBitDiffRate!).toStringAsFixed(2)}",
                                                          style: TextStyle(fontSize: 18,
                                                              color: double.parse(immediateBitcoins[i].immBitDiffRate!) < 0
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
                                      callCurrencyDetails(immediateBitcoins[i].immBitName);
                                    },
                                  );
                                })
                        ),
                      ]
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect13'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect14'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,top:15),
                          child: Image.asset('immediateAsset/connectImage/ImmediateConnect-1.png'),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(ImmAppLocalizations.of(context).translate('immediate_connect15'),
                                    style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                        color:Colors.black,height:1.6)
                                ),
                                Text(ImmAppLocalizations.of(context).translate('immediate_connect16'),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,top:15),
                          child: Image.asset('immediateAsset/connectImage/ImmediateConnect-2.png'),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(ImmAppLocalizations.of(context).translate('immediate_connect17'),
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                          color:Colors.black,height:1.6)),
                                  Text(ImmAppLocalizations.of(context).translate('immediate_connect18'),
                                      style:const TextStyle(fontSize:15,color:Color(0xff757575),height:1.6)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,top:15),
                          child: Image.asset('immediateAsset/connectImage/ImmediateConnect-3.png'),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0,right: 10.0, bottom:5.0),
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(ImmAppLocalizations.of(context).translate('immediate_connect19'),
                                      style:const TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                          color:Colors.black,height:1.6)),
                                  Text(ImmAppLocalizations.of(context).translate('immediate_connect20'),
                                      style:const TextStyle(fontSize:15,color:Color(0xff757575),height:1.6)),
                                ],
                              ),
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
                    child: Image.asset("immediateAsset/connectImage/ImmediateConnect-4.png"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect21'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect22'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("immediateAsset/connectImage/ImmediateConnect-5.png"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect23'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect24'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("immediateAsset/connectImage/ImmediateConnect-6.png"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect25'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect26'),textAlign: TextAlign.left,
                      style: const TextStyle(color: Color(0xff757575),fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("immediateAsset/connectImage/ImmediateConnect-7.png"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect27'),textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(ImmAppLocalizations.of(context).translate('immediate_connect28'),textAlign: TextAlign.center,
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
                      child: Text(ImmAppLocalizations.of(context).translate('immediate_connect29'),
                        style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(ImmAppLocalizations.of(context).translate('immediate_connect30'),
                        style: const TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset("immediateAsset/connectImage/ImmediateConnect-8.png"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callCoinApi() async {
    var uri = '$tomcatUrl/Bitcoin/resources/getBitcoinList?size=0';
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        immediateBitcoins.addAll(data['data'].map<ImmediateBitcoin>((json) => ImmediateBitcoin.fromJson(json)).toList());
        loading = false;
        size = size + data['data'].length;
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
    sharedPrefer = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefer!.setString("currencyName", name);
      sharedPrefer!.setString("title", ImmAppLocalizations.of(context).translate('trends'));
      sharedPrefer!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/trendsPage', (r) => false);
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
                                      child:
                                      Image.asset("immediateAsset/connectImage/connectHome.png",height: 60,width: 60,)),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrendsImmediateScreen()),);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("immediateAsset/connectImage/connectTrends.png",height: 60,width: 60,)
                                  ),
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

