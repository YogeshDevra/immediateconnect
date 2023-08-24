// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, prefer_final_fields, unused_field, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ImmLocalCon/ImmAppLangCon.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmModelCon/ImmLangDtCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';

class ImmLangListCon extends StatefulWidget {
  const ImmLangListCon({Key? key}) : super(key: key);

  @override
  _ImmLangListCon createState() => _ImmLangListCon();
}

class _ImmLangListCon extends State<ImmLangListCon> {
  Future<SharedPreferences> _immSpfCon = SharedPreferences.getInstance();
  late SharedPreferences immShdPrfCon;
  var _immLblCon = 'Dashboard';
  String? languageCodeSaved;
  var immLangCdSvCon;

  List<ImmLangDtCon> languages = [
    ImmLangDtCon(languageCode: "en", languageName: "English"),
    ImmLangDtCon(languageCode: "it", languageName: "Italian"),
    ImmLangDtCon(languageCode: "de", languageName: "German"),
    ImmLangDtCon(languageCode: "sv", languageName: "Swedish"),
    ImmLangDtCon(languageCode: "fr", languageName: "French"),
    ImmLangDtCon(languageCode: "nb", languageName: "Norwegian"),
    ImmLangDtCon(languageCode: "es", languageName: "Spanish"),
    ImmLangDtCon(languageCode: "nl", languageName: "Dutch"),
    ImmLangDtCon(languageCode: "fi", languageName: "Finnish"),
    ImmLangDtCon(languageCode: "ru", languageName: "Russian"),
    ImmLangDtCon(languageCode: "pt", languageName: "Portuguese"),
    ImmLangDtCon(languageCode: "ar", languageName: "Arabic"),
  ];

  Future<void> immGetShdPrfCon() async {
    final SharedPreferences prefs = await _immSpfCon;
    setState(() {
      _immLblCon = prefs.getString("title") ??
          ImmAppLocalCon.of(context)!.translate('Home')!;
      languageCodeSaved = prefs.getString('language_code') ?? "en";

      _immSvPrfDataCon();
    });
  }

  _immSvPrfDataCon() async {
    immShdPrfCon = await SharedPreferences.getInstance();
    setState(() {
      immShdPrfCon.setInt("index", 0);
      immShdPrfCon.setString(
          "title", ImmAppLocalCon.of(context)!.translate('Home') ?? '');
    });
  }

  @override
  void initState() {
    immGetShdPrfCon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<ImmAppLangCon>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            ImmAppLocalCon.of(context)!.translate('Default_Language')!,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Color(0xff000000),
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/MenuPage', (r) => false);
                },
                child: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: languages.length,
              itemBuilder: (BuildContext context, int k) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: languageCodeSaved == languages[k].languageCode!
                          ? const Color(0xffEDEFF0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            appLanguage.changeLanguage(
                                Locale(languages[k].languageCode!));
                            await immGetShdPrfCon();
                            final SharedPreferences prefs = await _immSpfCon;
                            setState(() {
                              immLangCdSvCon = prefs.setString(
                                  'language_name',
                                  languages[k].languageName!.toString());
                            });

                              Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              Text(languages[k].languageName!),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: languageCodeSaved ==
                                    languages[k].languageCode
                                    ? Icon(
                                  Icons.check,
                                  color: getColorFromHex("#F5C249"),
                                )
                                    : const Text(""),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
