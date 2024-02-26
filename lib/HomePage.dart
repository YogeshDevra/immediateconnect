// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quantumaiapp/AddCoinScreen.dart';
import 'package:quantumaiapp/AddedPortfolios.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/CoinPerformance.dart';
import 'package:quantumaiapp/CoinSwapScreen.dart';
import 'package:quantumaiapp/CryptoListViewAll.dart';
import 'package:quantumaiapp/Setting.dart';
import 'package:quantumaiapp/WishListScreen.dart';
import 'package:quantumaiapp/models/CryptoData.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/privacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'db/WishListDatabase.dart';
import 'localization/app_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  List<CryptoData> cryptoList = [];
  List<CryptoData> sortList = [];
  List<CryptoData> wishList = [];
  SharedPreferences? sharedPreferences;
  final dbHelperr = WishListDatabase.instancee;
  List<bool> listbool = [];
  List<int> positionList = [];
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    dbHelperr.queryAllRows().then((notes) {
      for (var note in notes) {
        wishList.add(CryptoData.fromJson(note));
      }
      setState(() {});
    });
    cryptoDetails();
    super.initState();
  }

  Future<void> cryptoDetails() async {
    var uri = "${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";
    if (await ApiConfigConnect.internetConnection()) {
      try {
        var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
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
              print(wishList.length);
              for (int i = 0; i < cryptoList.length; i++) {
                for (int j = 0; j < wishList.length; j++) {
                  if (cryptoList[i].symbol!.contains(wishList[j].symbol!)) {
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
              sortList.addAll(cryptoList);
              sortList.sort((a, b) => a.rate!.compareTo(b.rate!));

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
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SvgPicture.asset(
                    'assets/Menu.svg',
                    // semanticsLabel: 'My SVG Image',
                    // height: 10,
                    // width: 10,
                  )
              ),
            );
          },
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.translate('home')!,
          style: const TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xff0F1621),
        child: ListView(
          padding: const EdgeInsets.only(left: 40),
          children: [
            const SizedBox(width: 300,height: 80,),
            Text(AppLocalizations.of(context)!.translate('quantum_ai')!,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600,
                  fontFamily: 'Inter', color: Colors.white),
            ),
            const Padding(padding: EdgeInsets.only(left: 41, top: 140)),
            ListTile(
                leading: Image.asset('assets/home.png'),
                title: Text(AppLocalizations.of(context)!.translate('home')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/clist.png'),
                // Divider(
                title: Text(AppLocalizations.of(context)!.translate('crypto_list')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CryptoListViewAll()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/swap.png'),
                // Divider(
                title: Text(AppLocalizations.of(context)!.translate('swap')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => const CoinSwapScreen()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/ACL.png'),
                // Divider(
                title: Text(AppLocalizations.of(context)!.translate('added_coin_list')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddedPortfolioScreen()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/wishlist.png'),
                // Divider(
                title: Text(AppLocalizations.of(context)!.translate('wish_list')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600, fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/setting.png',height: 22),
                title: Text(AppLocalizations.of(context)!.translate('setting')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Setting()));
                }
            ),
            ListTile(
                leading: Image.asset('assets/privacy.png',height: 22),
                title: Text(AppLocalizations.of(context)!.translate('privacy')!, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Privacy()));
                }
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment:Alignment.center,
              padding: const EdgeInsets.only(top:10,bottom:5),
              child: Text(AppLocalizations.of(context)!.translate('home_1')!,style: const TextStyle(fontSize: 22.89,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Medium',color: Color(0xffF8F8F8))),
            ),
            Container(
              alignment:Alignment.center,
              padding: const EdgeInsets.only(bottom:10,top:5),
              child: Text(AppLocalizations.of(context)!.translate('home_2')!,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-SemiBold',color: Color(0xffFCFCFC)),),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.translate('home_3')!,style: const TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Medium'),),
                  InkWell(
                    onTap: () {
                      if(cryptoList.isNotEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CryptoListViewAll()));
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.translate('home_4')!,style: const TextStyle(color: Colors.white,fontSize: 20),),
                  )
                ],
              ),
            ),
            loading ? SizedBox(
                height: MediaQuery.of(context).size.height/2.5,
                width: MediaQuery.of(context).size.width/0.7,
                child: const Center(child: CircularProgressIndicator(color: Color(0xffffffff)))) :
            cryptoList.isEmpty ? Center(child : Text(AppLocalizations.of(context)!.translate('no_data_found')!)) :
            SizedBox(
              height: MediaQuery.of(context).size.height/2.5,
              width: MediaQuery.of(context).size.width/0.7,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cryptoList.length,
                  itemBuilder: (BuildContext context, int i){
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.6,
                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(35.95),
                            ),
                            child: GestureDetector(
                              onTap:() async {
                                sharedPreferences = await SharedPreferences.getInstance();
                                setState(() {
                                  sharedPreferences!.setString("currencyName", cryptoList[i].symbol!);
                                  // sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
                                  sharedPreferences!.commit();
                                });
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoinPerformance()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        // color: i % 2 == 0 ? Colors.white60 : const Color(0xffBDDBC9),
                                        borderRadius: BorderRadius.circular(35.95),
                                      ),
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
                          left: MediaQuery.of(context).size.width/1.9,
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
                            left: MediaQuery.of(context).size.width/4.5,
                            // right: MediaQuery.of(context).size.width/1.5,
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
                                //   onTap:() async {
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
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.translate('home_5')!,style: const TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Medium'),),
                  // InkWell(
                  //   onTap: () {
                  //
                  //   },
                  //   child: const Text('View all',style: TextStyle(color: Colors.white,fontSize: 20),),
                  // )
                ],
              ),
            ),
            loading ? SizedBox(
                height: MediaQuery.of(context).size.height/7.5,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: CircularProgressIndicator(color: Color(0xffffffff)))) :
            sortList.isEmpty ? Center(child : Text(AppLocalizations.of(context)!.translate('no_data_found')!)) :
            SizedBox(
              height: MediaQuery.of(context).size.height/7.5,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sortList.length,
                  itemBuilder: (BuildContext context, int i){
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.06,
                        height: MediaQuery.of(context).size.height/9,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: GestureDetector(
                          onTap:() {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoinPerformance()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          // color: i % 2 == 0 ? const Color(0xffBDCADB) : const Color(0xffBDDBC9),
                                          borderRadius: BorderRadius.circular(14.33),
                                        ),
                                        width: MediaQuery.of(context).size.width/7,
                                        height: MediaQuery.of(context).size.height/12,
                                        padding: const EdgeInsets.all(10),
                                        child: FadeInImage(
                                          placeholder: const AssetImage('assets/image/cob.png'),
                                          image: NetworkImage("${sortList[i].icon}"),
                                        )
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${sortList[i].fullName}",
                                          style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16.18,color: Color(0xff121212)),maxLines: 1,),
                                        Text("\$${sortList[i].rate!.toStringAsFixed(2)}",
                                          style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                              fontSize: 20,color: Color(0xff595959)
                                          ),maxLines: 1,
                                        ),
                                        Row(
                                          children: [
                                            double.parse(sortList[i].diffRate!) >= 0 ?
                                            const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                                : const Icon(
                                              Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                            ),
                                            Text(double.parse(sortList[i].diffRate!).toStringAsFixed(2),
                                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                                  color: double.parse(sortList[i].diffRate!) >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F)),maxLines: 1,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // InkWell(
                              //   onTap:() async {
                              //     sharedPreferences = await SharedPreferences.getInstance();
                              //     setState(() {
                              //       sharedPreferences!.setString("currencyName", sortList[i].symbol!);
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
                              //       padding: const EdgeInsets.all(10),
                              //       child: Image.asset('assets/Vectorg.png'),
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap:() async {
                                  sharedPreferences = await SharedPreferences.getInstance();
                                  setState(() {
                                    sharedPreferences!.setString("currencyName", sortList[i].symbol!);
                                    sharedPreferences!.setString("currencyIcon", sortList[i].icon!);
                                    sharedPreferences!.commit();
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCoinScreen(sortList[i].symbol!, sortList[i].fullName!, sortList[i].icon!, sortList[i].diffRate!, sortList[i].rate!)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff5C428F)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.add,color:Color(0xffffffff)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child:FavoriteButton(
                                  isFavorite: positionList.contains(i),
                                  iconColor: const Color(0xffEF466F),
                                  iconDisabledColor: Colors.grey,
                                  valueChanged: (isFavorite) {
                                    if(isFavorite){
                                      _addSaveWistListCoinsToLocalStorage(sortList[i]);
                                    } else {
                                      _deleteCoinsToLocalStorage(sortList[i]);
                                    }
                                    print('Is Favorite : $isFavorite');
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ]
      ),
    );
  }

  _addSaveWistListCoinsToLocalStorage(CryptoData cryptoData) async {
    print(wishList.length);
    if (wishList.isNotEmpty) {
      CryptoData? bitcoinLocal = wishList.firstWhereOrNull((element) => element.symbol == cryptoData.symbol);
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
        Fluttertoast.showToast(
            msg: "${bitcoinLocal.fullName} ${AppLocalizations.of(context)!.translate('already_add_watchlist')!}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
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
        ApiConfigConnect.toastMessage(message: '${cryptoData.fullName}  ${AppLocalizations.of(context)!.translate('add_watchlist')!}');
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen()));
  }

  _deleteCoinsToLocalStorage(CryptoData cryptoData) async {
    setState(() async {
      final  id = await dbHelperr.delete(cryptoData.symbol!);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '${cryptoData.fullName} ${AppLocalizations.of(context)!.translate('delete_watchlist')!}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen()));
    });
  }
}







