// ignore_for_file: import_of_legacy_library_into_null_safe, sort_child_properties_last, avoid_print, prefer_is_empty, library_private_types_in_public_api, non_constant_identifier_names, prefer_final_fields, file_names, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, sized_box_for_whitespace, await_only_futures

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../ImmAnalyisConn.dart';
import '../ImmDataBaseCon/ImmMainConn.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmPortDataCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmMenuSheetCon.dart';

class CryptoMarketPage extends StatefulWidget {
  const CryptoMarketPage({Key? key}) : super(key: key);

  @override
  _CryptoMarketPageState createState() => _CryptoMarketPageState();
}

class _CryptoMarketPageState extends State<CryptoMarketPage> {

  bool immLdHmConn = false;
  List<ImmBitCoinCon> imTpCnLstConn = [];
  SharedPreferences? imShdPrfHmConn;
  String? immDhConn;
  bool immHdNavConn = false;

  double imCurValPortConnHm = 0.0;
  final imDbMnHelpConn = ImmMainConn.mainInst;
  List<ImmPortDataCon> imItmHmCOnn = [];
  String? imCurHmConn;
  Future<SharedPreferences> _imSpfHMConn = SharedPreferences.getInstance();

  @override
  void initState() {
    setState(() {
      immLdHmConn = true;
    });
    ImmAnalyisConn.setCurrentScreen(ImmAnalyisConn.ImmHom_Conn, "ImmediateHomePage");
    immLinkValConn();
    immConCountTxtEdtConn = TextEditingController();
    imDbMnHelpConn.queryAllRows().then((notes) {
      notes.forEach((note) {
        imItmHmCOnn.add(ImmPortDataCon.fromMap(note));
      });
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
      immHdNavConn = remoteConfig.getBool('immediate_bool_connect');


    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    imBnApiConn();
  }

  Future<void> imBnApiConn() async {
    final SharedPreferences prefs = await _imSpfHMConn;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurHmConn = currencyName;
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=$imCurHmConn';
    print(uri);
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        imTpCnLstConn.addAll(data['data']
            .map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json))
            .toList());

        immLdHmConn = false;
      });
      imItmHmCOnn.forEach((element) {
        imCurValPortConnHm += immGtRateDiffHmConn(element, imTpCnLstConn);
      });
    } else {}
  }

  immGtRateDiffHmConn(ImmPortDataCon items, List<ImmBitCoinCon> topCoinList) {
    ImmBitCoinCon j = topCoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! * items.numberOfCoins;

    return newRateDiff;
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: getColorFromHex("#FAFAFA"),
        body: immLdHmConn == true
            ? Center(child: SizedBox(height: 10, child: ImmLoadBitCon()))
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: Height / 4,
                decoration: BoxDecoration(
                  color: getColorFromHex("#E9EDF6"),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: Container(
                  height: Height / 5.5,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: getColorFromHex("#1264FF").withOpacity(0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                ImmAppLocalCon.of(context)!
                                    .translate('Current_Balance')!,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 22)),
                              )),
                          // SizedBox(width: 30),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              imShdPrfHmConn =
                              await SharedPreferences.getInstance();
                              setState(() {
                                imShdPrfHmConn!.setInt("index", 1);
                                imShdPrfHmConn!.setString(
                                    "title",
                                    ImmAppLocalCon.of(context)!
                                        .translate('portfolio')
                                        .toString());
                              });
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/NavigationPage', (r) => false);
                            },
                            child: Container(
                              height: 25,
                              width: 60,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  ImmAppLocalCon.of(context)!
                                      .translate('Details')!,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                          getColorFromHex("#1264FF"),
                                          fontSize: 14)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: imCurHmConn == "USD"
                            ? SizedBox(
                          width: 300,
                          child: Text(
                            '\$${imCurValPortConnHm.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 36,
                                    color: Colors.white)),
                          ),
                        )
                            : imCurHmConn == "INR"
                            ? SizedBox(
                          width: 300,
                          child: Text(
                            '₹${imCurValPortConnHm.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 36,
                                    color: Colors.white)),
                          ),
                        )
                            : imCurHmConn == "EUR"
                            ? SizedBox(
                          width: 300,
                          child: Text(
                            '€${imCurValPortConnHm.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight:
                                    FontWeight.w500,
                                    fontSize: 36,
                                    color: Colors.white)),
                          ),
                        )
                            : const Text(""),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 10, top: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!
                          .translate('Trending_Crypto')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16)),
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 10, top: 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ImmAppLocalCon.of(context)!
                          .translate('left')!,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 12)),
                    )),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: imTpCnLstConn.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onTap: () {
                          imPssValToNxtConn(imTpCnLstConn[i].symbol);
                        },
                        child: Slidable(
                          key: const ValueKey(0),
                          closeOnScroll: false,
                          endActionPane: ActionPane(
                            extentRatio: 0.5,
                            motion: const ScrollMotion(),
                            children: [
                              InkWell(
                                onTap: () {
                                  imShwAddPortShtConn(imTpCnLstConn[i]);
                                },
                                child: Container(
                                  height:
                                  MediaQuery.of(context).size.height /
                                      10,
                                  width: 150,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: getColorFromHex("#D6E4FD"),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6))),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                       Flexible(
                                         child:  Text(
                                           ImmAppLocalCon.of(context)!
                                               .translate('add_coins')!,softWrap: true,
                                           style: GoogleFonts.roboto(
                                               textStyle: const TextStyle(
                                                   fontWeight:
                                                   FontWeight.w500,
                                                   color: Colors.black,
                                                   fontSize: 18)),
                                         )
                                       )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: Container(
                            height:
                            MediaQuery.of(context).size.height / 10,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10),
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(6))),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: getColorFromHex("#D1D6E0"),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/images/cob.png'),
                                      image: NetworkImage(
                                          "https://assets.coinlayer.com/icons/${imTpCnLstConn[i].symbol}.png"),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${imTpCnLstConn[i].name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: getColorFromHex(
                                                    "#17181A"))),
                                       textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${imTpCnLstConn[i].symbol}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: getColorFromHex(
                                                    "#809FB8"))),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                double.parse(imTpCnLstConn[i].diffRate!) < 0
                                    ? Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color:
                                      getColorFromHex("#FF775C")
                                          .withOpacity(0.1)),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.trending_down,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          "${double.parse(imTpCnLstConn[i].diffRate!.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w400,
                                                color: getColorFromHex(
                                                    "#595959"),
                                              )),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color:
                                      getColorFromHex("#1AD598")
                                          .withOpacity(0.1)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          "${double.parse(imTpCnLstConn[i].diffRate!.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w400,
                                                color: getColorFromHex(
                                                    "#1AD598"),
                                              )),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 80,
                                  child: imCurHmConn == "USD"
                                      ? Text(
                                    '\$${imTpCnLstConn[i].rate!.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: getColorFromHex(
                                                "#17181A"))),
                                    textAlign: TextAlign.right,
                                  )
                                      : imCurHmConn == "INR"
                                      ? Text(
                                    '₹${imTpCnLstConn[i].rate!.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w500,
                                            color:
                                            getColorFromHex(
                                                "#17181A"))),
                                    textAlign: TextAlign.right,
                                  )
                                      : imCurHmConn == "EUR"
                                      ? Text(
                                    '€${imTpCnLstConn[i].rate!.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow
                                        .ellipsis,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight
                                                .w500,
                                            color: getColorFromHex(
                                                "#17181A"))),
                                    textAlign:
                                    TextAlign.right,
                                  )
                                      : const Text(""),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  height: 25,
                                  width: 3,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    color: getColorFromHex("#1264FF"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ));
  }

  Future<void> imPssValToNxtConn(imName) async {
    _imSvConDtForTrdConn(imName);
  }

  _imSvConDtForTrdConn(String Symbol) async {
    imShdPrfHmConn = await SharedPreferences.getInstance();
    setState(() {
      imShdPrfHmConn!.setString("currencyName", Symbol);
      // imShdPrfHmConn!.setBool("imHdCon", immHdNavConn);
      imShdPrfHmConn!.setInt("index", immHdNavConn?5:4);
      imShdPrfHmConn!.setString(
          "title", ImmAppLocalCon.of(context)!.translate('trends') ?? '');
    });

    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

  TextEditingController? immConCountTxtEdtConn;
  final _imFomKyConn = GlobalKey<FormState>();

  Future<void> imShwAddPortShtConn(ImmBitCoinCon bitcoin) async {
    immConCountTxtEdtConn!.text = "";
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: getColorFromHex("#FAFAFA"),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: getColorFromHex("#FAFAFA"),
              centerTitle: true,
              title: Text(
                ImmAppLocalCon.of(context)!.translate('add_coins')!,
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                textAlign: TextAlign.start,
              ),
              leading: InkWell(
                child: Container(
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              leadingWidth: 35,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#1264FF"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FadeInImage(
                                placeholder:
                                const AssetImage('assets/images/cob.png'),
                                image: NetworkImage(
                                    "https://assets.coinlayer.com/icons/${bitcoin.symbol}.png"),
                              ),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            bitcoin.symbol ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              imCurHmConn == "USD"
                                  ? Text(
                                "\$${bitcoin.rate!.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              )
                                  : imCurHmConn == "INR"
                                  ? Text(
                                "₹${bitcoin.rate!.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 36,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.white)),
                              )
                                  : imCurHmConn == "EUR"
                                  ? Text(
                                "€${bitcoin.rate!.toStringAsFixed(2)}",
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 36,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.white)),
                              )
                                  : const Text(""),
                              const SizedBox(height: 5),
                              Text(
                                "${double.parse(bitcoin.diffRate!).toStringAsFixed(2)}%",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: double.parse(
                                            bitcoin.diffRate!) >=
                                            0
                                            ? Colors.green
                                            : Colors.red)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        width: 4,
                        color: getColorFromHex("#1264FF"),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ImmAppLocalCon.of(context)!
                                .translate('enter_coins')!,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8)),
                            textAlign: TextAlign.start,
                          ),
                          Form(
                            key: _imFomKyConn,
                            child: TextFormField(
                              controller: immConCountTxtEdtConn,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintStyle: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 25)),
                                hintText: '______',
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),

                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                              ], // O
                              //only numbers can be entered
                              validator: (val) {
                                if (immConCountTxtEdtConn!.text ==
                                    "" ||
                                    double.parse(
                                        immConCountTxtEdtConn!
                                            .value.text) <=
                                        0) {
                                  return "At least 1 coin should be added";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 160),
                  Stack(children: [
                    Image.asset("assets/images/addcoinbottomi.png"),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 110),
                      child: InkWell(
                        onTap: () {
                          _imAdSvToLocalStConn(bitcoin);
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                ImmAppLocalCon.of(context)!
                                    .translate('add_coins')!,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: getColorFromHex("#1264FF"),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ));
  }

  _imAdSvToLocalStConn(ImmBitCoinCon bitcoin) async {
    if (_imFomKyConn.currentState!.validate()) {
      if (imItmHmCOnn.length > 0) {
        ImmPortDataCon? bitcoinLocal =
        imItmHmCOnn.firstWhereOrNull((element) => element.name == bitcoin.name);
        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            ImmMainConn.columnName: bitcoin.name,
            ImmMainConn.columnSymbol: bitcoin.symbol.toString(),
            ImmMainConn.columnIcon: bitcoin.icon.toString(),
            ImmMainConn.columnRateDuringAdding: bitcoin.rate,
            ImmMainConn.columnCoinsQuantity:
            double.parse(immConCountTxtEdtConn!.value.text) +
                bitcoinLocal.numberOfCoins,
            ImmMainConn.columnTotalValue:
            double.parse(immConCountTxtEdtConn!.value.text) *
                (bitcoin.rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await imDbMnHelpConn.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            ImmMainConn.columnName: bitcoin.name,
            ImmMainConn.columnSymbol: bitcoin.symbol.toString(),
            ImmMainConn.columnIcon: bitcoin.icon.toString(),
            ImmMainConn.columnRateDuringAdding: bitcoin.rate,
            ImmMainConn.columnCoinsQuantity:
            double.parse(immConCountTxtEdtConn!.value.text),
            ImmMainConn.columnTotalValue:
            double.parse(immConCountTxtEdtConn!.value.text) *
                (bitcoin.rate!),
          };
          final id = await imDbMnHelpConn.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          ImmMainConn.columnName: bitcoin.name,
          ImmMainConn.columnSymbol: bitcoin.symbol.toString(),
          ImmMainConn.columnIcon: bitcoin.icon.toString(),
          ImmMainConn.columnRateDuringAdding: bitcoin.rate,
          ImmMainConn.columnCoinsQuantity:
          double.parse(immConCountTxtEdtConn!.text),
          ImmMainConn.columnTotalValue:
          double.parse(immConCountTxtEdtConn!.value.text) *
              (bitcoin.rate!),
        };
        final id = await imDbMnHelpConn.insert(row);
        print('inserted row id: $id');
      }

      imShdPrfHmConn = await SharedPreferences.getInstance();
      setState(() {
        imShdPrfHmConn!.setString("currencyName", bitcoin.symbol!);
        imShdPrfHmConn!.setInt("index", immHdNavConn?2:1);
        // imShdPrfHmConn!.setBool("imHdCon", immHdNavConn);
        imShdPrfHmConn!.setString("title",
            ImmAppLocalCon.of(context)!.translate('portfolio').toString());
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/NavigationPage', (r) => false);
    } else {}
  }
}
