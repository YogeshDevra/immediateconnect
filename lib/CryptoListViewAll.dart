// ignore_for_file: file_names, use_build_context_synchronously, depend_on_referenced_packages, deprecated_member_use, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/CoinPerformance.dart';
import 'package:quantumaiapp/models/CryptoData.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddCoinScreen.dart';
import 'HomePage.dart';
import 'db/WishListDatabase.dart';
import 'localization/app_localization.dart';

class CryptoListViewAll extends StatefulWidget {
  const CryptoListViewAll({super.key});

  @override
  State<CryptoListViewAll> createState() => _CryptoListViewAllState();
}

class _CryptoListViewAllState extends State<CryptoListViewAll>{
  List<CryptoData> cryptoList = [];
  List <CryptoData> Wishlist = [];
  final dbHelperr = WishListDatabase.instancee;
  List<bool> listbool = [];
  List<int> positionList = [];
  SharedPreferences? sharedPreferences;
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
    coinsDetails();
    super.initState();
  }

  Future<void> coinsDetails() async {
    var uri = "${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";
    if(await ApiConfigConnect.internetConnection()){
      try {
        var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
        print(response.statusCode);
        print(response.statusCode);
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          print(data);
          if (data['error'] == false) {
            setState(() {
              cryptoList.addAll(data['data']
                  .map<CryptoData>((json) => CryptoData.fromJson(json))
                  .toList());
              print(cryptoList.length);
              listbool.clear();
              print(Wishlist.length);
              for (int i = 0; i < cryptoList.length; i++) {
                for (int j = 0; j < Wishlist.length; j++) {
                  if (cryptoList[i].symbol!.contains(Wishlist[j].symbol!)) {
                    listbool.add(true);
                    positionList.add(i);
                    print("first condition add $i");
                  }
                }
              }
              print(listbool.length);
              print(positionList.length);

              for (int i = 0; i < cryptoList.length; i++) {
                print("${listbool.length} < ${cryptoList.length}");
                if (listbool.length < cryptoList.length) {
                  listbool.add(false);
                }
              }
              print(listbool);
              print(positionList);
              loading = false;
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
        title: Text(AppLocalizations.of(context)!.translate('crypto_list')!,style: const TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),),
      ),
      backgroundColor: Colors.black,
      body: loading ? const Center(child: CircularProgressIndicator(color: Color(0xffffffff))) :
      cryptoList.isEmpty ? Center(child : Text(AppLocalizations.of(context)!.translate('no_data_found')!)) :
      SizedBox(
        // height: MediaQuery.of(context).size.height/2.5,
        width: MediaQuery.of(context).size.width/0.7,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cryptoList.length,
            itemBuilder: (BuildContext context, int i){
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.6,
                      height: MediaQuery.of(context).size.height/2.8,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(35.95),
                      ),
                      child: GestureDetector(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoinPerformance()));
                        },
                        child: Column(
                          children: [
                            Container(
                                // decoration: BoxDecoration(
                                //   color: i % 2 == 0 ? const Color(0xffBDCADB) : const Color(0xffBDDBC9),
                                //   borderRadius: BorderRadius.circular(35.95),
                                // ),
                                width: MediaQuery.of(context).size.width/1.6,
                                height: MediaQuery.of(context).size.height/4.5,
                                padding: const EdgeInsets.all(50),
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/image/cob.png'),
                                  image: NetworkImage("${cryptoList[i].icon}"),
                                )
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/3.5,
                                    child: Text("${cryptoList[i].fullName}",
                                        style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16.18,color: Color(0xff121212))),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          double.parse(cryptoList[i].diffRate!) >= 0 ?
                                          const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                              : const Icon(
                                            Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                          ),
                                          Text(double.parse(cryptoList[i].diffRate!).toStringAsFixed(2),
                                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                                  color: double.parse(cryptoList[i].diffRate!) >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F))),
                                        ],
                                      ),
                                      Container(
                                          alignment: Alignment.topRight,
                                          width: MediaQuery.of(context).size.width/3.5,
                                          child: Text("\$${cryptoList[i].rate!.toStringAsFixed(2)}",
                                              style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                                  fontSize: 20,color: Color(0xff595959)
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width/1.5,
                    top: MediaQuery.of(context).size.width/10,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FavoriteButton(
                        isFavorite: positionList.contains(i),
                        iconColor: const Color(0xffEF466F),
                        iconDisabledColor: Colors.grey,
                        valueChanged: (isFavorite) {
                          if(isFavorite){
                            _addSaveWistListCoinsToLocalStorage(cryptoList[i]);
                          } else {
                            _deleteCoinsToLocalStorage(cryptoList[i]);
                          }
                          print('Is Favorite : $isFavorite');
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width/2.8,
                      top: MediaQuery.of(context).size.width/1.35,
                      child:Row(
                        children: [
                          InkWell(
                            onTap:() async {
                              sharedPreferences = await SharedPreferences.getInstance();
                              setState(() {
                                sharedPreferences!.setString("currencyName", cryptoList[i].symbol!);
                                sharedPreferences!.setString("currencyIcon", cryptoList[i].icon!);
                                sharedPreferences!.commit();
                              });
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCoinScreen(cryptoList[i].symbol!, cryptoList[i].fullName!, cryptoList[i].icon!, cryptoList[i].diffRate!, cryptoList[i].rate!)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff5C428F)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('+ ${AppLocalizations.of(context)!.translate('add_coin')!}',
                                  style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xffffffff)),),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 10,),
                          // InkWell(
                          //   onTap: () async {
                          //     sharedPreferences = await SharedPreferences.getInstance();
                          //     setState(() {
                          //       sharedPreferences!.setString("currencyName", cryptoList[i].symbol!);
                          //       // sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
                          //       sharedPreferences!.commit();
                          //     });
                          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoinPerformance()));
                          //   },
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: const Color(0xff00D092)
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Image.asset('assets/Vectorg.png'),
                          //     ),
                          //   ),
                          // )
                        ],
                      )
                  )
                ],
              );
            }
        ),
      ),
    );
  }

  _deleteCoinsToLocalStorage(CryptoData cryptoData) async {
    setState(() async {
      final  id = await dbHelperr.delete(cryptoData.symbol!);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '${cryptoData.fullName} ${AppLocalizations.of(context)!.translate('delete_watchlist')!}');
    });
  }

  _addSaveWistListCoinsToLocalStorage(CryptoData cryptoData) async {
    print(Wishlist.length);
    if (Wishlist.isNotEmpty) {
      CryptoData? bitcoinLocal = Wishlist.firstWhereOrNull((element) => element.symbol == cryptoData.symbol);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          WishListDatabase.columnSymbol: bitcoinLocal.symbol!,
          WishListDatabase.columnFullName: bitcoinLocal.fullName!,
          WishListDatabase.columnIcon: bitcoinLocal.icon!,
          WishListDatabase.columnRate:cryptoData.rate!,
          WishListDatabase.columnDiffRate:cryptoData.diffRate!,
        };
        final id = await dbHelperr.update(row);
        print('1. updated row id: $id');
        print('${bitcoinLocal.fullName} is Already Added');
        ApiConfigConnect.toastMessage(message: '${bitcoinLocal.fullName} ${AppLocalizations.of(context)!.translate('already_add_watchlist')!}');
      } else {
        Map<String, dynamic> row = {
          WishListDatabase.columnSymbol: cryptoData.symbol!,
          WishListDatabase.columnFullName: cryptoData.fullName!,
          WishListDatabase.columnIcon: cryptoData.icon!,
          WishListDatabase.columnRate:cryptoData.rate!,
          WishListDatabase.columnDiffRate:cryptoData.diffRate!,
        };
        final id = await dbHelperr.insert(row);
        print('2. inserted row id: $id');
        ApiConfigConnect.toastMessage(message: '${cryptoData.fullName} ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
      }
    }
    else {
      Map<String, dynamic> row = {
        WishListDatabase.columnSymbol: cryptoData.symbol!,
        WishListDatabase.columnFullName: cryptoData.fullName!,
        WishListDatabase.columnIcon: cryptoData.icon!,
        WishListDatabase.columnRate:cryptoData.rate!,
        WishListDatabase.columnDiffRate:cryptoData.diffRate!,
      };
      final id = await dbHelperr.insert(row);
      print('3. inserted row id: $id');
      ApiConfigConnect.toastMessage(message: '${cryptoData.fullName} ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
    }
  }
}