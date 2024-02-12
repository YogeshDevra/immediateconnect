
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/trendsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

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
  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  @override
  void initState() {
    cryptoPerformance();
    super.initState();
  }

  Future<void> cryptoPerformance() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await _sprefs;
    var currName = prefs.getString("currencyName") ?? 'BTC';
    name = currName;
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoBySymbol?currency=USD&symbol=$name";
    var response = await get(Uri.parse(uri));
    print(response.statusCode);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        icon = data['data']['icon'];
        fullName = data['data']['fullName'];
        rate = data['data']['rate'];
        volume = data['data']['volume'];
        high = data['data']['high'];
        low = data['data']['low'];
        close = data['data']['close'];
        open = data['data']['open'];
        // coinList.add(data['data']
        //     .map<Crypto>((json) => Crypto.fromJson(json))
        //     .toList());
        // print(coinList.length);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Coin Performance',
          style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      backgroundColor: Colors.black,
      body: isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffBDCADB),
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
                                color: const Color(0xffBDCADB),
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
                                  const Text("Current Value ",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF), fontFamily: 'Gilroy-Medium'),
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
                          const Padding(
                            padding: EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text('Volume',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Color(0xffBCBCBC)),),
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
                          const Padding(
                            padding: EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text("Open",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
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
                          const Padding(
                            padding: EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text("Close",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
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
                          const Padding(
                            padding: EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text("High",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
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
                          const Padding(
                            padding: EdgeInsets.only(left:30,top:5,bottom:5),
                            child: Text("Low",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)),),
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('+ Add Coin',
                                  style: TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
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
                                  // sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
                                  sharedPreferences!.commit();
                                });
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrendsPage()));
                                },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('View Trends',
                                  style: TextStyle(fontFamily: 'Manrope', fontSize: 18.61,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                      onTap: () {
                        // Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/heart-unfill.svg',
                          height: 20,
                          width: 20,
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ]
      )
    );
  }
}