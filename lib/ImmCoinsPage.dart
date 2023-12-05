import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immediateconnectapp/ImmApiConfig.dart';
import 'package:immediateconnectapp/ImmConnectModels/ImmCrypto.dart';

import 'ImmChartPage.dart';
import 'ImmConnectDatabase.dart';
import 'ImmConnectModels/ImmPortfolioCrypto.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';

import 'package:http/http.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImmCoinsPage extends StatefulWidget{
  const ImmCoinsPage ({super.key});

  @override
  State<ImmCoinsPage> createState() => _ImmCoinsPageState();
}
class _ImmCoinsPageState extends State<ImmCoinsPage>{
  final immDatabase = ImmConnectDatabase.instance;
  List<ImmPortfolioCrypto> portfolio = [];
  TextEditingController? coinAddEditingController = TextEditingController();
  List<ImmCrypto> ImmcryptoList = [];
  ImmCrypto? selectCrypto;
  bool isloading = false;
  num size = 0;
  double calculatedValue = 0.0;
  int selectedValue = 20;
 // int ? _crypto;

  @override
  void initState() {
    isloading = true;
    coinAddEditingController?.text = selectedValue.toString();
    immDatabase.queryAllRows().then((notes) {
      for (var note in notes) {
        portfolio.add(ImmPortfolioCrypto.fromMap(note));
      }
      setState(() {});
    });
    super.initState();
    callImmCrypto();
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
    print(response);
    final data = json.decode(response.body) as Map;
    print(data);
    if(mounted) {
      if (data['error'] == false) {
        setState(() {
          ImmcryptoList.addAll(
              data['data'].map<ImmCrypto>((json) =>
                  ImmCrypto.fromJson(json)));
          size = size + data['data'].length;
        });
        isloading = false;
      } else {
        ImmApiConfig.imm_toastMessage(message:'Under Maintenance');
        setState(() {
          isloading = false;
        });
      }
    }
    print("ImmcryptoList : ${ImmcryptoList.length}");
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffDEEBE8),
        title: Text(ImmAppLocalizations.of(context)!.translate("bitai-27")!,style:GoogleFonts.inter(textStyle:const TextStyle(
            fontSize: 32,fontWeight: FontWeight.w700,color: Color(0xff2C383F))
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child:Container(
        color: const Color(0xffDEEBE8),
      child: Column(
        children: [
          // Row(
          //   children: [
          //      Padding(padding: EdgeInsets.only(left:150,right:140,top: 45),
          //     child: Text(ImmAppLocalizations.of(context)!.translate("bitai-27")!,style:GoogleFonts.inter(textStyle:TextStyle(
          //       fontSize: 32,fontWeight: FontWeight.w700,color: Color(0xff2C383F))
          //     ),),
          //     )
          //   ],
          // ),
          const SizedBox(height: 40,),
          Image.asset('images/imCoins_image.png'),

           SizedBox(height: 40,),
          isloading ? Center(
              child: CircularProgressIndicator(color: Colors.black))
              :ImmcryptoList.isEmpty
              ? Center(child: Image.asset("images/imNoData.png"))
              : Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32),
                  topRight:Radius.circular(32),),
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                child: Text(ImmAppLocalizations.of(context)!.translate("bitai-1")!,style:GoogleFonts.inter(textStyle: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff2C383F)),
                ),),
                ),
                 Padding(
                   padding: const EdgeInsets.only(left:30,right:30,top:5),
                child: Container(
                  // height: 142,width: 327,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    border: Border.all(color: const Color(0xffE6E6E6)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: const EdgeInsets.all(10,),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Image.asset('images/imImage.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Text("\$${calculatedValue.toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle: TextStyle(
                                   fontSize: 26, fontWeight: FontWeight.w600,)
                                )),
                              ],
                            ),
                          ),
                          Text("${selectCrypto==null?'':selectCrypto!.symbol!}", style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff030303)
                            ),)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 20,),
                              child:Align(
                                alignment: Alignment.topLeft,
                                child:SizedBox(
                                  width: 80,
                               child:
                               TextFormField(
                                  style:GoogleFonts.inter(
                                    textStyle:TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 26, color: Color(0xff17171A)
                                    ) ),
                                  controller: coinAddEditingController,
                                 keyboardType: TextInputType.numberWithOptions(signed: true,decimal: false),
                                 textInputAction: TextInputAction.done,
                                 decoration: InputDecoration(
                                   focusedBorder: InputBorder.none,
                                   enabledBorder: InputBorder.none,
                                   disabledBorder: InputBorder.none,
                                   hintText: ImmAppLocalizations.of(context)!.translate("bitai-28")!,
                                 ),
                                 inputFormatters: <TextInputFormatter>[
                                   LengthLimitingTextInputFormatter(4),
                                   FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                 ],
                                 onChanged: (value){
                                   setState(() {
                                     calculatedValue = double.parse(value) * selectCrypto!.rate!;
                                   });
                                 },

                                ))
                              )
                          ),
                          //Text(""),
                          SizedBox(width:60),
                          Container(
                          child: Stack(
                          children: [
                            Container(
                            height: 51,width: 142,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: Color(0xffEBEDED),
                            ),
                          ),
                            Padding(padding: EdgeInsets.only(left: 100,top: 7),
                            child: Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xffFFC727)
                              ),
                            ),),
                            Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<ImmCrypto>(
                                menuMaxHeight: MediaQuery.of(context).size.height/2,
                            borderRadius: BorderRadius.circular(25),
                            dropdownColor: const Color(0xffffffff),
                            style: const TextStyle(),
                                hint:Text('Select Crypto'),
                                value: selectCrypto,
                                alignment: Alignment.centerLeft,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectCrypto = newValue!;
                                    calculatedValue = selectCrypto!.rate! * double.parse(coinAddEditingController!.text);
                                  });
                                },
                                items: ImmcryptoList.map((ImmCrypto _crypto) {
                                  return DropdownMenuItem<ImmCrypto>(
                                    alignment: Alignment.center,
                                    value: _crypto,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        FadeInImage.assetNetwork(
                                          height: 35, width: 35,
                                          placeholder: 'images/tempCob.png',
                                          image: _crypto.icon!,
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 5),
                                        child:Text(_crypto.symbol!,style: GoogleFonts.openSans(textStyle:TextStyle(color: Color(0xff17181A),
                                            fontSize: 16, fontWeight: FontWeight.w500))),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),



                            )


                            ),
                            ),

                          ]))


                        ],
                      ),

                    ],
                  ),

                ),
                 ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left:210,right:40,top:5,bottom:5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        _addAllSaveCoinsToLocalStorage(selectCrypto!);
                      },
                                    child:Container(
                    // height: 30,width: 116,
                    decoration: const BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(7)),
                      color: Color(0xff37474F),
                    ),
                    alignment: Alignment.center,
                    child:  Text(ImmAppLocalizations.of(context)!.translate("bitai-3")!,textAlign:TextAlign.center,style:GoogleFonts.inter(textStyle:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xffFFFFFF)),
                    ),),
                                    ),
                                    ),
                  ),
    ),
                const SizedBox(height: 10,),
                Center(
                  child: Container(
                    // height: 192,width: 327,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: Color(0xffE6E6E6)
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                         Text(ImmAppLocalizations.of(context)!.translate("recommend")!,textAlign: TextAlign.center,style:GoogleFonts.inter(textStyle:TextStyle(
                          fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff030303)),
                        ),),
                        const SizedBox(height: 15,),
                        Container(
                          // height: 139,width: 309,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            color: Color(0xff37474F)
                          ),
                          child: Column(
                            children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 30),
                                  Padding(padding: EdgeInsets.only(top: 30),
                                  child:Text(ImmAppLocalizations.of(context)!.translate("bitai-4")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                    fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),
                                  ),)
                                  ),
                                  // SizedBox(width: 60,),
                                  Padding(padding: EdgeInsets.only(top: 30),
                                  child: Text(ImmAppLocalizations.of(context)!.translate("perfect")!,style:GoogleFonts.inter(textStyle:TextStyle(
                                    fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),
                                  ),),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30,),
                              Padding(padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
                              child:Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 41,width: 287,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: Color(0xff27343B)
                                      ),
                                    ),
                                    Row(
                                      children: [
                                         SizedBox(width: 25,),
                                        Padding(padding: EdgeInsets.only(right: 10,top: 8),
                                            child:
                                            Container(
                                                height: 25,width: 240,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                   // color: Color(0xffFFC727)
                                                ),
                                                child: DropdownButtonHideUnderline(
                                                child:DropdownButton<int>(
                                                  dropdownColor:Color(0xff27343B),
                                                  icon:Icon(
                                                  Icons.arrow_drop_down_circle,
                                                    color: Color(0xffFFC727),
                                                  ),
                                                 // iconEnabledColor: Color(0xffFFC727),
                                                  isExpanded: true,
                                                  value: selectedValue,
                                                  onChanged: (int? newValue) {
                                                    setState(() {
                                                      selectedValue = newValue!;
                                                      coinAddEditingController!.text = selectedValue.toString();
                                                    });
                                                  },
                                                  items: [20, 50, 70, 100, 150, 200, 500, 700, 800, 900, 1100, 1200].map<DropdownMenuItem<int>>((int value) {
                                                    return DropdownMenuItem<int>(
                                                      value: value,
                                                      child: Text('$value',style: TextStyle(color:Colors.white),),
                                                    );
                                                  }).toList(),
                                                )

                                            )),
                                        )

                                      ],
                                    )

                                  ],
                                ),
                              ),
                              )




                            ],
                          ),

                        )

                      ],
                    ),
                  ),
                )
              ],

            )
          ),
        ],
      ),),
      ),
    );
  }
  _addAllSaveCoinsToLocalStorage(ImmCrypto cbitIndex) async {
    print(portfolio.length);
    if (portfolio.isNotEmpty) {
      ImmPortfolioCrypto? bitcoinLocal = portfolio.firstWhereOrNull((element) => element.name == cbitIndex.symbol);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          ImmConnectDatabase.columnName: cbitIndex.symbol,
          ImmConnectDatabase.columnPerRate: cbitIndex.perRate,
          ImmConnectDatabase.columnRateDuringAdding: cbitIndex.rate,

          ImmConnectDatabase.columnCoinsQuantity:
          double.parse(coinAddEditingController!.value.text) +
              bitcoinLocal.numberOfCoins,
          ImmConnectDatabase.columnTotalValue:
          double.parse(coinAddEditingController!.value.text) *
              (cbitIndex.rate!) +
              bitcoinLocal.totalValue,
        };
        final id = await immDatabase.update(row);
        print('inserted row id: $id');
        Fluttertoast.showToast(
            msg:
            "${cbitIndex.symbol} ${ImmAppLocalizations.of(context)!.translate("bitai-34")!}",
            toastLength: Toast.LENGTH_SHORT,
            gravity:
            ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color(0xff23C562),
            textColor: const Color(0xffffffff),
            fontSize: 16.0);
      } else {
        Map<String, dynamic> row = {
          ImmConnectDatabase.columnName: cbitIndex.symbol,
          ImmConnectDatabase.columnPerRate: cbitIndex.perRate,
          ImmConnectDatabase.columnRateDuringAdding: cbitIndex.rate,
          ImmConnectDatabase.columnCoinsQuantity:
          double.parse(coinAddEditingController!.value.text),
          ImmConnectDatabase.columnTotalValue:
          double.parse(coinAddEditingController!.value.text) *
              (cbitIndex.rate!),
        };
        final id = await immDatabase.insert(row);
        print('inserted row id: $id');
        Fluttertoast.showToast(
            msg:
            "${cbitIndex.symbol} ${ImmAppLocalizations.of(context)!.translate("bitai-33")!}",
            toastLength: Toast.LENGTH_SHORT,
            gravity:
            ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color(0xff23C562),
            textColor: const Color(0xffffffff),
            fontSize: 16.0);
      }
    } else {
      Map<String, dynamic> row = {
        ImmConnectDatabase.columnName: cbitIndex.symbol,
        ImmConnectDatabase.columnPerRate: cbitIndex.perRate,
        ImmConnectDatabase.columnRateDuringAdding: cbitIndex.rate,
        ImmConnectDatabase.columnCoinsQuantity:
        double.parse(coinAddEditingController!.text),
        ImmConnectDatabase.columnTotalValue:
        double.parse(coinAddEditingController!.value.text) *
            (cbitIndex.rate!),
      };
      final id = await immDatabase.insert(row);
      print('inserted row id: $id');
      Fluttertoast.showToast(
          msg:
          "${cbitIndex.symbol} ${ImmAppLocalizations.of(context)!.translate("bitai-33")!}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xff23C562),
          textColor: const Color(0xffffffff),
          fontSize: 16.0);
    }
    print('cap');
    print(cbitIndex.cap);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ImmChartPage(double.parse(coinAddEditingController!.value.text), cbitIndex.symbol!, cbitIndex.rate, cbitIndex.perRate!,cbitIndex.cap!,cbitIndex.volume!,cbitIndex.differRate!)));
  }

}
