// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:immediate_connect/CoinPerformance.dart';
import 'package:immediate_connect/CryptoListViewAll.dart';
import 'package:immediate_connect/Setting.dart';
import 'package:immediate_connect/models/Cryptodata.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/privacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  List<Cryptodata> cryptoList = [];
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    cryptoDetails();
    super.initState();
  }

  Future<void> cryptoDetails() async {
    setState(() {

    });
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";
    var response = await get(Uri.parse(uri));
    print(response.statusCode);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        cryptoList.addAll(data['data']
            .map<Cryptodata>((json) => Cryptodata.fromJson(json))
            .toList());
        print(cryptoList.length);
      });
    } else {
      setState(() {});
    }
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
        title: const Text('Home',
          style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xff0F1621),
        child: ListView(
          padding: const EdgeInsets.only(left: 40),
          children: [
            const SizedBox(width: 300,height: 80,),
            const Text('Immediate Connect',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,
                  fontFamily: 'Inter', color: Colors.white),
            ),
            const Padding(padding: EdgeInsets.only(left: 41, top: 140)),
            ListTile(
                leading: Image.asset('assets/home.png'),
                title: const Text('Home', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {}
            ),
            ListTile(
                leading: Image.asset('assets/clist.png'),
                // Divider(
                title: const Text('Coin List', style: TextStyle(fontSize: 20,
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
                title: const Text('Swap', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {}



            ),
            ListTile(
                leading: Image.asset('assets/ACL.png'),
                // Divider(
                title: const Text('Added Coin List', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {}
            ),
            ListTile(
                leading: Image.asset('assets/wishlist.png'),
                // Divider(
                title: const Text('Wishlist', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {}

            ),ListTile(
                leading: Image.asset('assets/setting.png',height: 22),
                title: const Text('Setting', style: TextStyle(fontSize: 20,
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
                title: const Text('Privacy', style: TextStyle(fontSize: 20,
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text('Discover, Add and Swap',style: TextStyle(fontSize: 22.89,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Medium',color: Color(0xffF8F8F8))),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Your Digital Crypto',style: TextStyle(fontSize: 38,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-SemiBold',color: Color(0xffFCFCFC)),),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featured Crypto',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Medium'),),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CryptoListViewAll()));
                    },
                    child: const Text('View all',style: TextStyle(color: Colors.white,fontSize: 20),),
                  )
                ],
              ),
            ),
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
                                      color: i % 2 == 0 ? const Color(0xffBDCADB) : const Color(0xffBDDBC9),
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
                            left: MediaQuery.of(context).size.width/1.7,
                            top: MediaQuery.of(context).size.width/10,
                            child:  InkWell(
                              onTap: () {
                                // Scaffold.of(context).openDrawer();
                              },
                              child: SvgPicture.asset(
                                'assets/heart-fill.svg',
                                height: 15,
                                width: 15,
                              )
                            ),
                          ),
                        Positioned(
                            left: MediaQuery.of(context).size.width/7,
                            // right: MediaQuery.of(context).size.width/1.5,
                            top: MediaQuery.of(context).size.width/1.35,
                            child:Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xff5C428F)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('+ Add Coin',
                                    style: TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xffffffff)),),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xff00D092)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/Vectorg.png'),
                                    ),
                                  ),
                                )
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
                  const Text('Top Crypto',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Medium'),),
                  InkWell(
                    onTap: () {

                    },
                    child: const Text('View all',style: TextStyle(color: Colors.white,fontSize: 20),),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/7.5,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cryptoList.length,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: i % 2 == 0 ? const Color(0xffBDCADB) : const Color(0xffBDDBC9),
                                      borderRadius: BorderRadius.circular(14.33),
                                    ),
                                    width: MediaQuery.of(context).size.width/7,
                                    height: MediaQuery.of(context).size.height/12,
                                    padding: const EdgeInsets.all(10),
                                    child: FadeInImage(
                                      placeholder: const AssetImage('assets/image/cob.png'),
                                      image: NetworkImage("${cryptoList[i].icon}"),
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
                                    Text("${cryptoList[i].fullName}",
                                        style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16.18,color: Color(0xff121212)),maxLines: 1,),
                                    Text("\$${cryptoList[i].rate!.toStringAsFixed(2)}",
                                        style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                            fontSize: 20,color: Color(0xff595959)
                                        ),maxLines: 1,
                                    ),
                                    Row(
                                      children: [
                                        double.parse(cryptoList[i].diffRate!) >= 0 ?
                                        const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                            : const Icon(
                                          Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                        ),
                                        Text(double.parse(cryptoList[i].diffRate!).toStringAsFixed(2),
                                            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                                color: double.parse(cryptoList[i].diffRate!) >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F)),maxLines: 1,),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff00D092)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset('assets/Vectorg.png'),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff5C428F)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add,color:Color(0xffffffff)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffEF466F)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:SvgPicture.asset(
                                      'assets/heart-fill.svg',
                                      height: 25,
                                      width: 25,
                                    )
                                  ),
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
}







