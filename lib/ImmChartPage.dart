import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:immediateconnectapp/ImmApiConfig.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ImmConnectModels/ImmCrypto.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';

class ImmChartPage extends StatefulWidget{
  double? cryptoCoin;
  String name;
  double? rate;
  String? perRate;
  double? cap;
  double? volume;
  String? symbol;
  String? differRate;

  ImmChartPage(this.cryptoCoin, this.name, this.rate, this.perRate, this.cap,this.volume,this.differRate,{super.key});


  @override
  State<ImmChartPage> createState() => _ImmChartPageState();
}
class _ImmChartPageState extends State<ImmChartPage> {
  bool isloading = false;
  List<ImmCrypto> ImmcryptoList = [];
  num size = 0;
  double totalMarCap = 0.0;
  double totalVol = 0.0;
  double totalCoin = 0.0;
  double _percentRate = 0.0;
  String coinsLable = "";
  SharedPreferences? imSharedPreferences;

  @override
  void initState() {
    setState(() {
      isloading = true;
    });
    callImmCrypto();
    super.initState();
    _percentRate = double.parse(widget.perRate!.replaceAll("%", "").replaceAll("-", ""));
    print(_percentRate);
    print(_percentRate);
    if(double.parse(widget.perRate!.replaceAll("%", ""))>=0){
      coinsLable = "Profit";
    } else {
      coinsLable = "Loss";
    }
    totalCoin = (widget.rate!) * (widget.cryptoCoin!);
  }

  Future<void> callImmCrypto() async {
    setState(() {
      isloading = true;
    });
    var uri = '${ImmApiConfig.ImmApiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    print(uri);
    if (await ImmApiConfig.imm_internetConnection()) {
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
          ImmcryptoList.addAll(
              data['data'].map<ImmCrypto>((json) =>
                  ImmCrypto.fromJson(json)));
          size = size + data['data'].length;
        });
        print(ImmcryptoList.length);
        for(int i=0; i<ImmcryptoList.length;i++){
          totalMarCap = totalMarCap + ImmcryptoList[i].cap!;
          totalVol = totalVol + ImmcryptoList[i].volume!;
          print(ImmcryptoList[i].volume);
          print(totalVol);
          print(ImmcryptoList[i].name);
        }
        isloading = false;
      } else {
        ImmApiConfig.imm_toastMessage(message:'Under Maintenance');
        setState(() {
          isloading = false;
        });
      }
    }
  }else {
      ImmApiConfig.imm_toastMessage(message: 'Under Maintenance');
      setState(() {
        isloading = false;
      });
    }
      } on TimeoutException catch(e) {
        setState(() {
          isloading = false;
        });
        print(e);
      }
      catch (e) {
        setState(() {
          isloading = false;
        });
      }
    } else {
      ImmApiConfig.imm_toastMessage(message: 'No Internet');
      setState(() {
        isloading = false;
      });
    }
    ImmApiConfig.imm_internetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffDEEBE8) ,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () async {
            imSharedPreferences = await SharedPreferences.getInstance();
            setState(() {
              imSharedPreferences!.setInt("index", 1);
              imSharedPreferences!.commit();
            });
            Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
          },
        ),
        title:  Text(ImmAppLocalizations.of(context)!.translate("bitai-21")!,style:GoogleFonts.inter(textStyle:TextStyle(
          fontSize: 32,fontWeight: FontWeight.w700,color: Color(0xff2C383F)),
        ),),
      ),
      body:SingleChildScrollView(
          child: Column(
            children: [
    const SizedBox(height: 40,),
    Image.asset('images/imCoins_image.png'),

    const SizedBox(height: 40,),
              isloading ? Center(
                  child: CircularProgressIndicator(color: Colors.black))
    :Container(
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(32),
    topRight:Radius.circular(32),),
    color: Color(0xffFFFFFF),
    ),
    child: Column(
        children: [
     Padding(padding: EdgeInsets.only(right: 160,top: 10),
    child: Text(ImmAppLocalizations.of(context)!.translate("bitai-1")!,style:GoogleFonts.inter(textStyle:TextStyle(
    fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff2C383F)),
    ),),
    ),
    Padding(padding: const EdgeInsets.only(left: 2,top: 20),
    child: Container(
    height: 132,width: 327,
    decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    border: Border.all(color: const Color(0xffE6E6E6)),
    ),
    child: Column(
        children: [
          Row(
            children: [
              Padding(padding: const EdgeInsets.only(left:20,right: 20,top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset('images/imMonero.png'),
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 40,top: 20),
                    child: Text("\$${totalCoin.toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 26, color: Color(0xff17171A)),
                    ),),
              ),
              Padding(padding: EdgeInsets.only(left: 2,top: 25),
              child:Text(widget.name, style: GoogleFonts.inter(textStyle:TextStyle(
                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A)),
              ),),
              ),
            ],
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 25,top: 10),
              child:Text("${widget.cryptoCoin}", style: GoogleFonts.inter(textStyle:TextStyle(
                   fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff37474F))
              ),),
              ),
              SizedBox(width: 100,),
              Container(
                height: 51,width: 142,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xffEBEDED),
                ),
                child:Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 35),
                    child:FadeInImage.assetNetwork(
                      height: 34, width: 34,
                      placeholder: 'images/tempCob.png',
                      image: 'https://assets.coinlayer.com/icons/${widget.name}.png',
                    ),
                    ),
                    SizedBox(width: 5,),
                    Text(widget.name, style:GoogleFonts.inter(textStyle:TextStyle(
                         fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A))
                    ),),
                  ],
                )
              ),

            ],
          )
        ],
      )


    ),
    ),
      const SizedBox(height: 25,),
      Stack(
        children: [
          Column(
            children: [
              Container(
            height: 156,width: 327,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: Color(0xff37474F),
            ),
    alignment: Alignment.center,
                child: CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 15.0,
                animation: true,
                percent: double.parse(((_percentRate/10).toStringAsFixed(1))),
                center: Text(
                  widget.perRate!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color:Color(0xffFFFFFF)),
                ),
                footer: Text(coinsLable,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,color:Color(0xffFFFFFF)),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: double.parse(widget.perRate!.replaceAll("%", ""))>=0?Colors.green:Colors.red,
              ),
            ),



              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left:30,right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        FadeInImage.assetNetwork(
                          height: 48, width: 48,
                          placeholder: 'images/tempCob.png',
                          image: 'https://assets.coinlayer.com/icons/${widget.name}.png',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: GoogleFonts.openSans(textStyle:TextStyle(
                                   fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                              ),),
                              double.parse(widget.differRate!) >=0 ?
                              Text("${double.parse(widget.differRate!).toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:TextStyle(
                                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff23C562))
                              ),):
                              Text("${double.parse(widget.differRate!).toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:TextStyle(
                                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xffEA3869)),
                              ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 25),
                    child:Text("\$"+widget.rate!.toStringAsFixed(2), style: GoogleFonts.openSans(textStyle: TextStyle(
                         fontWeight: FontWeight.w400, fontSize: 26, color: Color(0xff292D32))
                    ),textAlign: TextAlign.right,),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 27,top: 20),
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
                                      child: Image.asset('images/imEllipse.png'),),
                                    Column(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left:10,top: 37),
                                            child: Text("${(widget.volume!*100/totalVol).toStringAsFixed(1)} %",style:GoogleFonts.inter(textStyle:TextStyle(
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
                              child: Text(ImmAppLocalizations.of(context)!.translate("bitai-7")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303)),
                              ),),
                            ),
                            isloading?CircularProgressIndicator(color:Colors.black)
                           : Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width/3.10,
                                  animation: true,
                                  lineHeight: 5,
                                  barRadius:const Radius.circular(8),
                                  animationDuration: 2500,
                                  percent: widget.volume!/totalVol,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: const Color(0xffEA3869),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),),
                  Padding(padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
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
                                        child: Image.asset('images/imEllipse.png'),
                                      ),
                                      Column(
                                        children: [
                                          Padding(padding: EdgeInsets.only(left:5,top: 37),
                                              child: Text("${(widget.cap!*100/totalMarCap).toStringAsFixed(1)} %",style:GoogleFonts.inter(textStyle:TextStyle(
                                                  fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF)),
                                              ),)
                                          ),
                                        ],
                                      )
                                    ])
                            ),

                            const SizedBox(height: 40,),
                             Padding(padding:EdgeInsets.only(right: 30),
                              child: Text(ImmAppLocalizations.of(context)!.translate("bitai-8")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303)),
                              ),),
                            ),


                            isloading?CircularProgressIndicator(color:Colors.black)
                            :Padding(
                              padding: const EdgeInsets.all(10),
                              child: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width/3.10,
                                animation: true,
                                lineHeight: 5,
                                animationDuration: 2500,
                                barRadius:Radius.circular(8),
                                percent: widget.cap!/totalMarCap,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: const Color(0xff10A40D),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
        ],)
        ])
        ])
    ),
            ])
      ),
    );
  }
}

