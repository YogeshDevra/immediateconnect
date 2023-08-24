// ignore_for_file: prefer_final_fields, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmCurrListCon.dart';
import 'ImmLangListCon.dart';
import 'ImmPrivacySheetCon.dart';

class ImmMenuSheetCoin extends StatefulWidget {
  const ImmMenuSheetCoin({super.key});

  @override
  State<ImmMenuSheetCoin> createState() => _ImmMenuSheetCoin();
}

class _ImmMenuSheetCoin extends State<ImmMenuSheetCoin> {

  Future<SharedPreferences> _immSpfCon = SharedPreferences.getInstance();
  String? immCurrCon;
  String? immSltLangCon;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await _immSpfCon;
    var immCurrName = prefs.getString("currencyExchange") ?? "USD";
    var immLangName = prefs.getString("language_name") ?? "English";
    setState(() {
      immCurrCon = immCurrName;
      immSltLangCon = immLangName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          ImmAppLocalCon.of(context)!.translate('Menu')!,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),
          textAlign: TextAlign.start,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/NavigationPage', (r) => false);
              },
              child:
              const Icon(Icons.arrow_back, color: Colors.black, size: 25)),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            height: 40,
            color: getColorFromHex("#E8E8E8"),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/gift12.png"),
                  const SizedBox(width: 10),
                  Text(
                    ImmAppLocalCon.of(context)!
                        .translate('Earn_Crypto_Together')!,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                ImmAppLocalCon.of(context)!.translate('App_Setting')!,
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 16)),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: getColorFromHex("#E8E8E8"),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImmLangListCon()));
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        // height: 13,
                        "assets/images/language 1.png",
                        // color: Colors.blue,
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          ImmAppLocalCon.of(context)!
                              .translate('select_language')!,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$immSltLangCon",
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImmPrivacyScnCon()));
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        height: 13,
                        "assets/images/profile2.png",
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          ImmAppLocalCon.of(context)!
                              .translate('Terms_Policy')!,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImmCurrListCon()));
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/money.png",
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          ImmAppLocalCon.of(context)!
                              .translate('Default_Currenciesme')!,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$immCurrCon",
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
