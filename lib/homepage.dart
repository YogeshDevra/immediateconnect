import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:newproject/api_config.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MorePage.dart';
import 'indexmodels/CryptoIndex.dart';
import 'localization/app_localizations.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  bool loading = false;
  List<CryptoIndex> cryptoList = [];
  num _size = 0;
  double totalMarketCap = 0.0;
  double totalVolume = 0.0;

  @override
  void initState() {
    callCryptoIndex();
    super.initState();
  }
  Future<void> callCryptoIndex() async {
    setState(() {
      loading = true;
    });
    var uri = '${api_config.ApiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    print(uri);
    if (await api_config.internetConnection()) {
      try {
    var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
    if(response.statusCode == 200) {
    print(response.statusCode);
    print(response.statusCode == 200);
    final data = json.decode(response.body);// as Map;
    print(data);
    if(mounted) {
      if (data['error'] == false) {
        setState(() {
          cryptoList.addAll(
              data['data'].map<CryptoIndex>((json) =>
                  CryptoIndex.fromJson(json)));
          _size = _size + data['data'].length;
        });
        print(cryptoList.length);
        for(int i=0; i<cryptoList.length;i++){
          totalMarketCap = totalMarketCap + cryptoList[i].cap!;
          totalVolume = totalVolume + cryptoList[i].volume!;
        }
        loading = false;
      } else {
        api_config.toastMessage(message:'Under Maintenance');
        setState(() {
          loading = false;
        });
      }
    }
  }else {
      api_config.toastMessage(message: 'Under Maintenance');
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
      api_config.toastMessage(message: 'No Internet');
      setState(() {
        loading = false;
      });
    }
    api_config.internetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          AppBar(
            centerTitle: true,
            title:Text(AppLocalizations.of(context)!.translate("dashboard")!,style:GoogleFonts.inter(textStyle: TextStyle(
              fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff030303),)
            ),),
          ),
          const SizedBox(height: 40),
          loading ? Center(
              child: CircularProgressIndicator(color: Colors.black))
              :cryptoList.isEmpty
              ? Center(child: Image.asset("assets/No data.png"))
              : Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width/0.4,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:cryptoList.length,
                  itemBuilder: (BuildContext context,int i) {
                    return Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 25,right: 15,top: 5,bottom: 5),
                          child:Container(
                            height: 185,width: 327,
                            decoration:BoxDecoration(
                    image:DecorationImage(
                    image: AssetImage('assets/Group 489.png'),

                    )
                            ),
                          child:Column (
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                      child:Padding(padding: const EdgeInsets.only(left: 20,),
                                        child:Text(cryptoList[i].fullName!, style: GoogleFonts.openSans(textStyle: TextStyle(
                                             fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xffFFFFFF))
                                        ),)
                                        ),),
                                      const SizedBox(width: 110),
                                      Padding(padding: const EdgeInsets.only(top: 20,right: 20),
                                        child: FadeInImage.assetNetwork(
                                          height: 48,width: 48,
                                          placeholder: 'assets/cob.png',
                                          image: cryptoList[i].icon!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.only(left: 20,),
                                      child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("\$${cryptoList[i].rate!.toStringAsFixed(2)}", style:GoogleFonts.openSans(textStyle:TextStyle(
                                             fontWeight: FontWeight.w700, fontSize: 26, color: Color(0xffFFFFFF))
                                        ),),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 20,top: 35),
                                    child:Align(alignment: Alignment.centerLeft,
                                        child:double.parse(cryptoList[i].differRate!) >=0 ?
                                        Text("${double.parse(cryptoList[i].differRate!).toStringAsFixed(2)} %", style:GoogleFonts.openSans(textStyle:TextStyle(
                                             fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xff24FF79))
                                        ),):
                                        Text("${double.parse(cryptoList[i].differRate!).toStringAsFixed(2)} %", style: GoogleFonts.openSans(textStyle:TextStyle(
                                             fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xffEA3869))
                                        ),)
                                    ),
                                  ),
                                ],
                              ),


                            ),

                    ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 27,top: 70),
                              child:Container(
                                height: 181,width: 155,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(24),),
                                  color: Color(0xffD9E7E5),
                                ),
                                child: Column(
                                    children: [
                                            Container(
                                                child:Stack(
                                                  children: [
                    Padding(padding:  EdgeInsets.only(right: 60,top: 20),
                    child: Image.asset('assets/Ellipse.png'),),
                                                     Column(
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(left:2,top: 37),
                                           child: Text("${(cryptoList[i].volume!*100/totalVolume).toStringAsFixed(1)} %",style:GoogleFonts.inter(textStyle:TextStyle(
                                               fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                           ),)
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                            ),


                                      const SizedBox(height: 40,),
                                       Padding(padding:EdgeInsets.only(right: 60),
                                        child: Text(AppLocalizations.of(context)!.translate("bitai-7")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                          fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303),)
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: LinearPercentIndicator(
                                            width: MediaQuery.of(context).size.width/3.10,
                                            animation: true,
                                            lineHeight: 5,
                                            barRadius:const Radius.circular(8),
                                            animationDuration: 2500,
                                            percent: cryptoList[i].volume!/totalVolume,
                                            linearStrokeCap: LinearStrokeCap.roundAll,
                                            progressColor: const Color(0xffEA3869),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),),
                            Padding(padding: const EdgeInsets.only(left: 20,right: 20,top: 70),
                              child: Container(
                                height: 181,width: 155,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(24),),
                                  color: Color(0xffE6E2E6),
                                ),
                                child: Column(
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            Padding(padding: const EdgeInsets.only(right: 60,top: 20),
                                        child: Image.asset('assets/Ellipse.png'),
                                      ),
                                            Column(
                                              children: [
                                                Padding(padding: EdgeInsets.only(left:5,top: 37),
                                                    child: Text("${(cryptoList[i].cap!*100/totalMarketCap).toStringAsFixed(1)} %",style:GoogleFonts.inter(textStyle:TextStyle(
                                                        fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                                    ),)
                                                ),
                                              ],
                                            )
                                      ])
                    ),

                                      const SizedBox(height: 40,),
                                      Padding(padding:EdgeInsets.only(right: 30),
                                        child: Text(AppLocalizations.of(context)!.translate("bitai-8")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                          fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303),)
                                        ),),
                                      ),

                                       Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: LinearPercentIndicator(
                                          width: MediaQuery.of(context).size.width/3.10,
                                          animation: true,
                                          lineHeight: 5,
                                          animationDuration: 2500,
                                          barRadius:Radius.circular(8),
                                          percent: cryptoList[i].cap!/totalMarketCap,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          progressColor: const Color(0xff10A40D),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }
              )
          ),


        ],
      ),


    );


  }

}

