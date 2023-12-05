import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:newproject/api_config.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'indexmodels/CryptoIndex.dart';
import 'localization/app_localizations.dart';

class ChartPage extends StatefulWidget{
  double? cryptoCoin;
  String name;
  double? rate;
  String? perRate;
  double? cap;
  double? volume;
  String? symbol;
  String? differRate;

  ChartPage(this.cryptoCoin, this.name, this.rate, this.perRate, this.cap,this.volume,this.differRate,{super.key});


  @override
  State<ChartPage> createState() => _ChartPageState();
}
class _ChartPageState extends State<ChartPage> {
  bool loading = false;
  List<CryptoIndex> cryptoList = [];
  num _size = 0;
  double diffRate = 0.0;
  String cryptoName = '';
  double rate = 0.0;
  double totalMarketCap = 0.0;
  double totalVolume = 0.0;
  double totalCoins = 0.0;
  double percentRate = 0.0;
  String coinLable = "";
  CryptoIndex? selectedCrypto;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    callCryptoIndex();
    super.initState();
    percentRate = double.parse(widget.perRate!.replaceAll("%", "").replaceAll("-", ""));
    print(percentRate);
    print(percentRate);
    if(double.parse(widget.perRate!.replaceAll("%", ""))>=0){
      coinLable = "Profit";
    } else {
      coinLable = "Loss";
    }
    totalCoins = (widget.rate!) * (widget.cryptoCoin!);
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
          print(cryptoList[i].volume);
          print(totalVolume);
          print(cryptoList[i].name);
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
      backgroundColor:const Color(0xffDEEBE8) ,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        elevation: 0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () async {
            sharedPreferences = await SharedPreferences.getInstance();
            setState(() {
              sharedPreferences!.setInt("index", 1);
              sharedPreferences!.commit();
            });
            Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
          },
        ),
        title:  Text(AppLocalizations.of(context)!.translate("bitai-21")!,style:GoogleFonts.inter(textStyle:const TextStyle(
          fontSize: 32,fontWeight: FontWeight.w700,color: Color(0xff2C383F)),
        ),),
      ),
      body:SingleChildScrollView(
          child: Column(
            children: [
    const SizedBox(height: 40,),
    Image.asset('assets/coins_image.png'),

    const SizedBox(height: 40,),
              loading ? const Center(
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
     Padding(padding: const EdgeInsets.only(right: 160,top: 10),
    child: Text(AppLocalizations.of(context)!.translate("bitai-1")!,style:GoogleFonts.inter(textStyle:const TextStyle(
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
                  child: Image.asset('assets/Monero.png'),
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 40,top: 20),
                    child: Text("\$${totalCoins.toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 26, color: Color(0xff17171A)),
                    ),),
              ),
              Padding(padding: const EdgeInsets.only(left: 2,top: 25),
              child:Text(widget.name, style: GoogleFonts.inter(textStyle:const TextStyle(
                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A)),
              ),),
              ),
            ],
          ),
          Row(
            children: [
              Padding(padding: const EdgeInsets.only(left: 25,top: 10),
              child:Text("${widget.cryptoCoin}", style: GoogleFonts.inter(textStyle:const TextStyle(
                   fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff37474F))
              ),),
              ),
              const SizedBox(width: 90,),
              Container(
                height: 51,width: 142,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xffEBEDED),
                ),
                child:Row(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 35),
                    child:FadeInImage.assetNetwork(
                      height: 34, width: 34,
                      placeholder: 'assets/cob.png',
                      image: 'https://assets.coinlayer.com/icons/${widget.name}.png',
                    ),
                    ),
                    const SizedBox(width: 5,),
                    Text(widget.name, style:GoogleFonts.inter(textStyle:const TextStyle(
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
                percent: double.parse(((percentRate/10).toStringAsFixed(1))),
                center: Text(
                  widget.perRate!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color:Color(0xffFFFFFF)),
                ),
                footer: Text(coinLable,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,color:Color(0xffFFFFFF)),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: double.parse(widget.perRate!.replaceAll("%", ""))>=0?Colors.green:Colors.red,
              ),
            ),



              const SizedBox(height: 20,),
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
                          placeholder: 'assets/cob.png',
                          image: 'https://assets.coinlayer.com/icons/${widget.name}.png',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: GoogleFonts.openSans(textStyle:const TextStyle(
                                   fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                              ),),
                              double.parse(widget.differRate!) >=0 ?
                              Text("${double.parse(widget.differRate!).toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:const TextStyle(
                                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff23C562))
                              ),):
                              Text("${double.parse(widget.differRate!).toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle:const TextStyle(
                                   fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xffEA3869)),
                              ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.only(right: 25),
                    child:Text("\$"+widget.rate!.toStringAsFixed(2), style: GoogleFonts.openSans(textStyle: const TextStyle(
                         fontWeight: FontWeight.w400, fontSize: 26, color: Color(0xff292D32))
                    ),textAlign: TextAlign.right,),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 27,top: 20),
                    child:Container(
                      height: 181,width: 155,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24),),
                        color: Color(0xffD9E7E5),
                      ),
                      child: Column(
                          children: [
                          Padding(
                          padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/Ellipse.png'),
                                          fit: BoxFit.fill
                                      )
                                  ),
                                  child:Padding(
                                      padding: const EdgeInsets.only(top:15,bottom:15,left: 2,right: 2),
                                      child: Text("${(widget.volume!*100/totalVolume).toStringAsFixed(1)}%",style:GoogleFonts.inter(textStyle:const TextStyle(
                                          fontSize: 14,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                      ),)
                                  )
                              ),
                            )),
                            const SizedBox(height: 40,),
                             Padding(padding:const EdgeInsets.only(right: 60),
                              child: Text(AppLocalizations.of(context)!.translate("bitai-7")!,style:GoogleFonts.inter(textStyle:const TextStyle(
                                fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303)),
                              ),maxLines: 1,),
                            ),
                            loading?const CircularProgressIndicator(color:Colors.black)
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
                                  percent: widget.volume!/totalVolume,
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('assets/Ellipse.png'),
                                            fit: BoxFit.fill
                                        )
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(top:15,bottom:15,left: 2,right: 2),
                                        child: Text("${(widget.cap!*100/totalMarketCap).toStringAsFixed(1)}%",style:GoogleFonts.inter(textStyle:const TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF)),
                                        ),)
                                    )
                                ),
                              ),
                            ),
                            const SizedBox(height: 40,),
                             Padding(padding:const EdgeInsets.only(right: 30),
                              child: Text(AppLocalizations.of(context)!.translate("bitai-8")!,style:GoogleFonts.inter(textStyle:const TextStyle(
                                fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303)),
                              ),maxLines: 1,),
                            ),


                           loading?const CircularProgressIndicator(color:Colors.black)
                            :Padding(
                              padding: const EdgeInsets.all(10),
                              child: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width/3.10,
                                animation: true,
                                lineHeight: 5,
                                animationDuration: 2500,
                                barRadius:const Radius.circular(8),
                                percent: widget.cap!/totalMarketCap,
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
              const SizedBox(height: 40),
        ],)
        ])
        ])
    ),
            ])
      ),
    );
  }
}

