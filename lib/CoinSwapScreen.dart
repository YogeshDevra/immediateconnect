// ignore_for_file: library_private_types_in_public_api, file_names, use_build_context_synchronously, deprecated_member_use, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:quantumaiapp/models/CryptoData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ConfirmConvertScreen.dart';
import 'HomePage.dart';

class CoinSwapScreen extends StatefulWidget{
  const CoinSwapScreen({super.key});

  @override
  _CoinSwapScreenState createState() => _CoinSwapScreenState();
}

class _CoinSwapScreenState extends State<CoinSwapScreen>{
  List<CryptoData> cryptoList1 = [];
  CryptoData selectedCrypto1 = CryptoData();
  List<CryptoData> cryptoList2 = [];
  CryptoData selectedCrypto2 = CryptoData();
  bool loading = false;
  TextEditingController? fromTextEditingController;
  final _fromKey = GlobalKey<FormState>();
  String? fromName;
  String? toName;
  double getValue = 0.0;
  double oneGetValue = 0.0;
  double fromValue = 0.0;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;

  @override
  void initState(){
    // BitcoinLifestyleAnalytics.setCurrentScreen(BitcoinLifestyleAnalytics.SWAP_SCREEN, "Swap Screen");
    cryptoSwapApi();
    fromTextEditingController = TextEditingController();
    setState(() {
      loading = true;
    });
    super.initState();
  }

  Future<void> cryptoSwapApi() async {
    final SharedPreferences prefs = await _sprefs;
      var url = '${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    if (await ApiConfigConnect.internetConnection()) {
      try{
        var response = await get(Uri.parse(url)).timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map;
          if (mounted) {
            if (data['error'] == false) {
              setState(() {
                try {
                  cryptoList1.addAll(data['data']
                      .map<CryptoData>((json) => CryptoData.fromJson(json))
                      .toList());
                  cryptoList2.addAll(data['data']
                      .map<CryptoData>((json) => CryptoData.fromJson(json))
                      .toList());

                  loading = false;
                  selectedCrypto1 = cryptoList1[0];
                  selectedCrypto2 = cryptoList2[cryptoList2.length - 1];
                  fromName =
                      prefs.getString("fromName") ?? selectedCrypto1.symbol!;
                  toName = prefs.getString("toName") ?? selectedCrypto2.symbol!;
                  getValue = prefs.getDouble("getValue") ?? 0.0;
                  oneGetValue = prefs.getDouble("oneGetValue") ?? 0.0;
                  fromValue = prefs.getDouble("fromValue") ?? 0.0;
                  fromTextEditingController!.text = fromValue.toString();

                  for (var crypto1 in cryptoList1) {
                    if (fromName == crypto1.symbol) {
                      selectedCrypto1 = crypto1;
                    }
                  }

                  for (var crypto2 in cryptoList2) {
                    if (toName == crypto2.symbol) {
                      selectedCrypto2 = crypto2;
                    }
                  }
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  print(e);
                }
              });
            } else {
              setState(() {
                loading = false;
              });
            }
          }
        }else {
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
      ApiConfigConnect.toastMessage(message: 'No Internet');
      setState(() {
        loading = false;
      });
    }
    ApiConfigConnect.internetConnection();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back,
              color: Color(0xffFFFFFF)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.translate('coin_swap')!,
          style: const TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),
        ),
      ),
      backgroundColor: Colors.black,
      body: loading ? const Center(child:CircularProgressIndicator())
          :SafeArea(
          child:ListView(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff353945),
                              borderRadius: BorderRadius.circular(30),
                              // shape: BoxShape.rectangle,
                              // border: Border.all(color: const Color(0xffC8A902))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:25, bottom:15, left:10, right:10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.translate('you_pay')!, style: const TextStyle(fontFamily: 'Gilroy-Bold',
                                        fontSize: 20, fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),),
                                    Text('${AppLocalizations.of(context)!.translate('balance')!} : ${selectedCrypto1.rate!.toStringAsFixed(2)}',
                                      style: const TextStyle(fontFamily: 'Gilroy-Medium',
                                          fontSize: 16, fontWeight: FontWeight.w400,color: Color(0xffFFFFFF)),),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Form(
                                          key: _fromKey,
                                          child: TextFormField(
                                            controller: fromTextEditingController,
                                            onChanged: (value) {
                                              print("from value swap");
                                              print(value);
                                              setState(() {
                                                if(fromTextEditingController!.text != "") {
                                                  fromValue = double.parse(value);
                                                  if(fromValue != 0) {
                                                    oneGetValue = double.parse(
                                                        (selectedCrypto1.rate! *
                                                            double.parse(value)).toStringAsFixed(
                                                            2));
                                                    getValue = double.parse((oneGetValue /
                                                        (selectedCrypto2.rate!))
                                                        .toStringAsFixed(2));
                                                  } else {
                                                    oneGetValue = 0.0;
                                                    getValue = 0.0;
                                                  }
                                                } else {
                                                  oneGetValue = 0.0;
                                                  getValue = 0.0;
                                                }
                                              });
                                              print(oneGetValue);
                                              print(getValue);
                                            },
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff777E90)),
                                            textAlign: TextAlign.left,
                                            cursorColor: const Color(0xff777E90),
                                            decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xff777E90),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 32),
                                              hintText: AppLocalizations.of(context)!.translate('enter_coins')!,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              LengthLimitingTextInputFormatter(4),
                                              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                            ],
                                            keyboardType: const TextInputType.numberWithOptions(signed: true,decimal: true),
                                            // onEditingComplete: calculateGetValue(),
                                            //only numbers can be entered
                                            validator: (val) {
                                              if (fromTextEditingController!.text == "" ||
                                                  int.parse(fromTextEditingController!.value.text) <= 0) {
                                                return AppLocalizations.of(context)!.translate('invalid_coins')!;
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: const Color(0xff353945),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(color: const Color(0xffFFFFFF))
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<CryptoData>(
                                            icon: const Icon(Icons.keyboard_arrow_down_rounded,size: 25,color:Color(0xffFFFFFF)),
                                            borderRadius: BorderRadius.circular(25),
                                            dropdownColor: const Color(0xff353945),
                                            style: const TextStyle(),
                                            hint: Text(AppLocalizations.of(context)!.translate('choose_crypto')!),
                                            value: selectedCrypto1,
                                            alignment: Alignment.center,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCrypto1 = newValue!;
                                                if(fromTextEditingController!.text != "" && double.parse(fromTextEditingController!.text) != 0 ) {
                                                  oneGetValue = double.parse((selectedCrypto1.rate!*double.parse(fromTextEditingController!.text)).toStringAsFixed(2));
                                                  getValue = double.parse((oneGetValue / (selectedCrypto2.rate!)).toStringAsFixed(2));
                                                }else if(fromValue != 0) {
                                                  oneGetValue = double.parse((selectedCrypto1.rate!*fromValue).toStringAsFixed(2));
                                                  getValue = double.parse((oneGetValue / (selectedCrypto2.rate!)).toStringAsFixed(2));
                                                }else {
                                                  oneGetValue = 0.0;
                                                  getValue = 0.0;
                                                }
                                              });
                                            },
                                            items: cryptoList1.map((CryptoData crypto) {
                                              return DropdownMenuItem<CryptoData>(
                                                alignment: Alignment.center,
                                                value: crypto,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    FadeInImage(
                                                      placeholder: const AssetImage('assets/image/cob.png'),
                                                      image: NetworkImage("${crypto.icon}"),
                                                      height: 28,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(crypto.symbol!),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(30),
                            // shape: BoxShape.rectangle,
                            // border: Border.all(color: const Color(0xffC8A902))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:25, bottom:25, left:10, right:10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.translate('you_get')!,
                                      style: const TextStyle(fontFamily: 'Gilroy-Bold',
                                          fontSize: 20, fontWeight: FontWeight.w400,color: Color(0xff3E3F40)),),
                                    Text('\$${selectedCrypto2.rate!.toStringAsFixed(2)}', style:
                                    const TextStyle(fontFamily: 'Gilroy-Medium',
                                        fontSize: 16, fontWeight: FontWeight.w400,color: Color(0xff3E3F40)),)
                                  ],
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    // decoration: BoxDecoration(
                                    //     color: const Color(0xff333333),
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     shape: BoxShape.rectangle,
                                    //     border: Border.all(color: const Color(0xffC8A902))
                                    // ),
                                    child:Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getValue.toString(), style: const TextStyle(fontFamily: 'Gilroy-Bold',
                                              fontSize: 32, fontWeight: FontWeight.w400,color: Color(0xff777E90))),
                                          // Text(getValue.toStringAsFixed(2),style: const TextStyle(fontFamily: 'Gilroy-Bold',
                                          //     fontSize: 32, fontWeight: FontWeight.w400,color: Color(0xff777E90))),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: const Color(0xffFFFFFF),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(color: const Color(0xff000000))
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<CryptoData>(
                                                icon: const Icon(Icons.keyboard_arrow_down_rounded,size: 25,color:Color(0xff000000)),
                                                borderRadius: BorderRadius.circular(25),
                                                dropdownColor: const Color(0xffFFFFFF),
                                                style: const TextStyle(),
                                                hint: Text(AppLocalizations.of(context)!.translate('choose_crypto')!),
                                                value: selectedCrypto2,
                                                alignment: Alignment.center,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedCrypto2 = newValue!;
                                                    if(fromTextEditingController!.text != "" && double.parse(fromTextEditingController!.text) != 0) {
                                                      oneGetValue = double.parse(
                                                          (selectedCrypto1.rate! *
                                                              double.parse(fromTextEditingController!.text))
                                                              .toStringAsFixed(2));
                                                      getValue = double.parse((oneGetValue /
                                                          (selectedCrypto2.rate!))
                                                          .toStringAsFixed(2));
                                                    }else if(fromValue != 0) {
                                                      oneGetValue = double.parse((selectedCrypto1.rate!*fromValue).toStringAsFixed(2));
                                                      getValue = double.parse((oneGetValue / (selectedCrypto2.rate!)).toStringAsFixed(2));
                                                    } else {
                                                      oneGetValue = 0.0;
                                                      getValue = 0.0;
                                                    }
                                                  });
                                                },
                                                items: cryptoList2.map((CryptoData crypto) {
                                                  return DropdownMenuItem<CryptoData>(
                                                    alignment: Alignment.center,
                                                    value: crypto,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        FadeInImage(
                                                          placeholder: const AssetImage('assets/image/cob.png'),
                                                          image: NetworkImage("${crypto.icon}"),
                                                          height: 28,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(crypto.symbol!,
                                                            style: const TextStyle(fontFamily: 'Gilroy-Bold',
                                                            fontSize: 20, fontWeight: FontWeight.w400,color: Color(0xff3E3F40))),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Center(
                      //     child: Image.asset('graphics/Frame 8008.png')
                      // ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(double.parse(fromTextEditingController!.text) == 0.0 || fromTextEditingController!.text == "") {
                              ApiConfigConnect.toastMessage(message: AppLocalizations.of(context)!.translate('invalid_coins')!);
                            }else {
                              sharedPreferences = await SharedPreferences.getInstance();
                              setState(() {
                                sharedPreferences!.setString("fromName", selectedCrypto1.symbol!);
                                sharedPreferences!.setString("toName", selectedCrypto2.symbol!);
                                sharedPreferences!.setDouble("fromValue", double.parse(fromTextEditingController!.text));
                                sharedPreferences!.setDouble("getValue", getValue);
                                sharedPreferences!.setDouble("oneGetValue", oneGetValue);
                                sharedPreferences!.commit();
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmConvertScreen()));
                            }
                          },
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff5C428F)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(AppLocalizations.of(context)!.translate('review_swap')!,
                                  style: const TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width/3,
                    left: MediaQuery.of(context).size.width/2.5,
                    child: SvgPicture.asset(
                      'assets/swap.svg',
                      // semanticsLabel: 'My SVG Image',
                      // height: 10,
                      // width: 10,
                    ),
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}