import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:immediate_connect/models/Cryptodata.dart';
class Cryptopage extends StatefulWidget {
  const Cryptopage({super.key});

  @override
  State<Cryptopage> createState() => _CryptopageState();
}
class _CryptopageState extends State<Cryptopage>{
  List<Cryptodata> Coinslist = [];
  @override
  void initState() {
    CoinsDetails();
    super.initState();
  }
  Future<void>CoinsDetails ()async {
    setState(() {

    });
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD";


    var response = await get(Uri.parse(uri));
    print(response.statusCode);
    final data = json.decode(response.body) as Map;
    print(data);
    if (data['error'] == false) {
      setState(() {
        Coinslist.addAll(data['data']
            .map<Cryptodata>((json) => Cryptodata.fromJson(json))
            .toList());
        print(Coinslist.length);
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
        title: Text('Crypto List',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),

        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 3,bottom: 50,),

        height: MediaQuery.of(context).size.height/1.7,

        width: MediaQuery.of(context).size.width/0.7,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: Coinslist.length,
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

                    },
                    child: Column(
                      children: [

                        Container(

                          child: Image.network("${Coinslist[i].icon}"),
                          width: 200,
                          height: 200,
                          padding: EdgeInsets.only(left: 10,bottom: 50),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 100),
                          child: Text("${Coinslist[i].fullName}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xff121212)),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 140),
                          child: Text("${Coinslist[i].diffRate}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,color: Color(0xff02BA36)),),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 90),
                          child: Text("\$${Coinslist[i].rate}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Color(0xff595959)),),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Container(
                                width: 142,
                                padding: EdgeInsets.only(top: 40,right: 40),
                                child: Image.asset('assets/addc.png'),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Container(
                                width: 52,
                                padding: EdgeInsets.only(top: 30),
                                child: Image.asset('assets/wishlist2.PNG'),
                              ),
                            ),


                          ],
                        )

                      ],
                    ),

                  ),
                ),
              );
            }

        ),
      ),
    );
  }

}