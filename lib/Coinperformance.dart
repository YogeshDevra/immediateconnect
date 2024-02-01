import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/models/Cryptodata.dart';
import 'package:immediate_connect/trends.dart';
class Coinperformance extends StatefulWidget {
  const Coinperformance({super.key});

  @override
  State<Coinperformance> createState() => _CoinperformanceState();
}
class _CoinperformanceState extends State<Coinperformance>{
  List<Cryptodata> Performancelist = [];
  double open = 0;
  double volume = 0;
  double close = 0;
  double high = 0;
  double low = 0;
  @override
  void initState() {
    Cryptoperformance();
    super.initState();
  }
  Future<void>Cryptoperformance ()async {
    setState(() {

    });
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";


    var response = await get(Uri.parse(uri));
    print(response.statusCode);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        Performancelist.addAll(data['data']
            .map<Cryptodata>((json) => Cryptodata.fromJson(json))
            .toList());
        print(Performancelist.length);
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
        title: Text('Coin Performance',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),

        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [

              Container(
                padding: EdgeInsets.only(left: 30,top: 50,),
                child: Image.network("${Performancelist[0].icon}",width: 150,height: 181,
                ),
              ),
          Container(

            width: 490,
            height: 490,
            decoration: BoxDecoration(
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

                Container(
                  child: Image.network("${Performancelist[0].icon}",width: 84,height: 84,),
                  padding: EdgeInsets.only(right: 220,top: 28),
                ),
                Container(
                  padding: EdgeInsets.only(),
                  child: Text("${Performancelist[0].fullName}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),),
                ),



                Row(

                  children: [
                    Padding(padding: EdgeInsets.only(left: 260)),
                    Text("\$${Performancelist[0].rate}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)
                    ),
                    ),
                  ],
                ),

                Row(

                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 25,left: 30),
                     child: Text("${'Volume'}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Color(0xffBCBCBC)),),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(right: 30),
                      child: Text("${volume}",style: TextStyle(fontSize: 16,color: Colors.green),),
                    ),
                  ],
                ),Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,
                ),

                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30,top: 30)),
                    Text("Open",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)
                    ),
                    ),Padding(padding: EdgeInsets.only(left: 260)),
                    Text("${open}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),)
                  ],
                ),
                Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30,top: 30)),
                    Text('Close',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)
                    ),
                    ),Padding(padding: EdgeInsets.only(left: 260)),
                    Text("${close}",style: TextStyle(fontSize:16,fontWeight: FontWeight.w400,color: Colors.green ),)
                  ],
                ),
                Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30,top: 30)),
                    Text('High',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)
                    ),
                    ),Padding(padding: EdgeInsets.only(left: 240)),
                    Text("${Performancelist[0].high}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.green),)
                  ],
                ), Divider(thickness: 1,color: Color(0xffA3A3A3),indent: 30,endIndent: 30,
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 30,top: 30)),
                    Text("Low",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xffBCBCBC)
                    ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 260)),
                    Text("${low}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.green),
                    ),

                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20,)),
                Row(
                  children: [
                    InkWell(
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.only(left: 30,top: 25),
                        child: Text('+ Add Coin',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF),fontFamily: 'Gilroy-Bold'),),

                        width: 155,
                        height: 70,

                        decoration: BoxDecoration(

                            color: Color(0xff5C428F),
                            borderRadius: BorderRadius.circular(19)
                        ),
                      ),
                    ),

                    Spacer(),
                    InkWell(

                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Trends()));

                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 30,top: 25),
                        child: Text('View Trends',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: Color(0xffFFFFFF,),fontFamily: 'Manrope'),),
                        width: 155,
                        height: 70,

                        decoration: BoxDecoration(
                            color: Color(0xff777E90),
                            borderRadius: BorderRadius.circular(19)
                        ),
                      ),
                    ),
                  ],
                ),


              ],

            ),
          ),
         
        ]
      )
    );









  }}