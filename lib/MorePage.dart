import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'indexmodels/LanguageData.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localizations.dart';

class MorePage extends StatefulWidget{
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();

}

class _MorePageState extends State<MorePage>{
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  String? languageCodeSaved;

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  List<LanguageData> languages = [
    LanguageData(languageCode: "en", languageName: "English"),
    LanguageData(languageCode: "it", languageName: "Italian"),
    LanguageData(languageCode: "de", languageName: "German"),
    LanguageData(languageCode: "sv", languageName: "Swedish"),
    LanguageData(languageCode: "fr", languageName: "French"),
    LanguageData(languageCode: "nb", languageName: "Norwegian"),
    LanguageData(languageCode: "es", languageName: "Spanish"),
    LanguageData(languageCode: "nl", languageName: "Dutch"),
    LanguageData(languageCode: "fi", languageName: "Finnish"),
    LanguageData(languageCode: "ru", languageName: "Russian"),
    LanguageData(languageCode: "pt", languageName: "Portuguese"),
    LanguageData(languageCode: "ar", languageName: "Arabic"),
  ];
  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
    });
  }
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(AppLocalizations.of(context)!.translate("bitai-25")!, style: const TextStyle(fontFamily: 'Open Sans', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xff17181A))),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Scaffold(
                          backgroundColor: const Color(0xffFFFFFF),
                          appBar: AppBar(
                            backgroundColor: const Color(0xffFFFFFF),
                            title: Text(AppLocalizations.of(context)!.translate("bitai-26")!),
                            titleTextStyle: const TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,
                                fontSize: 18,color: Color(0xff000000)),
                            centerTitle: true,
                            elevation: 0,
                          ),
                          body: Container(
                            color: const Color(0xffFFFFFF),
                            // some UI setting omitted
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-1")!,
                                          style: const TextStyle(color:Color(0xff000000),fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-2")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                              fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-3")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                              fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-4")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-5")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-6")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-7")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-8")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-9")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-10")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-11")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(AppLocalizations.of(context)!.translate("bitai_policy-12")!,
                                          style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-13")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-14")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-15")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-16")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-17")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-18")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-19")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-20")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-21")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-22")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-23")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-24")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-25")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-26")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-27")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-28")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-29")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                                    //           fontSize: 16)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(AppLocalizations.of(context)!.translate("policy-30")!,
                                    //       style: const TextStyle(color:Color(0xff000000), fontFamily: 'Poppins', fontWeight: FontWeight.w400,
                                    //           fontSize: 14)),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.policy_outlined, size: 35,color:Color(0xff37474F)),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.translate("bitai-26")!,
                          style: TextStyle(color:Color(0xff000000), fontWeight: FontWeight.w500, fontSize: 20),),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xffFFFFFF),
                            title: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!.translate("bitai-29")!,
                                        style: const TextStyle(color: Color(0xff000000))),
                                    InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(Icons.close_outlined)
                                    )
                                  ],
                                )),
                            elevation: 1,
                            content: SizedBox(
                                height: MediaQuery.of(context).size.height/3,
                                width: MediaQuery.of(context).size.width/2,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: languages.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: <Widget>[
                                            InkWell(
                                                onTap: () async {
                                                  appLanguage.changeLanguage(Locale(languages[i].languageCode!));
                                                  await getSharedPrefData();
                                                  // Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      languageCodeSaved ==
                                                          languages[i].languageCode
                                                          ? const Icon(
                                                        Icons
                                                            .check_box,
                                                        color: Color(0xff37474F),
                                                      )
                                                          : const Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        color: Color(0xff37474F),
                                                      ),
                                                      Text(languages[i].languageName!, style: const TextStyle(fontWeight: FontWeight.bold, color:Color(0xff000000)),),
                                                    ],
                                                  ),
                                                )),
                                            // Divider()
                                          ],
                                        ),
                                      );
                                    })),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(const Color(0xff37474F)),
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff37474F)),

                                ),
                                onPressed: () async {
                                  sharedPreferences = await SharedPreferences.getInstance();
                                  setState(() {
                                    sharedPreferences!.setInt("index", 0);
                                    sharedPreferences!.commit();
                                  });
                                  Navigator.pushNamedAndRemoveUntil(context, '/NavigationPage', (r) => false);
                                },
                                child: Text(AppLocalizations.of(context)!.translate("bitai-30")!,style: const TextStyle(color: Color(0xffFFFFFF)),),
                              ),
                            ],
                          );
                        });
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.translate_outlined, size: 35,color:Color(0xff37474F)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.translate("bitai-29")!,
                          style: const TextStyle(color:Color(0xff000000), fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}