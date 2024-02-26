
// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages, non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/AddCoinScreen.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/trendsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:collection/collection.dart';
import 'db/WishListDatabase.dart';
import 'localization/app_localization.dart';
import 'models/CryptoData.dart';

class CoinPerformance extends StatefulWidget {
  const CoinPerformance({super.key});

  @override
  State<CoinPerformance> createState() => _CoinPerformanceState();
}

class _CoinPerformanceState extends State<CoinPerformance>{
  double open = 0;
  double volume = 0;
  double close = 0;
  double high = 0;
  double low = 0;
  String name = '';
  String fullName = '';
  String icon = '';
  double rate = 0;
  String diffRate = '';
  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  List <CryptoData> Wishlist = [];
  final dbHelperr = WishListDatabase.instancee;
  bool favouriteIcon = false;
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    dbHelperr.queryAllRows().then((notes) {
      for (var note in notes) {
        Wishlist.add(CryptoData.fromJson(note));
      }
      setState(() {
        // loading = false;
      });
    });
    cryptoPerformance();
    super.initState();
  }

  Future<void> cryptoPerformance() async {
    final SharedPreferences prefs = await _sprefs;
    var currName = prefs.getString("currencyName") ?? 'BTC';
    name = currName;
    var uri = "${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoBySymbol?currency=USD&symbol=$name";
    if (await ApiConfigConnect.internetConnection()) {
      try {
        var response = await get(Uri.parse(uri)).timeout(
            const Duration(seconds: 60));
        print(response.statusCode);
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          print(data);
          if (data['error'] == false) {
            setState(() {
              icon = data['data']['icon'];
              fullName = data['data']['fullName'];
              rate = data['data']['rate'];
              diffRate = data['data']['differRate'];
              print(data['data']['volume']);
              print(data['data']['volume']);
              if (data['data']['volume'] == null) {
                volume = 0.0;
              } else {
                volume = data['data']['volume'];
              }
              if (data['data']['high'] == null) {
                high = 0.0;
              } else {
                high = data['data']['high'];
              }
              if (data['data']['low'] == null) {
                low = 0.0;
              } else {
                low = data['data']['low'];
              }
              if (data['data']['close'] == null) {
                close = 0.0;
              } else {
                close = data['data']['close'];
              }
              if (data['data']['open'] == null) {
                open = 0.0;
              } else {
                open = data['data']['open'];
              }
              print(Wishlist.length);
              for (int j = 0; j < Wishlist.length; j++) {
                if (name.contains(Wishlist[j].symbol!)) {
                  favouriteIcon = true;
                  print("first condition add $j");
                }
              }
              print("first condition add $favouriteIcon");
              setState(() {
                isLoading = false;
              });
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }else {
          // ApiConfigConnect.toastMessage(message: 'Under Maintenance');
          setState(() {
            isLoading = false;
          });
        }
      } on TimeoutException catch(e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      }
      catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ApiConfigConnect.toastMessage(message: 'No Internet');
      setState(() {
        isLoading = false;
      });
    }
    ApiConfigConnect.internetConnection();
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
        backgroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.translate('coin_performance')!,
          style: const TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      backgroundColor: Colors.black,
      body: isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xffffffff))) : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                // color: const Color(0xffBDCADB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Image.network(icon, height: 100),
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.5,
                  decoration: const BoxDecoration(
                      color: Color(0xff353945),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(41),
                          topLeft: Radius.circular(41),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0)
                      )
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: const Color(0xffBDCADB),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(icon,width: 50,height: 50,),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fullName,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(AppLocalizations.of(context)!.translate('current_value')!,
                                    style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF), fontFamily: 'Gilroy-Medium'),
                                  ),
                                  Text(rate.toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF), fontFamily: 'Gilroy-Bold'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text(AppLocalizations.of(context)!.translate('volume')!,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Color(0xffBCBCBC)),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30,top:5,bottom:5),
                            child: Text(volume.toStringAsFixed(2),style: const TextStyle(fontSize: 16,color: Colors.green),),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text(AppLocalizations.of(context)!.translate('open')!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30,top:5,bottom:5),
                            child: Text(open.toStringAsFixed(2),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),),
                          )
                        ],
                      ),
                      const Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text(AppLocalizations.of(context)!.translate('close')!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30,top:5,bottom:5),
                            child: Text(close.toStringAsFixed(2),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),),
                          )
                        ],
                      ),
                      const Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text(AppLocalizations.of(context)!.translate('high')!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30,top:5,bottom:5),
                            child: Text(high.toStringAsFixed(2),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),),
                          )
                        ],
                      ),
                      const Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text(AppLocalizations.of(context)!.translate('low')!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:30,top:5,bottom:5),
                            child: Text(low.toStringAsFixed(2),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),),
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCoinScreen(name, fullName, icon, diffRate, rate)));
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
                              onPressed: () async {
                                sharedPreferences = await SharedPreferences.getInstance();
                                setState(() {
                                  sharedPreferences!.setString("currencyName", name);
                                  sharedPreferences!.setString("currencyIcon", icon);
                                  // sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
                                  sharedPreferences!.commit();
                                });
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrendsPage()));
                                },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(AppLocalizations.of(context)!.translate('view_trends')!,
                                  style: const TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
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
              ),
              Positioned(
                left: MediaQuery.of(context).size.width/1.2,
                top: MediaQuery.of(context).size.width/30,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child:FavoriteButton(
                    isFavorite: favouriteIcon,
                    iconColor: const Color(0xffEF466F),
                    iconDisabledColor: Colors.grey,
                    valueChanged: (isFavorite) {
                      if(isFavorite){
                        _addSaveWistListCoinsToLocalStorage(name, fullName, icon, rate, diffRate);
                      } else {
                        _deleteCoinsToLocalStorage(name);
                      }
                      print('Is Favorite : $isFavorite');
                    },
                  ),
                ),
              ),
            ],
          ),
        ]
      )
    );
  }

  _deleteCoinsToLocalStorage(String symbol) async {
    setState(() async {
      final  id = await dbHelperr.delete(symbol);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '$symbol ${AppLocalizations.of(context)!.translate('delete_watchlist')!}');
    });
  }

  _addSaveWistListCoinsToLocalStorage(String symbol, String fullName, String icon, double rate, String diffRate) async {
    print(Wishlist.length);
    if (Wishlist.isNotEmpty) {
      CryptoData? bitcoinLocal = Wishlist.firstWhereOrNull((element) => element.symbol == symbol);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          WishListDatabase.columnSymbol: bitcoinLocal.symbol!,
          WishListDatabase.columnFullName: bitcoinLocal.fullName!,
          WishListDatabase.columnIcon: bitcoinLocal.icon!,
          WishListDatabase.columnRate:rate,
          WishListDatabase.columnDiffRate:diffRate,
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
          WishListDatabase.columnDiffRate: diffRate,
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
        WishListDatabase.columnDiffRate: diffRate,
      };
      final id = await dbHelperr.insert(row);
      print('3. inserted row id: $id');
      ApiConfigConnect.toastMessage(message: '$fullName ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
    }
  }
}