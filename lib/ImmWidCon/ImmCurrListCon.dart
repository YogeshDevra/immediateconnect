// ignore_for_file: avoid_print, depend_on_referenced_packages, file_names, library_private_types_in_public_api, use_build_context_synchronously, await_only_futures

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmCurrDataCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';

class ImmCurrListCon extends StatefulWidget {
  const ImmCurrListCon({Key? key}) : super(key: key);

  @override
  _ImmCurrListCon createState() => _ImmCurrListCon();
}

class _ImmCurrListCon extends State<ImmCurrListCon> {


  List<ImmCurrDataCon> immCurrChngCon = [];
  String? immCurrSeaCon;
  SharedPreferences? immShdPrfCon;
  String? immDhConn;

  @override
  void initState() {
    immLinkValConn();
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
    _immGetCurrDtCOn();
    immCurrCallCon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            ImmAppLocalCon.of(context)!.translate('Default_Currenciesme')!,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Color(0xff000000),
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/MenuPage', (r) => false);
                },
                child: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: immCurrChngCon.length,
                  itemBuilder: (BuildContext context, int k) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: immCurrSeaCon == immCurrChngCon[k].name!
                                  ? const Color(0xffEDEFF0)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    immClCurrSeCon();
                                    setState(() {
                                      immCurrSeaCon = immCurrChngCon[k].name!;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: immCurrChngCon[k].name! ==
                                              "USD"
                                              ? const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                "assets/images/us-13.png",
                                              ))
                                              : immCurrChngCon[k].name! ==
                                              "INR"
                                              ? const CircleAvatar(
                                              backgroundImage:
                                              AssetImage(
                                                "assets/images/Flag-India.png",
                                              ))
                                              : const CircleAvatar(
                                              backgroundImage:
                                              AssetImage(
                                                "assets/images/Flag_of_Europe.png",
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            immCurrChngCon[k].name! == "USD"
                                                ? const Text(
                                              "US Dollar",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color:
                                                  Color(0xff2C2C2C),
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontFamily: 'roboto',
                                                  fontSize: 16),
                                            )
                                                : immCurrChngCon[k].name! ==
                                                "INR"
                                                ? const Text(
                                              "Indian Rupee",
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  color: Color(
                                                      0xff2C2C2C),
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontFamily:
                                                  'roboto',
                                                  fontSize: 16),
                                            )
                                                : const Text(
                                              "European Euro",
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  color: Color(
                                                      0xff2C2C2C),
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontFamily:
                                                  'roboto',
                                                  fontSize: 16),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                immCurrChngCon[k].name!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Color(0xffAFAFAF),
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontFamily: 'roboto',
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: immCurrSeaCon ==
                                            immCurrChngCon[k].name!
                                            ? Icon(
                                          Icons.check,
                                          color: getColorFromHex(
                                              "#F5C249"),
                                        )
                                            : const Text(""),
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            indent: 60,
                            endIndent: 10,
                            thickness: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> immCurrCallCon() async {
    var uri = 'http://144.91.65.218:8085/Bitcoin/resources/getAllCurrency';
    print(uri);
    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
    if (data['error'] == false) {
      setState(() {
        immCurrChngCon = data['data']
            .map<ImmCurrDataCon>((json) => ImmCurrDataCon.fromJson(json))
            .toList();
      });
    } else {
      //  _ackAlert(context);
    }
  }

  Future<void> immClCurrSeCon() async {
    _immSaCurrDtlCon();
  }

  _immSaCurrDtlCon() async {
    immShdPrfCon = await SharedPreferences.getInstance();
    setState(() {
      immShdPrfCon!.setString("currencyExchange", immCurrSeaCon!);
    });

    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

  _immGetCurrDtCOn() async {
    immShdPrfCon = await SharedPreferences.getInstance();
    setState(() {
      immCurrSeaCon = immShdPrfCon!.getString("currencyExchange") ?? "USD";
    });
  }
}
