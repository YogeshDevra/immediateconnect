// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:quantumaiapp/SwapSuccessScreen.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/models/CryptoData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class ConfirmConvertScreen extends StatefulWidget{
  const ConfirmConvertScreen({super.key});

  @override
  _ConfirmConvertScreenState createState() => _ConfirmConvertScreenState();
}

class _ConfirmConvertScreenState extends State<ConfirmConvertScreen>{
  List<CryptoData> cryptoList1 = [];
  CryptoData selectedCrypto1 = CryptoData();
  List<CryptoData> cryptoList2 = [];
  CryptoData selectedCrypto2 = CryptoData();
  bool loading = false;
  String? fromName;
  String? toName;
  double getValue = 0.0;
  double oneGetValue = 0.0;
  double fromValue = 0.0;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  String ?formattedDate;
  // String? ipValue;
  // bool hideBitLifestyle = false;

  @override
  void initState(){
    // BitcoinLifestyleAnalytics.setCurrentScreen(BitcoinLifestyleAnalytics.CONVERT_SCREEN, "Convert Screen");
    loading = true;
    // firebaseValueFetch();
    cryptoSwapApi();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);
    super.initState();
  }

  Future<void> cryptoSwapApi() async {
    setState(() {
      loading = true;
    });
    try{
      final SharedPreferences prefs = await _sprefs;
      var url = '${ApiConfigConnect.apiUrl}/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
      var response = await get(Uri.parse(url));
      final data = json.decode(response.body) as Map;
      if (data['error'] == false) {
        setState(() {
          try{
            cryptoList1.addAll(data['data']
                .map<CryptoData>((json) => CryptoData.fromJson(json))
                .toList());
            cryptoList2.addAll(data['data']
                .map<CryptoData>((json) => CryptoData.fromJson(json))
                .toList());

            selectedCrypto1 = cryptoList1[0];
            selectedCrypto2 = cryptoList2[cryptoList2.length-1];


            fromName = prefs.getString("fromName") ?? selectedCrypto1.symbol!;
            toName = prefs.getString("toName") ?? selectedCrypto2.symbol!;
            getValue = prefs.getDouble("getValue") ?? 0.0;
            oneGetValue = prefs.getDouble("oneGetValue") ?? 0.0;
            fromValue = prefs.getDouble("fromValue") ?? 0.0;

            for (var crypto1 in cryptoList1) {
              if(fromName == crypto1.symbol) {
                selectedCrypto1 = crypto1;
              }
            }

            for (var crypto2 in cryptoList2) {
              if(toName == crypto2.symbol) {
                selectedCrypto2 = crypto2;
              }
            }
            loading = false;
          } catch (e) {
            print(e);
          }
        });
      }else{
        setState(() {});
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xff353945),
        appBar: AppBar(
          backgroundColor: const Color(0xff353945),
          leading: InkWell(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Icon(Icons.arrow_back)
          ),
          title: Text(AppLocalizations.of(context)!.translate('convert_crypto')!),
          titleTextStyle: const TextStyle(fontFamily: 'Gilroy-Bold',fontWeight: FontWeight.w500,
              fontSize: 18,color: Color(0xffFFFFFF)),
          centerTitle: true,
          elevation: 0,
        ),
        body: loading ? const Center(child: CircularProgressIndicator()):SafeArea(
            child : Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff000000),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:25,bottom:25,left:15,right:15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.translate('about_swap')!, style: const TextStyle(
                                    fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xffF9F9F9)
                                  )),
                                  Text(selectedCrypto1.rate!.toStringAsFixed(2), style: const TextStyle(
                                      fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xffF9F9F9)
                                  )),
                                ],
                              ),
                              const Divider(color: Color(0xffD5DEE3)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(fromValue.toString(), style: const TextStyle(
                                          fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff777E90))),
                                      Text(selectedCrypto1.fullName!, style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xffFFFFFF))),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xff353945),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: const Color(0xffFFFFFF))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          FadeInImage(
                                            placeholder: const AssetImage('assets/image/cob.png'),
                                            image: NetworkImage("${selectedCrypto1.icon}"),
                                            height: 28,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(selectedCrypto1.symbol!,style: const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xffFFFFFF))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:25,bottom:25,left:15,right:15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.translate('to_get')!, style: const TextStyle(
                                    fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xff3E3F40)
                                  )),
                                  Text('\$${selectedCrypto2.rate!.toStringAsFixed(2)}', style: const TextStyle(
                                      fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xff3E3F40)
                                  )),
                                ],
                              ),
                              const Divider(color: Color(0xffD5DEE3)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(getValue.toString(), style: const TextStyle(
                                          fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff3E3F40))),
                                      Text(selectedCrypto2.fullName!, style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff7D858A))),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xffFFFFFF),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: const Color(0xffD5DEE3))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          FadeInImage(
                                            placeholder: const AssetImage('assets/image/cob.png'),
                                            image: NetworkImage("${selectedCrypto2.icon}"),
                                            height: 28,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(selectedCrypto2.symbol!,style: const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff3E3F40))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xffD5DEE3))
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("1 " + selectedCrypto1.symbol!, style: const TextStyle(color: Color(0xff7D858A)),),
                                  Text(selectedCrypto1.rate!.toStringAsFixed(2), style: const TextStyle(color: Color(0xffF5F8FA)),),
                                ],
                              ),
                            ),
                            const Divider(color: Color(0xffD5DEE3),indent: 10,endIndent: 10),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fromValue.toString() + " " + selectedCrypto1.symbol!, style: const TextStyle(color: Color(0xff7D858A)),),
                                  Text(oneGetValue.toString(), style: const TextStyle(color: Color(0xffF5F8FA)),),
                                ],
                              ),
                            ),
                            const Divider(color: Color(0xffD5DEE3),indent: 10,endIndent: 10,),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("1 " + selectedCrypto2.symbol!, style: const TextStyle(color: Color(0xff7D858A)),),
                                  Text(selectedCrypto2.rate!.toStringAsFixed(2), style: const TextStyle(color: Color(0xffF5F8FA)),),
                                ],
                              ),
                            ),
                            const Divider(color: Color(0xffD5DEE3),indent: 10,endIndent: 10,),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fromValue.toString() + " " + selectedCrypto1.symbol!, style: const TextStyle(color: Color(0xff7D858A)),),
                                  Text(getValue.toString() + " " + selectedCrypto2.symbol!, style: const TextStyle(color: Color(0xffF5F8FA)),),
                                ],
                              ),
                            ),
                            const Divider(color: Color(0xffD5DEE3),indent: 10,endIndent: 10,),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.translate('date')!, style: const TextStyle(color: Color(0xff7D858A)),),
                                  Text(formattedDate!, style: const TextStyle(color: Color(0xffF5F8FA)),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SwapSuccessScreen(selectedCrypto1, selectedCrypto2, fromValue, getValue)));
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff5C428F)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(AppLocalizations.of(context)!.translate('confirm_swap')!,
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w400)
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
            )
        )
    );
  }

}