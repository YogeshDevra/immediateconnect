// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:newproject/api_config.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'immediateConnect_Database.dart';
import 'chart.dart';
import 'indexmodels/CryptoIndex.dart';
import 'indexmodels/PortfolioCrypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'localization/app_localizations.dart';




class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});


  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final database = immediateConnectDatabase.instance;
  bool bankLoad = false;
  String cryptoName = '';
  num _size = 0;
  String ? percentage;
  double percent = 0.0;
  List<PortfolioCrypto> portfolios = [];
  double totalPortfolioValue = 0.0;
  final ScrollController _scrollController = ScrollController();
  List<CryptoIndex> graphList = [];
  List<CryptoIndex> cryptoList = [];
  bool loading = false;
  bool loadingPage = true;
  String bitIndexApi = "";
  String diffRate = '';
  double diffRateName = 0.0;
  double coin = 0;
  double result = 0.0;
  bool colorValue = false;
  List<LinearSales> currencyData = [];
  String type = "Year";
  bool graphValue = false;
  num selectedIndex = 0;
  int buttonType = 6;
  double currentLow = 0.0;
  double currentHigh = 0.0;
  double rate = 0.0;
  double totalRate = 0.0;
  double totalCoins = 0.0;
  double currentValue = 0.0;
  late TrackballBehavior _trackballBehavior;
  late CrosshairBehavior _crosshairBehavior;
  SharedPreferences? sharedPreferences;
  TextEditingController? updateCoinEditingController;
  double totalMarketCap = 0.0;
  double totalVolume = 0.0;
  double? cap = 0.0;
  double? volume = 0.0;
  PortfolioCrypto? portfolioCrypto;


  @override
  void initState(){
    updateCoinEditingController = TextEditingController();

    database.queryAllRows().then((notes) {
      for (var note in notes) {
        //  print(note['name']);
        portfolios.add(PortfolioCrypto.fromMap(note));
        totalPortfolioValue = totalPortfolioValue + note["total_value"];
        totalRate = totalRate + note["rate_during_adding"];
        totalCoins = totalCoins + note["coins_quantity"];
      }
      portfolioCrypto = portfolios[0];
      if(notes!= null){
        callGraphApi(notes[0]["name"]);
        //    portfolioCrypto = notes[0] as PortfolioCrypto?;
        print(notes[0]["name"]);
        graphValue = true;
        setState(() {
          cryptoName = notes[0]["name"];

        });
      }else{
        graphValue = false;
      }
      setState(() {});
    });
    super.initState();
    callCryptoIndex();
  }

  Future<void> callCryptoIndex() async {
    setState(() {
      loadingPage = true;
    });
    var uri = '${api_config.ApiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    print(uri);
    if (await api_config.internetConnection()) {
      try {
        var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
        print(response);
        if(response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          print(data);
          if(mounted) {
            if (data['error'] == false) {
              setState(() {
                cryptoList.addAll(
                    data['data'].map<CryptoIndex>((json) =>
                        CryptoIndex.fromJson(json)));
                _size = _size + data['data'].length;
                for(int i=0;i<cryptoList.length;i++) {
                  if(cryptoList[i].symbol == cryptoName){
                    print(cryptoList[i].perRate);
                    percentage = cryptoList[i].perRate;
                    for (var element in portfolios) {
                      currentValue += getCurrentRateDiff(element, cryptoList);
                    }
                    print(currentValue);
                    setState(() {
                      percent = (currentValue - totalPortfolioValue) /
                          currentValue;
                      if(percent.isNaN) {
                        setState(() {
                          percent = 0;
                        });
                      }
                      print(percent);
                    });
                  }
                }});
              loadingPage = false;
            } else {
              api_config.toastMessage(message:'Under Maintenance');
              setState(() {
                loadingPage = false;
              });
            }
          }
        }else {
          api_config.toastMessage(message: 'Under Maintenance');
          setState(() {
            loadingPage = false;
          });
        }
      } on TimeoutException catch(e) {
        setState(() {
          loadingPage = false;
        });
        print(e);
      }
      catch (e) {
        setState(() {
          loadingPage = false;
        });
      }
    } else {
      api_config.toastMessage(message: 'No Internet');
      setState(() {
        loadingPage = false;
      });
    }
    api_config.internetConnection();
  }


  Future<void> callGraphApi(String name) async {
    if(portfolios.isNotEmpty) {
      setState(() {
        loading = true;
        cryptoName = name;
      });
      print('graph name  : $name' );
      print('graph crypto name  : $cryptoName' );
      var uri = '${api_config.ApiUrl}/Bitcoin/resources/getBitcoinCryptoGraph?type=$type&name=$cryptoName&currency=USD';
      if (await api_config.internetConnection()) {
        try {
          var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
          if(response.statusCode == 200) {
            final data = json.decode(response.body) as Map;
            print(data);
            if (mounted) {
              if (data['error'] == false) {
                setState(() {
                  graphList = data['data']
                      .map<CryptoIndex>((json) => CryptoIndex.fromJson(json))
                      .toList();
                  double count = 0;
                  diffRate = data['diffRate'];
                  diffRateName = double.parse(data['diffRate']);
                  currencyData = [];
                  for (var element in graphList) {
                    currencyData.add(LinearSales(element.date!, double.parse(element.rate!.toStringAsFixed(2))));
                    cryptoName = element.name!;
                    currentLow = element.low!;
                    currentHigh = element.high!;
                    volume = element.volume;
                    cap = element.cap;
                    rate = double.parse(element.rate!.toStringAsFixed(2));
                    String step2 = element.rate!.toStringAsFixed(2);
                    double step3 = double.parse(step2);
                    coin = step3;
                    count = count + 1;
                    print(rate);
                    print(volume);
                  }
                  loading = false;
                });

              } else {
                api_config.toastMessage(message:'Under Maintenance');
                setState(() {
                  loading = false;
                });
              }
            }

          }
          else {
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
      print("cryptoList : ${graphList.length}");
    }else{
      print("No Record found");
    }
    callCryptoIndex();
  }

  getCurrentRateDiff(PortfolioCrypto items, List<CryptoIndex> cryotoList) {
    CryptoIndex j = cryptoList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! * items.numberOfCoins;
    return newRateDiff;
  }

  void showDeletePortfolioCoins(PortfolioCrypto portfolioCrypto){
    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: const Color(0xffF2F2F2),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xffF2F2F2),
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.translate("bitai-9")!,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.start,
              ),
              leading: InkWell(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              leadingWidth: 35,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("${AppLocalizations.of(context)!.translate("bitai-10")!} ${portfolioCrypto.name} ${AppLocalizations.of(context)!.translate("bitai-11")!}",
                    style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff868990),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInImage.assetNetwork(
                        height: 48, width: 48,
                        placeholder: 'image/bitIndex/cob.png',
                        image: 'https://assets.coinlayer.com/icons/${portfolioCrypto.name}.png',
                      ),
                      const SizedBox(width: 10),
                      Text(portfolioCrypto.name,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 110),
                  child: InkWell(
                    onTap: () {
                      _deleteCoinsToLocalStorage(portfolioCrypto);
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xff14B8A6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.translate("bitai-9")!,
                            style: const TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _deleteCoinsToLocalStorage(PortfolioCrypto item) async {
    final id = await database.delete(item.name);
    print('inserted row id: $id');
    Fluttertoast.showToast(
        msg:
        "${item.name} ${AppLocalizations.of(context)!.translate("bitai-35")!}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xff23C562),
        textColor: const Color(0xffffffff),
        fontSize: 16.0);
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

  void showEditPortfolioCoins(PortfolioCrypto portfolioCrypto){
    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: const Color(0xffFFFFFF),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xffFFFFFF),
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.translate("bitai-12")!,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.start,
              ),
              leading: InkWell(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              leadingWidth: 35,
            ),
            body: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff86F3D0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Row(
                      children: [
                        FadeInImage.assetNetwork(
                          height: 48, width: 48,
                          placeholder: 'image/bitIndex/cob.png',
                          image: 'https://assets.coinlayer.com/icons/${portfolioCrypto.name}.png',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(portfolioCrypto.name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff000000)),
                        ),
                        const Spacer(),
                        Text('\$ ${portfolioCrypto.totalValue.toStringAsFixed(2)} USD',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff000000)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Center(
                      child: TextFormField(
                        controller: updateCoinEditingController,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            labelText: AppLocalizations.of(context)!.translate("bitai-28"),
                            labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            floatingLabelStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            alignLabelWithHint: true,
                            focusColor: Colors.black
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ], // O
                        //only numbers can be entered
                        validator: (val) {
                          if (updateCoinEditingController!.value.text == "" ||
                              double.parse(updateCoinEditingController!.value.text) <= 0) {
                            return "at least 1 coin should be added";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 110),
                    child: InkWell(
                      onTap: () {
                        _updateSaveCoinsToLocalStorage(portfolioCrypto);
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: const Color(0xff86F3D0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.translate("bitai-12")!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _updateSaveCoinsToLocalStorage(PortfolioCrypto bitcoin) async {
    if (updateCoinEditingController!.text.isNotEmpty && updateCoinEditingController!.text != 0) {
      double adf = double.parse(updateCoinEditingController!.text);
      print(adf);
      Map<String, dynamic> row = {
        immediateConnectDatabase.columnName: bitcoin.name,
        immediateConnectDatabase.columnRateDuringAdding: bitcoin.rateDuringAdding,
        immediateConnectDatabase.columnCoinsQuantity:
        double.parse(updateCoinEditingController!.value.text),
        immediateConnectDatabase.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await database.update(row);
      print('inserted row id: $id');
      Fluttertoast.showToast(
          msg:
          "${bitcoin.name} ${AppLocalizations.of(context)!.translate("bitai-34")!}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xff23C562),
          textColor: const Color(0xffffffff),
          fontSize: 16.0);
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
    }
  }

  void _showPopupMenu() async {
    await showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(400, 80, 0, 0),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(15)),
        // ),
        items: [
          PopupMenuItem<String>(
              child: Column(
                  children: [
                    InkWell(
                      child:
                      Container(
                        // height: 178,
                        // width: 168,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ChartPage(portfolioCrypto!.numberOfCoins, portfolioCrypto!.name,rate,percentage,cap,volume,diffRate)));
                                },
                                child: Container(
                                  // height: 45,
                                  // width: 126,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:  BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // const SizedBox(width: 10,),
                                        Image.asset(
                                          'assets/icons/Group 508.png',
                                          width: 33,
                                          height: 34,
                                        ),

                                        // const SizedBox(width: 15,),
                                        Text(AppLocalizations.of(context)!.translate("bitai-22")!,style:GoogleFonts.inter(textStyle:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C) )
                                        ),)

                                      ],
                                    ),
                                  ),

                                ),
                              ),
                              const SizedBox(height: 7,),
                              InkWell(
                                onTap:(){
                                  showDeletePortfolioCoins(portfolioCrypto!);
                                },
                                child:Container(
                                  // height: 45,
                                  // width: 126,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:  BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // const SizedBox(width: 10,),
                                        Image.asset(
                                          'assets/icons/Group 508(1).png',
                                          width: 33,
                                          height: 34,
                                        ),
                                        // const SizedBox(width: 15,),
                                        Text(AppLocalizations.of(context)!.translate("delete")!,style:GoogleFonts.inter(textStyle:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C))
                                        ),)

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7,),
                              InkWell(
                                onTap:(){
                                  showEditPortfolioCoins(portfolioCrypto!);
                                },
                                child:Container(
                                  // height: 45,
                                  // width: 126,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:  BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // const SizedBox(width: 10,),
                                        Image.asset(
                                          'assets/icons/Group 508(2).png',
                                          width: 33,
                                          height: 34,
                                        ),
                                        // const SizedBox(width: 18,),
                                        Text(AppLocalizations.of(context)!.translate("edit")!,style:GoogleFonts.inter(textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C))
                                        ),)

                                      ],
                                    ),
                                  ),

                                ),
                              )


                            ],
                          ),
                        ),
                      ),
                    ),

                  ]
              )
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: SingleChildScrollView(
      body:Column(
        children: [
          const SizedBox(height: 45,),
          Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 135,),
                  child:Text(AppLocalizations.of(context)!.translate("bitai-13")!,style:GoogleFonts.inter(
                      textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff030303)
                      )
                  ),),
                ),
                const SizedBox(width: 90,),
                totalPortfolioValue >0
                    ?InkWell(
                  onTap: () {
                    _showPopupMenu();
                  },
                  child:Image.asset('assets/icons/more_dots.png'),
                )
                    :Container(),
              ]),
          loading ? const Center(
              child: CircularProgressIndicator(color: Colors.black))
              :graphList.isEmpty
              ? Center(child: Container(
              height: 420,
            color: Colors.grey,width: double.infinity,
              child: Image.asset("assets/No data.png")))
              : SizedBox(
              height: 420,
              child: ListView(
                children:<Widget> [
                  Padding(
                    padding: const EdgeInsets.only(left:10,right:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            FadeInImage.assetNetwork(
                              height: 48, width: 48,
                              placeholder: 'assets/cob.png',
                              image: 'https://assets.coinlayer.com/icons/$cryptoName.png',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cryptoName, style: GoogleFonts.openSans(textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                                  ),),
                                  Text("${diffRateName.toStringAsFixed(2)}%"
                                    , style: GoogleFonts.openSans(textStyle:TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 14, color: diffRateName>=0?Colors.green:Colors.red)
                                    ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text("\$${rate.toStringAsFixed(2)}", style: GoogleFonts.openSans(textStyle: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 26, color: Color(0xff292D32))
                        ),textAlign: TextAlign.right,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                        children: <Widget>[
                          Center(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                height: MediaQuery.of(context).size.height / 3,
                                child: loading?const Center(child:CircularProgressIndicator()):
                                SfCartesianChart(
                                    backgroundColor: Colors.white,
                                    plotAreaBackgroundColor: Colors.white,
                                    plotAreaBorderWidth: 0,
                                    enableSideBySideSeriesPlacement: true,
                                    crosshairBehavior:_crosshairBehavior = CrosshairBehavior(
                                      // Enables the crosshair
                                      enable: true,
                                      lineColor: const Color(0xff0000000),
                                      lineWidth: 2,
                                      lineDashArray: <double>[5,5],
                                      activationMode: ActivationMode.singleTap,
                                    ),
                                    //_crosshairBehavior,
                                    trackballBehavior:_trackballBehavior = TrackballBehavior(
                                      enable: true,
                                      activationMode: ActivationMode.singleTap,
                                      lineDashArray: <double>[5,5],
                                      lineColor: Color(0xff0000000),
                                      lineWidth: 2,
                                      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
                                      shouldAlwaysShow: true,
                                      tooltipAlignment: ChartAlignment.near,
                                      builder: (BuildContext context, TrackballDetails trackballDetails) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xff030303),
                                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${trackballDetails.point!.x.toString()} \n\$${trackballDetails.point!.y.toString()}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromRGBO(255, 255, 255, 1)
                                                )
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    //_trackballBehavior,
                                    primaryXAxis: CategoryAxis(
                                        axisLine: const AxisLine(color: Colors.white, width: 0),
                                        isVisible: true,
                                        labelRotation: 90,
                                        interactiveTooltip: const InteractiveTooltip(
                                            enable: true
                                        )
                                    ),
                                    series: <ChartSeries<LinearSales, String>>[
                                      SplineSeries<LinearSales, String>(
                                        dataSource: currencyData,
                                        xValueMapper:  (LinearSales data, _) => data.date,
                                        yValueMapper:  (LinearSales data, _) => data.rate,
                                        color: const Color(0xff81B2CA),
                                        dataLabelSettings: const DataLabelSettings(isVisible: false, borderColor: Color(0xff81B2CA)),
                                        markerSettings: const MarkerSettings(isVisible: false),
                                      )
                                    ],
                                    primaryYAxis: NumericAxis(
                                      isVisible: true,
                                      borderColor: Colors.white,
                                      labelStyle: const TextStyle(
                                        color: Color(0xff88898A),
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ))
                            ),

                          )
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 50.0,
                            height: 40.0,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(buttonType == 2 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonType == 2? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  buttonType = 2;
                                  type = "Week";
                                  callGraphApi(cryptoName);
                                });
                              },
                              child: Text("7D",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: buttonType == 2
                                        ? const Color(0xffFFFFFF)
                                        : const Color(0xff88898A)),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 50.0, height: 40.0,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(buttonType == 3 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonType == 3 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  buttonType = 3;
                                  type = "15Day";
                                  callGraphApi(cryptoName);
                                });
                              },
                              child: Text("15D",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: buttonType == 3
                                        ? const Color(0xffFFFFFF)
                                        : const Color(0xff88898A)),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 50.0, height: 40.0,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(buttonType == 4 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonType == 4 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  buttonType = 4;
                                  type = "Month";
                                  callGraphApi(cryptoName);
                                });
                              },
                              child: Text("1M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: buttonType == 4
                                        ? const Color(0xffFFFFFF)
                                        : const Color(0xff88898A)),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 50.0, height: 40.0,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(buttonType == 5 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonType == 5 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  buttonType = 5;
                                  type = "2Month";
                                  callGraphApi(cryptoName);
                                });
                              },
                              child: Text("2M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: buttonType == 5
                                        ? const Color(0xffFFFFFF)
                                        : const Color(0xff88898A)),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 50.0, height: 40.0,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(buttonType == 6 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonType == 6 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  buttonType = 6;
                                  type = "Year";
                                  callGraphApi(cryptoName);
                                });
                              },
                              child: Text("1Y",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: buttonType == 6
                                        ? const Color(0xffFFFFFF)
                                        : const Color(0xff88898A)),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],


              )),

          const SizedBox(height: 5,),
          Container(
              height: 90,width: 375,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xff2C383F),
              ),
              child:Column(
                children: [
                  Row(
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 30,top: 20),
                        child: Text(AppLocalizations.of(context)!.translate("bitai-13")!,style: GoogleFonts.inter(
                            textStyle:const TextStyle(fontSize: 13,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF) )
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:70,right:10,top: 20),
                        child: Text("\$${totalPortfolioValue.toStringAsFixed(2)}", style:GoogleFonts.inter(
                            textStyle:const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color:Color(0xffFFFFFF) )
                        ),textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width/1.20,
                        animation: true,
                        lineHeight: 5,
                        barRadius:const Radius.circular(8),
                        animationDuration: 2500,
                        percent:percent,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: percent<0
                            ?const Color(0xffFF775C)
                            :Colors.green,
                        //Color(0xffFAB512),
                      ),
                    ),
                  ),
                ],
              )
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: portfolios.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){
                      setState(() {
                        selectedIndex = i;
                        cryptoName = portfolios[i].name;
                        portfolioCrypto = portfolios[i];

                        callGraphApi(portfolios[i].name);
                      });
                    },
                    child:Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          color: Color(0xffF4F6F6)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color(0xffFFFFFF)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 65,width: 65,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(18)),
                                              color: Color(0xffF4F6F6)
                                          ),
                                          child:FadeInImage.assetNetwork(
                                            height: 20, width: 20,
                                            placeholder: 'assets/cob.png',
                                            image: 'https://assets.coinlayer.com/icons/${portfolios[i].name}.png',
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(portfolios[i].name, style:GoogleFonts.openSans(textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                                              ),),
                                              Text(diffRateName.toStringAsFixed(2)
                                                , style: GoogleFonts.openSans(textStyle:TextStyle(
                                                    fontWeight: FontWeight.w400, fontSize: 14, color: diffRateName>=0?Colors.green:Colors.red)
                                                ),)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${AppLocalizations.of(context)!.translate("bitai-16")!} ${portfolios[i].numberOfCoins.toStringAsFixed(1)}", style: const TextStyle(
                                      fontFamily: 'Open Sans', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A)
                                  ),),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${AppLocalizations.of(context)!.translate("bitai-17")!} ${portfolios[i].totalValue.toStringAsFixed(2)}", style: const TextStyle(
                                      fontFamily: 'Open Sans', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A)
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),),
                  );
                }
            ),
          ),



        ],),
    );

  }}
class LinearSales {
  final String date;
  final double rate;
  LinearSales(this.date, this.rate);
}
