// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/api_config.dart';
import 'immediateConnect_Database.dart';
import 'chart.dart';
import 'indexmodels/CryptoIndex.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'indexmodels/PortfolioCrypto.dart';
import 'localization/app_localizations.dart';

class CoinsPage extends StatefulWidget{
  const CoinsPage ({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}
class _CoinsPageState extends State<CoinsPage>{
  final database = immediateConnectDatabase.instance;
  List<PortfolioCrypto> portfolios = [];
  TextEditingController? coinAddEditingController = TextEditingController();
  List<CryptoIndex> cryptoList = [];
  CryptoIndex? selectedCrypto;
  bool loading = false;
  num _size = 0;
  double calculateValue = 0.0;
  int _selectedValue = 20;
  List<int> coinQuantityList = [20, 50, 70, 100, 150, 200, 500, 700, 800, 900, 1100, 1200];
  int ? crypto;
  int selectedIndex = 0;

  @override
  void initState() {
    loading = true;
    coinAddEditingController?.text = _selectedValue.toString();
    database.queryAllRows().then((notes) {
      for (var note in notes) {
        portfolios.add(PortfolioCrypto.fromMap(note));
      }
      setState(() {});
    });
  //  setState(() {
    //  coinAddEditingController!.text = coinQuantityList[selectedIndex].toString();
    //});
    super.initState();
    callCryptoIndex();
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
    print(response);
    final data = json.decode(response.body) as Map;
    print(data);
    if(mounted) {
      if (data['error'] == false) {
        setState(() {
          cryptoList.addAll(
              data['data'].map<CryptoIndex>((json) =>
                  CryptoIndex.fromJson(json)));
          _size = _size + data['data'].length;
        });
        loading = false;
      } else {
        api_config.toastMessage(message:'Under Maintenance');
        setState(() {
          loading = false;
        });
      }
    }
    print("cryptoList : ${cryptoList.length}");
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffDEEBE8),
        title: Text(AppLocalizations.of(context)!.translate("bitai-27")!,style:GoogleFonts.inter(textStyle:const TextStyle(
            fontSize: 32,fontWeight: FontWeight.w700,color: Color(0xff2C383F))
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child:Container(
        color: const Color(0xffDEEBE8),
      child: Column(
        children: [
          const SizedBox(height: 40,),
          Image.asset('assets/coins_image.png'),
           const SizedBox(height: 40,),
          loading ? const Center(
              child: CircularProgressIndicator(color: Colors.black))
              :cryptoList.isEmpty
              ? Center(child: Image.asset("assets/No data.png"))
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
                   child: Text(AppLocalizations.of(context)!.translate("bitai-1")!,style:GoogleFonts.inter(textStyle: const TextStyle(
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
                             Padding(
                               padding: const EdgeInsets.all(10),
                               child: Align(
                                 alignment: Alignment.topLeft,
                                 child: Image.asset('assets/Image.png'),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.all(5),
                               child: Row(
                                 children: [
                                   Text("\$${calculateValue.toStringAsFixed(2)}", style: GoogleFonts.inter(textStyle: const TextStyle(
                                        fontSize: 21, fontWeight: FontWeight.w600,)
                                     )),
                                   Text(selectedCrypto==null?'':selectedCrypto!.symbol!, style: GoogleFonts.inter(textStyle: const TextStyle(
                                     fontSize: 21, fontWeight: FontWeight.w600,
                                       ))),
                                 ],
                               ),
                             ),

                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Padding(padding: const EdgeInsets.only(left: 20,),
                                 child:Align(
                                   alignment: Alignment.topLeft,
                                   child:SizedBox(width: 80,
                                  child: TextFormField(
                                     style:GoogleFonts.inter(
                                       textStyle:const TextStyle(
                                         fontWeight: FontWeight.w600, fontSize: 26, color: Color(0xff17171A)
                                       ) ),
                                     controller: coinAddEditingController,
                                    keyboardType: const TextInputType.numberWithOptions(signed: true,decimal: false),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!.translate("bitai-28")!,
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        calculateValue = double.parse(value) * selectedCrypto!.rate!;
                                      });
                                    },
                                   ))
                                 )
                             ),
                             //Text(""),
                             const SizedBox(width:60),
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
                               Padding(padding: const EdgeInsets.only(left: 102,top: 10),
                               child: Container(
                                 height: 25,
                                 width: 25,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: const Color(0xffFFC727)
                                 ),
                               ),),
                               Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                               child: DropdownButtonHideUnderline(
                                 child: DropdownButton<CryptoIndex>(
                                   menuMaxHeight: MediaQuery.of(context).size.height/2,
                               borderRadius: BorderRadius.circular(25),
                               dropdownColor: const Color(0xffffffff),
                               style: const TextStyle(),
                                   hint:const Text('Select Crypto'),
                                   value: selectedCrypto,
                                   alignment: Alignment.centerLeft,
                                   onChanged: (newValue) {
                                     setState(() {
                                       selectedCrypto = newValue!;
                                       calculateValue = selectedCrypto!.rate! * double.parse(coinAddEditingController!.text);
                                     });
                                   },
                                   items: cryptoList.map((CryptoIndex crypto) {
                                     return DropdownMenuItem<CryptoIndex>(
                                       alignment: Alignment.center,
                                       value: crypto,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           FadeInImage.assetNetwork(
                                             height: 35, width: 35,
                                             placeholder: 'assets/cob.png',
                                             image: crypto.icon!,
                                           ),
                                           Padding(padding: const EdgeInsets.only(left: 5),
                                           child:Text(crypto.symbol!,style: GoogleFonts.openSans(textStyle:const TextStyle(color: Color(0xff17181A),
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
                        _addSaveCoinsToLocalStorage(selectedCrypto!);
                      },
                    child:Container(
                    // height: 30,width: 116,
                    decoration: const BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(7)),
                      color: Color(0xff37474F),
                    ),
                    alignment: Alignment.center,
                    child:  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(AppLocalizations.of(context)!.translate("bitai-3")!,textAlign:TextAlign.center,style:GoogleFonts.inter(textStyle:const TextStyle(
                        fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xffFFFFFF)),
                      ),),
                    ),
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left:30,right:30,top:5,bottom:5),
                    child: Container(
                      // height: 192,width: 327,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: Color(0xffE6E6E6)
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                           Text(AppLocalizations.of(context)!.translate("recommend")!,textAlign: TextAlign.center,style:GoogleFonts.inter(textStyle:const TextStyle(
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
                                    // SizedBox(width: 30),
                                    Padding(padding: const EdgeInsets.only(top: 30),
                                    child:Text(AppLocalizations.of(context)!.translate("bitai-4")!,style:GoogleFonts.inter(textStyle:const TextStyle(
                                      fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),
                                    ),)
                                    ),
                                    // SizedBox(width: 60,),
                                    Padding(padding: const EdgeInsets.only(top: 30),
                                    child: Text(AppLocalizations.of(context)!.translate("perfect")!,style:GoogleFonts.inter(textStyle:const TextStyle(
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
                                        height: 41,width: 320,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            color: Color(0xff27343B)
                                        ),
                                      ),
                                      Row(
                                        children: [
                                           const SizedBox(width: 25,),
                                          Padding(padding: const EdgeInsets.only(right: 10,top: 8),
                                              child:
                                              Container(
                                                  height: 25,width: 280,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                     // color: Color(0xffFFC727)
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                  child:DropdownButton<int>(
                                                    dropdownColor:const Color(0xff27343B),
                                                    icon:const Icon(
                                                    Icons.arrow_drop_down_circle,
                                                      color: Color(0xffFFC727),
                                                    ),
                                                   // iconEnabledColor: Color(0xffFFC727),
                                                    isExpanded: true,
                                                    value: _selectedValue,
                                                    onChanged: (int? newValue) {
                                                      setState(() {
                                                        _selectedValue = newValue!;
                                                        coinAddEditingController!.text = _selectedValue.toString();
                                                      });
                                                    },
                                                    items: [20, 50, 70, 100, 150, 200, 500, 700, 800, 900, 1100, 1200].map<DropdownMenuItem<int>>((int value) {
                                                      return DropdownMenuItem<int>(
                                                        value: value,
                                                        child: Text('$value',style: const TextStyle(color:Colors.white),),
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
  _addSaveCoinsToLocalStorage(CryptoIndex cbitIndex) async {
    print(portfolios.length);
    if (portfolios.isNotEmpty) {
      PortfolioCrypto? bitcoinLocal = portfolios.firstWhereOrNull((element) => element.name == cbitIndex.symbol);
      if (bitcoinLocal != null) {
        Map<String, dynamic> row = {
          immediateConnectDatabase.columnName: cbitIndex.symbol,
          immediateConnectDatabase.columnPerRate: cbitIndex.perRate,
          immediateConnectDatabase.columnRateDuringAdding: cbitIndex.rate,

          immediateConnectDatabase.columnCoinsQuantity:
          double.parse(coinAddEditingController!.value.text) +
              bitcoinLocal.numberOfCoins,
          immediateConnectDatabase.columnTotalValue:
          double.parse(coinAddEditingController!.value.text) *
              (cbitIndex.rate!) +
              bitcoinLocal.totalValue,
        };
        final id = await database.update(row);
        print('inserted row id: $id');
        Fluttertoast.showToast(
            msg:
            "${cbitIndex.symbol} ${AppLocalizations.of(context)!.translate("bitai-34")!}",
            toastLength: Toast.LENGTH_SHORT,
            gravity:
            ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color(0xff23C562),
            textColor: const Color(0xffffffff),
            fontSize: 16.0);
      } else {
        Map<String, dynamic> row = {
          immediateConnectDatabase.columnName: cbitIndex.symbol,
          immediateConnectDatabase.columnPerRate: cbitIndex.perRate,
          immediateConnectDatabase.columnRateDuringAdding: cbitIndex.rate,
          immediateConnectDatabase.columnCoinsQuantity:
          double.parse(coinAddEditingController!.value.text),
          immediateConnectDatabase.columnTotalValue:
          double.parse(coinAddEditingController!.value.text) *
              (cbitIndex.rate!),
        };
        final id = await database.insert(row);
        print('inserted row id: $id');
        Fluttertoast.showToast(
            msg:
            "${cbitIndex.symbol} ${AppLocalizations.of(context)!.translate("bitai-33")!}",
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
        immediateConnectDatabase.columnName: cbitIndex.symbol,
        immediateConnectDatabase.columnPerRate: cbitIndex.perRate,
        immediateConnectDatabase.columnRateDuringAdding: cbitIndex.rate,
        immediateConnectDatabase.columnCoinsQuantity:
        double.parse(coinAddEditingController!.text),
        immediateConnectDatabase.columnTotalValue:
        double.parse(coinAddEditingController!.value.text) *
            (cbitIndex.rate!),
      };
      final id = await database.insert(row);
      print('inserted row id: $id');
      Fluttertoast.showToast(
          msg:
          "${cbitIndex.symbol} ${AppLocalizations.of(context)!.translate("bitai-33")!}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xff23C562),
          textColor: const Color(0xffffffff),
          fontSize: 16.0);
    }
    print('cap');
    print(cbitIndex.cap);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ChartPage(double.parse(coinAddEditingController!.value.text), cbitIndex.symbol!, cbitIndex.rate, cbitIndex.perRate!,cbitIndex.cap!,cbitIndex.volume!,cbitIndex.differRate!)));
  }

}
