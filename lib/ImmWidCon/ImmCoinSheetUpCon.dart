// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, sized_box_for_whitespace, avoid_print, non_constant_identifier_names, prefer_is_empty, sort_child_properties_last, prefer_final_fields, depend_on_referenced_packages, library_private_types_in_public_api, file_names, await_only_futures

import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import '../ImmDataBaseCon/ImmFavCon.dart';
import '../ImmLoadCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmBitcoinCon.dart';
import '../ImmModelCon/ImmFavDataCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';

class ImmCoinSheetUpConn extends StatefulWidget {
  const ImmCoinSheetUpConn({Key? key}) : super(key: key);

  @override
  _ImmCoinSheetUpConn createState() => _ImmCoinSheetUpConn();
}

class _ImmCoinSheetUpConn extends State<ImmCoinSheetUpConn>
    with SingleTickerProviderStateMixin {

  bool immLoadCnConn = false;
  List<ImmBitCoinCon> imBnLtConn = [];
  List<ImmFavDataCon> imWstLtConn = [];
  List<int> imPostLtConn = [];
  List<bool> imLstBoolConn = [];
  final imDbFavConn = ImmFavCon.favInst;
  bool immHdNavConn = false;
  SharedPreferences? imShdPrfConn;
  String? immDhConn;
  String? imCurCnConn;
  Future<SharedPreferences> _imSpfCnConn = SharedPreferences.getInstance();

  @override
  void initState() {
    setState(() {
      immLoadCnConn = true;
    });
    immLinkValConn();
    imDbFavConn.queryAllRows().then((notes) {
      notes.forEach((note) {
        imWstLtConn.add(ImmFavDataCon.fromMap(note));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex("#FAFAFA"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColorFromHex("#FAFAFA"),
        centerTitle: true,
        title: Text(
          ImmAppLocalCon.of(context)!.translate('List')!,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),
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
          onTap: () async {
            imShdPrfConn = await SharedPreferences.getInstance();
            setState(() {
              imShdPrfConn!.setInt("index", immHdNavConn?4:3);
              imShdPrfConn!.setString(
                  "title",
                  ImmAppLocalCon.of(context)!
                      .translate('Dashboard')
                      .toString());
            });
            Navigator.pushNamedAndRemoveUntil(
                context, '/NavigationPage', (r) => false);
          },
        ),
        leadingWidth: 35,
      ),
      body: immLoadCnConn == true
          ? Center(child: SizedBox(height: 10, child: ImmLoadBitCon()))
          : Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: DataTable2(
              //checkboxAlignment: Alignment.topLeft,
              isHorizontalScrollBarVisible: true,
              isVerticalScrollBarVisible: true,
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              bottomMargin: 20,
              dataRowHeight: 75,
              dividerThickness: 0,

              columns: [
                const DataColumn2(
                  label: Text(''),
                  size: ColumnSize.S,
                ),
                const DataColumn2(
                  label: Text(''),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Name',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: getColorFromHex("#99B2C6"),
                      )),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Current price',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: getColorFromHex("#99B2C6"),
                      )),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Last 24h',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: getColorFromHex("#99B2C6"),
                      )),
                  size: ColumnSize.M,
                ),
              ],
              rows: List<DataRow>.generate(
                imBnLtConn.length,
                    (index) => DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                          value: imPostLtConn.contains(index),
                          onChanged: (bool? value) {
                            setState(() {
                              imLstBoolConn[index] = value!;
                              if (imLstBoolConn[index]) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                      getColorFromHex("#E8E8E8"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      title: const Text(
                                          'Want to Add to Favorites list'),
                                      // actionsPadding: EdgeInsets.all(30),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _immAddSvWishLstToLolStConn(
                                                    imBnLtConn[index]);
                                              },
                                              child: const Text("Yes",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  )),
                                            ),
                                            // SizedBox(width: 20),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                      getColorFromHex("#E8E8E8"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      title: const Text(
                                          'Want to Remove to Favorites list '),
                                      // actionsPadding: EdgeInsets.all(30),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                _immDelWishLstFromLolStConn(
                                                    imBnLtConn[index]);
                                                imShdPrfConn =
                                                await SharedPreferences
                                                    .getInstance();
                                                setState(() {
                                                  imShdPrfConn!
                                                      .setInt("index", 3);
                                                  imShdPrfConn!.setString(
                                                      "title",
                                                      ImmAppLocalCon.of(
                                                          context)!
                                                          .translate(
                                                          'Dashboard')
                                                          .toString());
                                                });

                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/NavigationPage',
                                                        (r) => false);

                                                Fluttertoast.showToast(
                                                    msg:
                                                    "${imBnLtConn[index].name} is Delete from Favorites list",
                                                    toastLength: Toast
                                                        .LENGTH_SHORT,
                                                    gravity: ToastGravity
                                                        .BOTTOM,
                                                    timeInSecForIosWeb: 3,
                                                    backgroundColor:
                                                    Colors.black,
                                                    textColor:
                                                    Colors.white,
                                                    fontSize: 16.0);
                                              },
                                              child: const Text("Yes",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  )),
                                            ),
                                            // SizedBox(width: 20),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          checkColor: Colors.white,
                          activeColor: getColorFromHex("#217EFD"),
                          fillColor: MaterialStateProperty.all(
                              getColorFromHex("#217EFD"))),
                    ),

                    DataCell(
                      Container(
                        height: 40,
                        width: 40,
                        child: FadeInImage(
                          placeholder:
                          const AssetImage('assets/images/cob.png'),
                          image: NetworkImage(
                              "https://assets.coinlayer.com/icons/${imBnLtConn[index].symbol}.png"),
                        ),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            imBnLtConn[index].name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: getColorFromHex("#17181A")),
                          ),
                          Text(
                            imBnLtConn[index].symbol!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: getColorFromHex("#809FB8")),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      imCurCnConn == "USD"
                          ? Text(
                        "\$${imBnLtConn[index].rate!.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: getColorFromHex("#17181A")),
                      )
                          : imCurCnConn == "INR"
                          ? Text(
                        "₹${imBnLtConn[index].rate!.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: getColorFromHex("#17181A")),
                      )
                          : imCurCnConn == "EUR"
                          ? Text(
                        "€${imBnLtConn[index].rate!.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color:
                            getColorFromHex("#17181A")),
                      )
                          : const Text(""),
                    ),
                    DataCell(
                      double.parse(imBnLtConn[index].diffRate!) < 0
                          ? Container(
                        height: 30,
                        width: 90,
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.trending_down,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 50,
                              child: Text(
                                "${double.parse(imBnLtConn[index].diffRate!.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: getColorFromHex("#595959"),
                                    )),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        width: 90,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 50,
                              child: Text(
                                "${double.parse(imBnLtConn[index].diffRate!.replaceFirst(RegExp(r'-'), '')).toStringAsFixed(2)}%",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: getColorFromHex("#1AD598"),
                                    )),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _immAddSvWishLstToLolStConn(ImmBitCoinCon bitcoin) async {
    if (imWstLtConn.length > 0) {
      ImmFavDataCon? bitcoinLocal = imWstLtConn.firstWhereOrNull(
              (element) => element.name == bitcoin.name);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          ImmFavCon.columnName: bitcoin.name,
          ImmFavCon.columnrate: bitcoin.rate,
          ImmFavCon.columndiffRate: bitcoin.diffRate,
          ImmFavCon.columnsymbol: bitcoin.symbol,
        };
        final id = await imDbFavConn.update(row);
        print('inserted row id: $id');
        print('${bitcoin.name} is Already Added');

        Fluttertoast.showToast(
            msg: "${bitcoin.name} is Already Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Map<String, dynamic> row = {
          ImmFavCon.columnName: bitcoin.name,
          ImmFavCon.columnrate: bitcoin.rate,
          ImmFavCon.columndiffRate: bitcoin.diffRate,
          ImmFavCon.columnsymbol: bitcoin.symbol,
        };
        final id = await imDbFavConn.insert(row);
        print('inserted row id: $id');
        Fluttertoast.showToast(
            msg: "${bitcoin.name} is added into Favorites List",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Map<String, dynamic> row = {
        ImmFavCon.columnName: bitcoin.name,
        ImmFavCon.columnrate: bitcoin.rate,
        ImmFavCon.columndiffRate: bitcoin.diffRate,
        ImmFavCon.columnsymbol: bitcoin.symbol,
      };
      final id = await imDbFavConn.insert(row);
      print('inserted row id: $id');
    }


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImmCoinSheetUpConn()),
    );
  }

  _immDelWishLstFromLolStConn(ImmBitCoinCon delete) async {
    setState(() async {
      final id = await imDbFavConn.delete(delete.name.toString());
      print('inserted row id: $id');
    });
  }

  Future<void> imBnApiConn() async {
    final SharedPreferences prefs = await _imSpfCnConn;
    var currencyName = prefs.getString("currencyExchange") ?? 'USD';
    imCurCnConn = currencyName;
    var uri =
        '$immDhConn/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=$imCurCnConn';
    print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        imBnLtConn.addAll(data['data']
            .map<ImmBitCoinCon>((json) => ImmBitCoinCon.fromJson(json))
            .toList());
        imLstBoolConn.clear();
        for (int i = 0; i < imBnLtConn.length; i++) {
          for (int j = 0; j < imWstLtConn.length; j++) {
            if (imBnLtConn[i].name! == imWstLtConn[j].name) {
              imLstBoolConn.add(true);
              imPostLtConn.add(i);
              print("first condition add $i");
            }
          }
        }

        for (int i = 0; i < imBnLtConn.length; i++) {
          if (imLstBoolConn.length < imBnLtConn.length) {
            imLstBoolConn.add(false);
          }
        }

        immLoadCnConn = false;
      });
    } else {
      setState(() {});
    }
  }
}
