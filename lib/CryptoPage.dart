import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:immediate_connect/Coinperformance.dart';
import 'package:immediate_connect/Cryptolist.dart';
import 'package:immediate_connect/Setting.dart';
import 'package:immediate_connect/models/Cryptodata.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/privacy.dart';

class Cryptolist extends StatefulWidget {
   const Cryptolist({super.key});

  @override
  State<Cryptolist> createState() => _CryptolistState();
}
class _CryptolistState extends State<Cryptolist>{
  List<Cryptodata> Cryptolist = [];
  @override
  void initState() {
    CryptoDetails();
    super.initState();
  }
  Future<void>CryptoDetails ()async {
    setState(() {

    });
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";


        var response = await get(Uri.parse(uri));
        print(response.statusCode);
        final data = json.decode(response.body) as Map;
        print(data);
        if (data['error'] == false) {
          setState(() {
            Cryptolist.addAll(data['data']
                .map<Cryptodata>((json) => Cryptodata.fromJson(json))
                .toList());
            print(Cryptolist.length);
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
            return IconButton(
              icon: const Icon(
                Icons.dashboard_outlined,color: Colors.white,size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Home',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),

        ),
      ),drawer: Drawer(
      backgroundColor: Color(0xff0F1621),
      child: ListView(
        padding: EdgeInsets.only(left: 40),
        children: [
          SizedBox(width: 300,height: 80,),
          Text('Immediate Connect', style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.white

          ),
          ),Padding(padding: EdgeInsets.only(left: 41, top: 140)

          ),
          ListTile(
              leading: Image.asset('assets/home.png'),
              // Divider(
              title: Text('Home', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.white),
              ),
              onTap: () {}



          ),
          ListTile(
              leading: Image.asset('assets/clist.png'),
              // Divider(
              title: Text('Coin List', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cryptopage()));

              }



          ),
          ListTile(
              leading: Image.asset('assets/swap.png'),
              // Divider(
              title: Text('Swap', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.white),
              ),
              onTap: () {}



          ),
          ListTile(
              leading: Image.asset('assets/ACL.png'),
              // Divider(
              title: Text('Added Coin List', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.white),
              ),
              onTap: () {}
          ),
          ListTile(
              leading: Image.asset('assets/wishlist.png'),
              // Divider(
              title: Text('Wishlist', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.white),
              ),
              onTap: () {}



          ),Container(
            //padding: EdgeInsets.only(top: 180,),
            child: ListTile(
                leading: Image.asset('assets/setting.png',height: 22),
                title: Text('Setting', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Setting()));

                }
            ),
          ),
          Container(
            //padding: EdgeInsets.only(top: 180,),
            child: ListTile(
                leading: Image.asset('assets/privacy.png',height: 22),
                title: Text('Privacy', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Privacy()));

                }
            ),
          ),

        ],
      ),


    ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Discover,add and Swap',style: TextStyle(fontSize: 22.89,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Medium',color: Color(0xffF8F8F8)
            ),

            ),

          ),Container(
            padding: EdgeInsets.all(10),
            child: Text('Your Digital Crypto',style: TextStyle(fontSize: 38,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-SemiBold',color: Color(0xffFCFCFC)),),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(25),
                child: Text('Featured Crypto',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Medium'),),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  onTap: () {

                  },
                  child: Text('View all',style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 1,bottom: 60,),

            height: MediaQuery.of(context).size.height/1.7,

            width: MediaQuery.of(context).size.width/0.7,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Cryptolist.length,
                itemBuilder: (BuildContext context, int i){
                  return Padding(
                      padding: EdgeInsets.all(60),
                      child: Container(
                        width: 293,
                      height: 373,
                      padding: EdgeInsets.all(10),

                  decoration: BoxDecoration(

                  color: i%2==0?Color(0xffBDCADB):Color(0xffBDDBC9),

                  border: Border.all(width: 2,color: Color(0xffEFEEFC)
                  ),
                  borderRadius: BorderRadius.circular(35.95),
                  ),
                        child: GestureDetector(
                        onTap:(){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Coinperformance()));

                        },
                          child: Column(
                            children: [


                              Container(

                                child: Image.network("${Cryptolist[i].icon}"),
                                width: 200,
                                height: 200,
                                padding: EdgeInsets.only(left: 10,bottom: 50),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 2,right: 160),
                                child: Column(

                                  children: [

                                    Text("${Cryptolist[i].fullName}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15.58,color: Color(0xff121212)
                                    ),
                                    ),

                                    //  Padding(
                                    //    padding: const EdgeInsets.only(left: 5,right: 60,top: 15),
                                    //    child: Text("${Cryptolist[i].symbol}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,color: Color(0xff848484)
                                    //    ),
                                    // ),
                                    //  ),
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Text("\$${Cryptolist[i].rate}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Color(0xff595959)
                                    ),
                                    ),
                                  ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${Cryptolist[i].diffRate}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,color: Color(0xff02BA36)
                                      ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),

                            ],
                          ),


                        ),

                  ),


                  );

              }
            ),

          ),
          // Container(
          //   padding: EdgeInsets.only(top: 20,bottom: 40),
          //
          //   height: MediaQuery.of(context).size.height/1.5,
          //
          //   width: MediaQuery.of(context).size.width/0.7,
          //   child: ListView.builder(
          //     scrollDirection: Axis.vertical,
          //     itemCount: Cryptolist.length,
          //       itemBuilder: (BuildContext context, int i){
          //         return Padding(
          //           padding: EdgeInsets.all(20),
          //           child: Container(
          //             padding: EdgeInsets.all(10),
          //             decoration: BoxDecoration(
          //
          //               color: i%2==0?Color(0xffE4E8FD):Color(0xffF5E4FD),
          //
          //               border: Border.all(width: 2,color:Color(0xffEFEEFC)
          //               ),
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: GestureDetector(
          //             onTap: (){},
          //             ),
          //           ),
          //         );
          //       }
          //   ),
          // )
      ]
      ),



    );
  }
    }







