import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:immediateconnectapp/ImmApiConfig.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'ImmChartPage.dart';
import 'ImmConnectDatabase.dart';
import 'ImmConnectModels/ImmCrypto.dart';
import 'ImmConnectModels/ImmPortfolioCrypto.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';




class ImmPortfolioPage extends StatefulWidget {
  const ImmPortfolioPage({super.key});


  @override
  State<ImmPortfolioPage> createState() => _ImmPortfolioPageState();
}

class _ImmPortfolioPageState extends State<ImmPortfolioPage> {
  final immDatabase = ImmConnectDatabase.instance;
  String coinName = '';
  num size = 0;
  String ? actualPercentage;
  double Percentage = 0.0;


  List<ImmPortfolioCrypto> portfolio = [];
  double totalPortfolio = 0.0;
  final ScrollController _scrollControler = ScrollController();
  List<ImmCrypto> portGraphList = [];
  List<ImmCrypto> ImmcryptoList = [];
  //List<PortfolioCrypto> portfolioList = [];
  bool isloading = false;
  bool loadingPage = true;
  String differenceRate = '';
  double nameOfDiffRate = 0.0;
  double crypto = 0;
  List<immLinearSale> dataCurrency = [];
  String imType = "Year";
  bool portGraphValue = false;
  num selectedValue = 0;
  int graphButton = 6;
  double imCurrentLow = 0.0;
  double imCurrentHigh = 0.0;
  double rate = 0.0;
  double RateValue = 0.0;
  double coinsValue = 0.0;
  double curValue = 0.0;
  late TrackballBehavior imm_trackballBehavior;
  late CrosshairBehavior imm_crosshairBehavior;
  SharedPreferences? imSharedPreferences;
  TextEditingController? ImmUpdateCoinEditingController;
  double? cap = 0.0;
  double? volume = 0.0;
  ImmPortfolioCrypto? portfolioCoin;


  @override
  void initState(){
    ImmUpdateCoinEditingController = TextEditingController();

    immDatabase.queryAllRows().then((notes) {
      for (var note in notes) {
        //  print(note['name']);
        portfolio.add(ImmPortfolioCrypto.fromMap(note));
        totalPortfolio = totalPortfolio + note["total_value"];
        RateValue = RateValue + note["rate_during_adding"];
        coinsValue = coinsValue + note["coins_quantity"];
      }
      portfolioCoin = portfolio[0];
      if(notes!= null){
        callingGraphApi(notes[0]["name"]);
        //    portfolioCrypto = notes[0] as PortfolioCrypto?;
        print(notes[0]["name"]);
        portGraphValue = true;
        setState(() {
          coinName = notes[0]["name"];

        });
      }else{
        portGraphValue = false;
      }
      setState(() {});
    });
    super.initState();
    callImmCrypto();
  }

  Future<void> callImmCrypto() async {
    setState(() {
      loadingPage = true;
    });
    var uri = '${ImmApiConfig.ImmApiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    print(uri);
    if (await ImmApiConfig.imm_internetConnection()) {
      try {
        var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
        print(response);
        if(response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          print(data);
          if(mounted) {
            if (data['error'] == false) {
              setState(() {
                ImmcryptoList.addAll(
                    data['data'].map<ImmCrypto>((json) =>
                        ImmCrypto.fromJson(json)));
                size = size + data['data'].length;
                for(int i=0;i<ImmcryptoList.length;i++) {
                  if(ImmcryptoList[i].symbol == coinName){
                    print(ImmcryptoList[i].perRate);
                    actualPercentage = ImmcryptoList[i].perRate;
                    portfolio.forEach((element) {
                      curValue += getCurrentDiffRate(element, ImmcryptoList);
                    });
                    print(curValue);
                    setState(() {
                      Percentage = (curValue - totalPortfolio) /
                          curValue;
                      if(Percentage.isNaN)
                        setState(() {
                          Percentage = 0;
                        });
                      print(Percentage);
                    });
                  }
                }});
              loadingPage = false;
            } else {
              ImmApiConfig.imm_toastMessage(message:'Under Maintenance');
              setState(() {
                loadingPage = false;
              });
            }
          }
        }else {
          ImmApiConfig.imm_toastMessage(message: 'Under Maintenance');
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
      ImmApiConfig.imm_toastMessage(message: 'No Internet');
      setState(() {
        loadingPage = false;
      });
    }
    ImmApiConfig.imm_internetConnection();
  }


  Future<void> callingGraphApi(String name) async {
    if(portfolio.isNotEmpty) {
      setState(() {
        isloading = true;
        coinName = name;
      });
      print('graph name  : '  + name );
      print('graph crypto name  : '  + coinName );
      var uri = '${ImmApiConfig.ImmApiUrl}/Bitcoin/resources/getBitcoinCryptoGraph?type=$imType&name=$coinName&currency=USD';
      if (await ImmApiConfig.imm_internetConnection()) {
        try {
          var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
          if(response.statusCode == 200) {
            final data = json.decode(response.body) as Map;
            print(data);
            if (mounted) {
              if (data['error'] == false) {
                setState(() {
                  portGraphList = data['data']
                      .map<ImmCrypto>((json) => ImmCrypto.fromJson(json))
                      .toList();
                  double count = 0;
                  differenceRate = data['diffRate'];
                  nameOfDiffRate = double.parse(data['diffRate']);
                  dataCurrency = [];
                  for (var element in portGraphList) {
                    dataCurrency.add(immLinearSale(element.date!, double.parse(element.rate!.toStringAsFixed(2))));
                    coinName = element.name!;
                    imCurrentLow = element.low!;
                    imCurrentHigh = element.high!;
                    volume = element.volume;
                    cap = element.cap;
                    rate = double.parse(element.rate!.toStringAsFixed(2));
                    String step2 = element.rate!.toStringAsFixed(2);
                    double step3 = double.parse(step2);
                    crypto = step3;
                    count = count + 1;
                    print(rate);
                    print(volume);
                  }
                  isloading = false;
                });

              } else {
                ImmApiConfig.imm_toastMessage(message:'Under Maintenance');
                setState(() {
                  isloading = false;
                });
              }
            }

          }
          else {
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
      print("ImmcryptoList : ${portGraphList.length}");
    }else{
      print("No Record found");
    }
    callImmCrypto();
  }

  getCurrentDiffRate(ImmPortfolioCrypto items, List<ImmCrypto> cryotoList) {
    ImmCrypto j =
    ImmcryptoList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! * items.numberOfCoins;
    return newRateDiff;
  }

  void showAllDeletePortfolioCoins(ImmPortfolioCrypto portfolioCoin){
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
              title: Text(ImmAppLocalizations.of(context)!.translate("bitai-9")!,
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
                  child: Text(ImmAppLocalizations.of(context)!.translate("bitai-10")!+" ${portfolioCoin.name} "+ ImmAppLocalizations.of(context)!.translate("bitai-11")!,
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
                        placeholder: 'images/tempCob.png',
                        image: 'https://assets.coinlayer.com/icons/${portfolioCoin.name}.png',
                      ),
                      const SizedBox(width: 10),
                      Text(portfolioCoin.name,
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
                      _deleteAllCoinsToLocalStorage(portfolioCoin);
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xff14B8A6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(ImmAppLocalizations.of(context)!.translate("bitai-9")!,
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

  _deleteAllCoinsToLocalStorage(ImmPortfolioCrypto item) async {
    final id = await immDatabase.delete(item.name);
    print('inserted row id: $id');
    Fluttertoast.showToast(
        msg:
        "${item.name} ${ImmAppLocalizations.of(context)!.translate("bitai-35")!}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color(0xff23C562),
        textColor: const Color(0xffffffff),
        fontSize: 16.0);
    imSharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      imSharedPreferences!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
  }

  void showAllEditPortfolioCoins(ImmPortfolioCrypto portfolioCoin){
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
              title: Text(ImmAppLocalizations.of(context)!.translate("bitai-12")!,
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
                          placeholder: 'images/tempCob.png',
                          image: 'https://assets.coinlayer.com/icons/${portfolioCoin.name}.png',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(portfolioCoin.name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff000000)),
                        ),
                        const Spacer(),
                        Text('\$ ${portfolioCoin.totalValue.toStringAsFixed(2)} USD',
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
                        controller: ImmUpdateCoinEditingController,
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
                            labelText: ImmAppLocalizations.of(context)!.translate("bitai-28"),
                            labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            floatingLabelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            alignLabelWithHint: true,
                            focusColor: Colors.black
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        ], // O
                        //only numbers can be entered
                        validator: (val) {
                          if (ImmUpdateCoinEditingController!
                              .value.text ==
                              "" ||
                              double.parse(ImmUpdateCoinEditingController!
                                  .value.text) <=
                                  0) {
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
                        _updateAllSaveCoinsToLocalStorage(portfolioCoin);
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: const Color(0xff86F3D0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(ImmAppLocalizations.of(context)!.translate("bitai-12")!,
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

  _updateAllSaveCoinsToLocalStorage(ImmPortfolioCrypto bitcoin) async {
    if (ImmUpdateCoinEditingController!.text.isNotEmpty && ImmUpdateCoinEditingController!.text != 0) {
      double adf = double.parse(ImmUpdateCoinEditingController!.text);
      print(adf);
      Map<String, dynamic> row = {
        ImmConnectDatabase.columnName: bitcoin.name,
        ImmConnectDatabase.columnRateDuringAdding: bitcoin.rateDuringAdding,
        ImmConnectDatabase.columnCoinsQuantity:
        double.parse(ImmUpdateCoinEditingController!.value.text),
        ImmConnectDatabase.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await immDatabase.update(row);
      print('inserted row id: $id');
      Fluttertoast.showToast(
          msg:
          "${bitcoin.name} ${ImmAppLocalizations.of(context)!.translate("bitai-34")!}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xff23C562),
          textColor: const Color(0xffffffff),
          fontSize: 16.0);
      imSharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        imSharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
    }
  }

  void displayPopupMenu() async {
    await showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(400, 80, 0, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        items: [
          PopupMenuItem<String>(
              child: Column(
                  children: [
                    InkWell(
                      child:
                      Container(
                        height: 178,
                        width: 168,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                            color: Colors.black),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ImmChartPage(portfolioCoin!.numberOfCoins, portfolioCoin!.name,rate,actualPercentage,cap,volume,differenceRate)));
                              },
                              child: Container(
                                height: 45,
                                width: 126,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:  BorderRadius.all(Radius.circular(12)),
                                ),
                                child:Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    Image.asset(
                                      'images/onlyIcons/imGroup_508.png',
                                      width: 33,
                                      height: 34,
                                    ),

                                    SizedBox(width: 15,),
                                    Text(ImmAppLocalizations.of(context)!.translate("bitai-22")!,style:GoogleFonts.inter(textStyle:TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C) )
                                    ),)

                                  ],
                                ),

                              ),
                            ),
                            SizedBox(height: 7,),
                            InkWell(
                              onTap:(){
                                showAllDeletePortfolioCoins(portfolioCoin!);
                              },
                              child:Container(
                                height: 45,
                                width: 126,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:  BorderRadius.all(Radius.circular(12)),
                                ),
                                child:Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    Image.asset(
                                      'images/onlyIcons/imGroup_508(1).png',
                                      width: 33,
                                      height: 34,
                                    ),
                                    SizedBox(width: 15,),
                                    Text(ImmAppLocalizations.of(context)!.translate("delete")!,style:GoogleFonts.inter(textStyle:TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C))
                                    ),)

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 7,),
                            InkWell(
                              onTap:(){
                                showAllEditPortfolioCoins(portfolioCoin!);
                              },
                              child:Container(
                                height: 45,
                                width: 126,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:  BorderRadius.all(Radius.circular(12)),
                                ),
                                child:Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    Image.asset(
                                      'images/onlyIcons/imGroup_508(2).png',
                                      width: 33,
                                      height: 34,
                                    ),
                                    SizedBox(width: 18,),
                                    Text(ImmAppLocalizations.of(context)!.translate("edit")!,style:GoogleFonts.inter(textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff1A202C))
                                    ),)

                                  ],
                                ),

                              ),
                            )


                          ],
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
          SizedBox(height: 45,),
          Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 135,),
                  child:Text(ImmAppLocalizations.of(context)!.translate("bitai-13")!,style:GoogleFonts.inter(
                      textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff030303)
                      )
                  ),),
                ),
                SizedBox(width: 90,),
                totalPortfolio >0
                    ?InkWell(
                  onTap: () {
                    displayPopupMenu();
                  },
                  child:Image.asset('images/onlyIcons/im_more_dots.png'),
                )
                    :Image.asset('images/onlyIcons/im_more_dots.png'),
              ]),
          isloading ? Center(
              child: CircularProgressIndicator(color: Colors.black))
              :portGraphList.isEmpty
              ? Center(child: Image.asset("images/imNoData.png"))
              : Container(
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
                              placeholder: 'images/tempCob.png',
                              image: 'https://assets.coinlayer.com/icons/$coinName.png',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(coinName, style: GoogleFonts.openSans(textStyle: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                                  ),),
                                  Text(nameOfDiffRate.toStringAsFixed(2)
                                    , style: GoogleFonts.openSans(textStyle:TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 14, color: nameOfDiffRate>=0?Colors.green:Colors.red)
                                    ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text("\$"+rate.toStringAsFixed(2), style: GoogleFonts.openSans(textStyle: TextStyle(
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
                                child: isloading?const Center(child:CircularProgressIndicator()):
                                SfCartesianChart(
                                    backgroundColor: Colors.white,
                                    plotAreaBackgroundColor: Colors.white,
                                    plotAreaBorderWidth: 0,
                                    enableSideBySideSeriesPlacement: true,
                                    crosshairBehavior:imm_crosshairBehavior = CrosshairBehavior(
                                      // Enables the crosshair
                                      enable: true,
                                      lineColor: Color(0xff0000000),
                                      lineWidth: 2,
                                      lineDashArray: <double>[5,5],
                                      activationMode: ActivationMode.singleTap,
                                    ),
                                    //_crosshairBehavior,
                                    trackballBehavior:imm_trackballBehavior = TrackballBehavior(
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
                                      axisLine: AxisLine(color: Colors.white, width: 0),
                                      isVisible: true,
                                      labelRotation: 90,
                                      interactiveTooltip: const InteractiveTooltip(
                                          enable: true
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Color(0xff88898A),
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    series: <ChartSeries<immLinearSale, String>>[
                                      SplineSeries<immLinearSale, String>(
                                        dataSource: dataCurrency,
                                        xValueMapper:  (immLinearSale data, _) => data.date,
                                        yValueMapper:  (immLinearSale data, _) => data.rate,
                                        color: Color(0xff81B2CA),
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
                                  foregroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(graphButton == 2? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  graphButton = 2;
                                  imType = "Week";
                                  callingGraphApi(coinName);
                                });
                              },
                              child: Text("7D",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: graphButton == 2
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
                                  foregroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  graphButton = 3;
                                  imType = "15Day";
                                  callingGraphApi(coinName);
                                });
                              },
                              child: Text("15D",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: graphButton == 3
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
                                  foregroundColor: MaterialStateProperty.all<Color>(graphButton == 4 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(graphButton == 4 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  graphButton = 4;
                                  imType = "Month";
                                  callingGraphApi(coinName);
                                });
                              },
                              child: Text("1M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: graphButton == 4
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
                                  foregroundColor: MaterialStateProperty.all<Color>(graphButton == 5 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(graphButton == 5 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  graphButton = 5;
                                  imType = "2Month";
                                  callingGraphApi(coinName);
                                });
                              },
                              child: Text("2M",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: graphButton == 5
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
                                  foregroundColor: MaterialStateProperty.all<Color>(graphButton == 6 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  backgroundColor: MaterialStateProperty.all<Color>(graphButton == 6 ? const Color(0xff030303) : const Color(0xffffffff),),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                              onPressed: () {
                                setState(() {
                                  graphButton = 6;
                                  imType = "Year";
                                  callingGraphApi(coinName);
                                });
                              },
                              child: Text("1Y",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: graphButton == 6
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

          SizedBox(height: 5,),
          Container(
              height: 90,width: 375,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Color(0xff2C383F),
              ),
              child:Column(
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30,top: 20),
                        child: Text(ImmAppLocalizations.of(context)!.translate("bitai-13")!,style: GoogleFonts.inter(
                            textStyle:TextStyle(fontSize: 13,fontWeight: FontWeight.w700,color: Color(0xffFFFFFF) )
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:70,right:10,top: 20),
                        child: Text("\$${totalPortfolio.toStringAsFixed(2)}", style:GoogleFonts.inter(
                            textStyle:TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color:Color(0xffFFFFFF) )
                        ),textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width/1.17,
                        animation: true,
                        lineHeight: 5,
                        barRadius:const Radius.circular(8),
                        animationDuration: 2500,
                        percent:Percentage,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Percentage<0
                            ?Color(0xffFF775C)
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
                controller: _scrollControler,
                itemCount: portfolio.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){
                      setState(() {
                        selectedValue = i;
                        coinName = portfolio[i].name;
                        portfolioCoin = portfolio[i];

                        callingGraphApi(portfolio[i].name);
                      });
                    },
                    child:Container(
                      decoration: BoxDecoration(
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
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(18)),
                                              color: Color(0xffF4F6F6)
                                          ),
                                          child:FadeInImage.assetNetwork(
                                            height: 20, width: 20,
                                            placeholder: 'images/tempCob.png',
                                            image: 'https://assets.coinlayer.com/icons/${portfolio[i].name}.png',
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(portfolio[i].name, style:GoogleFonts.openSans(textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff17181A))
                                              ),),
                                              Text(nameOfDiffRate.toStringAsFixed(2)
                                                , style: GoogleFonts.openSans(textStyle:TextStyle(
                                                    fontWeight: FontWeight.w400, fontSize: 14, color: nameOfDiffRate>=0?Colors.green:Colors.red)
                                                ),)
                                            ],
                                          ),
                                        ),
                                        // SizedBox(width: 105),
                                        // Text("${portfolios[i].totalValue.toStringAsFixed(2)} ", style:GoogleFonts.inter(textStyle:TextStyle(
                                        //      fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff1A202C)
                                        // )
                                        // )
                                        //,),

                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(ImmAppLocalizations.of(context)!.translate("bitai-16")!+" ${portfolio[i].numberOfCoins.toStringAsFixed(1)}", style: const TextStyle(
                                      fontFamily: 'Open Sans', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff17181A)
                                  ),),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(ImmAppLocalizations.of(context)!.translate("bitai-17")!+" ${portfolio[i].totalValue.toStringAsFixed(2)}", style: const TextStyle(
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
class immLinearSale {
  final String date;
  final double rate;

  immLinearSale(this.date, this.rate);
}
