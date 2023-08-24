// ignore_for_file: sort_child_properties_last, prefer_final_fields, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, await_only_futures

import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmLangDtCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmCoinSheetUpCon.dart';
import 'ImmDashPageCon.dart';
import 'ImmDriftScnCon.dart';
import 'ImmFrameShtConn.dart';
import 'ImmHomeMarketCon.dart';
import 'ImmMenuSheetCon.dart';
import 'ImmPortSheetCon.dart';

class ImmNavSheetCon extends StatefulWidget {
  @override
  _ImmNavSheetCon createState() => _ImmNavSheetCon();
}

class _ImmNavSheetCon extends State<ImmNavSheetCon> {

  Future<SharedPreferences> _immSpfCon = SharedPreferences.getInstance();
  int _immSltIdxCon = 0;
  String _lable = 'Crypto Market';
  SharedPreferences? immShdPrfCon;
  final PageStorageBucket immButCon = PageStorageBucket();
  String? immLangCdSvCon;
  bool immHdNavConn = false;

  List<ImmLangDtCon> languages = [
    ImmLangDtCon(languageCode: "en", languageName: "English"),
    ImmLangDtCon(languageCode: "it", languageName: "Italian"),
    ImmLangDtCon(languageCode: "de", languageName: "German"),
    ImmLangDtCon(languageCode: "sv", languageName: "Swedish"),
    ImmLangDtCon(languageCode: "fr", languageName: "French"),
    ImmLangDtCon(languageCode: "nb", languageName: "Norwegian"),
    ImmLangDtCon(languageCode: "es", languageName: "Spanish"),
    ImmLangDtCon(languageCode: "nl", languageName: "Dutch"),
    ImmLangDtCon(languageCode: "fi", languageName: "Finnish"),
    ImmLangDtCon(languageCode: "ru", languageName: "Russian"),
    ImmLangDtCon(languageCode: "pt", languageName: "Portuguese"),
    ImmLangDtCon(languageCode: "ar", languageName: "Arabic"),
  ];

  @override
  void initState() {
    final newVersion = NewVersionPlus(
      androidId: 'com.sspl.immediateconnectapp',
    );
    Timer(const Duration(milliseconds: 800),() {
      immVrsnUpdConn(newVersion);
    });

    fortLinkValue();
    super.initState();
  }

  fortLinkValue() async{
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      immHdNavConn = remoteConfig.getBool('immediate_bool_connect');


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    immHdNavConn == true?immGetShdFrmPrfCon():immGetShdPrfCon();
  }

  void immVrsnUpdConn(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if(status!=null){
      if(status.canUpdate){
        newVersion.showUpdateDialog(
          context: context,
          versionStatus:status,
          dialogTitle:'Update Available!!!',
          dialogText:'Please Update Your App',
          allowDismissal: false,
        );
      }
    }
  }

  Future<void> immGetShdPrfCon() async {
    final SharedPreferences prefs = await _immSpfCon;
    setState(() {
      _immSltIdxCon = prefs.getInt("index") ?? 0;
      immLangCdSvCon = prefs.getString('language_code') ?? "en";
      immTapNavConn(_immSltIdxCon);
      _lable = prefs.getString("title") ??
          ImmAppLocalCon.of(context)!.translate('Crypto_Market')!;
      _immSvPrfDataCon();
    });
  }

  Future<void> immGetShdFrmPrfCon() async {
    final SharedPreferences prefs = await _immSpfCon;
    setState(() {
      _immSltIdxCon = prefs.getInt("index") ?? 0;
      immLangCdSvCon = prefs.getString('language_code') ?? "en";
      immTapNavFrmConn(_immSltIdxCon);
      _lable = prefs.getString("title") ??
          ImmAppLocalCon.of(context)!.translate('home')!;
      _immSvPrfFrmDataCon();
    });
  }

  _immSvPrfDataCon() async {
    immShdPrfCon = await SharedPreferences.getInstance();
    setState(() {
      immShdPrfCon!.setInt("index", 0);
      immShdPrfCon!.setString("title",
          ImmAppLocalCon.of(context)!.translate('Crypto_Market') ?? '');
    });
  }

  _immSvPrfFrmDataCon() async {
    immShdPrfCon = await SharedPreferences.getInstance();
    setState(() {
      immShdPrfCon!.setInt("index", 0);
      immShdPrfCon!.setString("title",
          ImmAppLocalCon.of(context)!.translate('home') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: immHdNavConn == true
        ?AppBar(
        leading: _immSltIdxCon == 0
            ? InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ImmMenuSheetCoin()));
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        )
            : null,
        elevation: 0,
        backgroundColor: getColorFromHex("#E9EDF6"),
        centerTitle: true,
        title: _lable ==
            ImmAppLocalCon.of(context)!.translate('Crypto_Market')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('Crypto_Market')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable == ImmAppLocalCon.of(context)!.translate('portfolio')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('portfolio')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable == ImmAppLocalCon.of(context)!.translate('Dashboard')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('Dashboard')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable ==
            ImmAppLocalCon.of(context)!.translate('trends')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('trends')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : Text(
          ImmAppLocalCon.of(context)!
              .translate('home')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        ),
      )
        :AppBar(
        leading: _immSltIdxCon == 0
            ? InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ImmMenuSheetCoin()));
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        )
            : null,
        elevation: 0,
        backgroundColor: getColorFromHex("#E9EDF6"),
        centerTitle: true,
        title: _lable ==
            ImmAppLocalCon.of(context)!.translate('Crypto_Market')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('Crypto_Market')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable == ImmAppLocalCon.of(context)!.translate('portfolio')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('portfolio')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable == ImmAppLocalCon.of(context)!.translate('Dashboard')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('Dashboard')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : _lable ==
            ImmAppLocalCon.of(context)!.translate('trends')
            ? Text(
          ImmAppLocalCon.of(context)!.translate('trends')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        )
            : Text(
          ImmAppLocalCon.of(context)!
              .translate('Crypto_Market')!,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: getColorFromHex("#2D2E31"),
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          textAlign: TextAlign.start,
        ),
      ),
      body: immHdNavConn == true
      ?SafeArea(
        child: PageStorage(
          child: immSltWidFmCon(),
          bucket: immButCon,
        ),
      )
      :SafeArea(
        child: PageStorage(
          child: immSltWidCon(),
          bucket: immButCon,
        ),
      ),
      bottomNavigationBar: immHdNavConn
        ? immBttNavFrmConn
        : immBttNavConn,
    );
  }

  Widget get immBttNavConn {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(50),
      ),
      height: 60,
      child: Row(
        //children inside bottom appbar
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/home2.png",
                    color: _immSltIdxCon == 0
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                ),
              ],
            ),
            onTap: () {
              immTapNavConn(0);
            },
          ),
          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/crypto2.png",
                    color: _immSltIdxCon == 1
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
              ],
            ),
            onTap: () {
              immTapNavConn(1);
            },
          ),
          InkWell(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                    child: Image.asset(
                      "assets/images/trend2.png",
                      color: _immSltIdxCon == 4
                          ? getColorFromHex("#1264FF")
                          : Colors.grey,
                    )),
              ],
            ),
            onTap: () {
              immTapNavConn(4);
            },
          ),

          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/profile2.png",
                    color: _immSltIdxCon == 3
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
              ],
            ),
            onTap: () {
              immTapNavConn(3);
            },
          ),
        ],
      ),
    );
  }

  Widget get immBttNavFrmConn {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(50),
      ),
      height: 60,
      child: Row(
        //children inside bottom appbar
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/form_nav.png",height: 25,
                    color: _immSltIdxCon == 0
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                ),
              ],
            ),
            onTap: () {
              immTapNavFrmConn(0);
            },
          ),
          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/home2.png",
                    color: _immSltIdxCon == 1
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                ),
              ],
            ),
            onTap: () {
              immTapNavFrmConn(1);
            },
          ),
          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/crypto2.png",
                    color: _immSltIdxCon == 2
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
              ],
            ),
            onTap: () {
              immTapNavFrmConn(2);
            },
          ),
          InkWell(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                    child: Image.asset(
                      "assets/images/trend2.png",
                      color: _immSltIdxCon == 5
                          ? getColorFromHex("#1264FF")
                          : Colors.grey,
                    )),
              ],
            ),
            onTap: () {
              immTapNavFrmConn(5);
            },
          ),

          InkWell(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/profile2.png",
                    color: _immSltIdxCon == 4
                        ? getColorFromHex("#1264FF")
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
              ],
            ),
            onTap: () {
              immTapNavFrmConn(4);
            },
          ),
        ],
      ),
    );
  }

  Widget immSltWidCon() {
    switch (_immSltIdxCon) {
      case 0:
        return const CryptoMarketPage();
      case 1:
        return const ImmPortSheetConn();
      case 2:
        return const ImmCoinSheetUpConn();
      case 3:
        return const ImmDashPgConn();
      case 4:
        return const ImmDriftScnCon();
      default:
        return Container();
    }
  }

  Widget immSltWidFmCon() {
    switch (_immSltIdxCon) {
      case 0:
        return ImmFrameShtConn();
      case 1:
        return const CryptoMarketPage();
      case 2:
        return const ImmPortSheetConn();
      case 3:
        return const ImmCoinSheetUpConn();
      case 4:
        return const ImmDashPgConn();
      case 5:
        return const ImmDriftScnCon();
      default:
        return Container();
    }
  }

  void immTapNavFrmConn(int index) {
    setState(() {
      _immSltIdxCon = index;
      if (index == 0) {
        _lable = ImmAppLocalCon.of(context)!.translate('home')!;
      } else if (index == 1) {
        _lable = ImmAppLocalCon.of(context)!.translate('Crypto_Market')!;
      }else if (index == 2) {
        _lable = ImmAppLocalCon.of(context)!.translate('portfolio')!;
      } else if (index == 3) {
        _lable = ImmAppLocalCon.of(context)!.translate('Coin_List')!;
      } else if (index == 4) {
        _lable = ImmAppLocalCon.of(context)!.translate('Dashboard')!;
      }
      else if (index == 5) {
        _lable = ImmAppLocalCon.of(context)!.translate('trends')!;
      }
    });
  }

  void immTapNavConn(int index) {
    setState(() {
      _immSltIdxCon = index;
      if (index == 0) {
        _lable = ImmAppLocalCon.of(context)!.translate('Crypto_Market')!;
      } else if (index == 1) {
        _lable = ImmAppLocalCon.of(context)!.translate('portfolio')!;
      } else if (index == 2) {
        _lable = ImmAppLocalCon.of(context)!.translate('Coin_List')!;
      } else if (index == 3) {
        _lable = ImmAppLocalCon.of(context)!.translate('Dashboard')!;
      }
      else if (index == 4) {
        _lable = ImmAppLocalCon.of(context)!.translate('trends')!;
      }
    });
  }

}

