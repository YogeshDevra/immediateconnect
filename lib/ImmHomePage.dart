import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:immediateconnectapp/ImmApiConfig.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'ImmConnectModels/ImmCrypto.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';

class ImmHomePage extends StatefulWidget{
  const ImmHomePage({super.key});

  @override
  State<ImmHomePage> createState() => _ImmHomePageState();
}
class _ImmHomePageState extends State<ImmHomePage>{
  bool isloading = false;
  List<ImmCrypto> ImmcryptoList = [];
  num size = 0;
  double totalMarCap = 0.0;
  double totalVol = 0.0;

  @override
  void initState() {
    callImmCrypto();
    super.initState();
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
      appBar : AppBar(
        centerTitle: true,
        title:Text(ImmAppLocalizations.of(context)!.translate("dashboard")!,style:GoogleFonts.inter(textStyle: TextStyle(
          fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff030303),)
        ),),
      ),
      body:isloading ? Center(
          child: CircularProgressIndicator(color: Colors.black))
          :ImmcryptoList.isEmpty
          ? Center(child: Image.asset("images/imNoData.png"))
          : Container(
          height: MediaQuery.of(context).size.height/1.5,
          width: MediaQuery.of(context).size.width/0.4,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:ImmcryptoList.length,
              itemBuilder: (BuildContext context,int i) {
                return Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 25,right: 15,top: 5,bottom: 5),
                      child:Container(
                        height: 185,width: 327,
                        decoration:BoxDecoration(
                        image:DecorationImage(image: AssetImage('images/imGroup(1).png'))),
                      child:Column (
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                  child:Padding(padding: const EdgeInsets.only(left: 20,top:5),
                                    child:Text(ImmcryptoList[i].fullName!, style: GoogleFonts.openSans(textStyle: TextStyle(
                                         fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xffFFFFFF))
                                    ),)
                                    ),),
                                  const SizedBox(width: 110),
                                  Padding(padding: const EdgeInsets.only(top: 20,right: 20),
                                    child: FadeInImage.assetNetwork(
                                      height: 48,width: 48,
                                      placeholder: 'images/tempCob.png',
                                      image: ImmcryptoList[i].icon!,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: const EdgeInsets.only(left: 20,),
                                  child:Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("\$${ImmcryptoList[i].rate!.toStringAsFixed(2)}", style:GoogleFonts.openSans(textStyle:TextStyle(
                                         fontWeight: FontWeight.w700, fontSize: 26, color: Color(0xffFFFFFF))
                                    ),),
                                  )
                              ),
                              Padding(padding: EdgeInsets.only(left: 20,top: 35),
                                child:Align(alignment: Alignment.centerLeft,
                                    child: Text("${double.parse(ImmcryptoList[i].differRate!).toStringAsFixed(2)}%", style:GoogleFonts.openSans(textStyle:TextStyle(
                                         fontWeight: FontWeight.w700, fontSize: 14, color: double.parse(ImmcryptoList[i].differRate!) >=0 ?Color(0xff24FF79):Color(0xffEA3869))
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
                                        // Container(
                                        //     decoration: const BoxDecoration(
                                        //       borderRadius: BorderRadius.all(Radius.circular(50)),
                                        //       color: Color(0xff42887C),
                                        //     ),
                                        //     child:Text("${(ImmcryptoList[i].volume!*100/totalVol).toStringAsFixed(1)}%",style:GoogleFonts.inter(textStyle:TextStyle(
                                        //         fontSize: 15,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                        //     ),)
                                        // ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage('images/imEllipse.png'),
                                                  fit: BoxFit.fill
                                              )
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15,bottom:15,left: 2,right: 2),
                                            child: Text("${(ImmcryptoList[i].volume!*100/totalVol).toStringAsFixed(1)}%",style:GoogleFonts.inter(textStyle:TextStyle(
                                                fontSize: 14,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                            ),),
                                          )
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 40,),
                                   Padding(padding:EdgeInsets.only(right: 60),
                                    child: Text(ImmAppLocalizations.of(context)!.translate("bitai-7")!,style:GoogleFonts.inter(textStyle:TextStyle(
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
                                        percent: ImmcryptoList[i].volume!/totalVol,
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
                //                   Container(
                //                     child: Stack(
                //                       children: [
                //                         Padding(padding: const EdgeInsets.only(right: 60,top: 20),
                //                     child: Image.asset('images/imEllipse.png'),
                //                   ),
                //                         Column(
                //                           children: [
                //                             Padding(padding: EdgeInsets.only(left:5,top: 37),
                //                                 child: Text("${(ImmcryptoList[i].cap!*100/totalMarCap).toStringAsFixed(1)} %",style:GoogleFonts.inter(textStyle:TextStyle(
                //                                     fontSize: 15,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                //                                 ),)
                //                             ),
                //                           ],
                //                         )
                //                   ])
                // ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage('images/imEllipse.png'),
                                                  fit: BoxFit.fill
                                              )
                                          ),
                                          child:Padding(
                                              padding: const EdgeInsets.only(top:15,bottom:15,left: 2,right: 2),
                                              child: Text("${(ImmcryptoList[i].cap!*100/totalMarCap).toStringAsFixed(1)}%",style:GoogleFonts.inter(textStyle:TextStyle(
                                                  fontSize: 14,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF))
                                              ),)
                                          )
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40,),
                                  Padding(padding:EdgeInsets.only(right: 30),
                                    child: Text(ImmAppLocalizations.of(context)!.translate("bitai-8")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                      fontSize: 17,fontWeight: FontWeight.w700,color: Color(0xff030303),)
                                    ),maxLines: 1,),
                                  ),

                                   Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width/3.10,
                                      animation: true,
                                      lineHeight: 5,
                                      animationDuration: 2500,
                                      barRadius:Radius.circular(8),
                                      percent: ImmcryptoList[i].cap!/totalMarCap,
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


    );


  }

}

