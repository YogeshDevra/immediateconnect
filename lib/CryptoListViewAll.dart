// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/CoinPerformance.dart';
import 'package:immediate_connect/models/Cryptodata.dart';

class CryptoListViewAll extends StatefulWidget {
  const CryptoListViewAll({super.key});

  @override
  State<CryptoListViewAll> createState() => _CryptoListViewAllState();
}

class _CryptoListViewAllState extends State<CryptoListViewAll>{
  List<Cryptodata> cryptoList = [];

  @override
  void initState() {
    coinsDetails();
    super.initState();
  }

  Future<void> coinsDetails() async {
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Crypto List',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),),
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
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
                    left: MediaQuery.of(context).size.width/1.4,
                    top: MediaQuery.of(context).size.width/10,
                    child: InkWell(
                        onTap: () {
                          // Scaffold.of(context).openDrawer();
                        },
                        child: SvgPicture.asset(
                          'assets/heart-fill.svg',
                          height: 20,
                          width: 20,
                        )
                    ),
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width/3.3,
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
    );
  }
}