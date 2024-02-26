// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localization.dart';
import 'models/LanguageData.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget{
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  SharedPreferences? sharedPreferences;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  String? languageCodeSaved;
  String? languageNameSaved;

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

  @override
  void initState() {
    // TODO: implement initState
    getSharedPrefData();
    super.initState();
  }

  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
      languageNameSaved = prefs.getString('language_name') ?? "English";
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
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
        title: Text(AppLocalizations.of(context)!.translate('setting')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 140,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15, right: 15),
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 10),
              InkWell(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Center(
                            child: Text(AppLocalizations.of(context)!.translate('select_language')!,style: const TextStyle(color: Colors.grey,),
                            ),
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: languages.length,
                                itemBuilder: (BuildContext context,
                                    int i){
                                  return Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: ()async {
                                          appLanguage.changeLanguage(Locale(languages[i].languageCode!));
                                          await getSharedPrefData();
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(languages[i].languageName!,
                                                style:
                                                const TextStyle(
                                                    color: Color(0xff202020)
                                                )),
                                            languageCodeSaved == languages[i].languageCode
                                                ? const Icon(
                                                Icons.radio_button_checked,
                                                color: Color(0xff5C428F)
                                            )
                                                : const Icon(
                                                Icons
                                                    .radio_button_unchecked,
                                                color:
                                                Color(0xff5C428F)
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider()
                                    ],
                                  );
                                }
                            ),
                          ),
                          actions: <Widget>[
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 150,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),color: const Color(0xff7B39FB)),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.translate('cancel')!,
                                        style: const TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 25,
                    ),
                    const SizedBox(width: 15),
                    Text(AppLocalizations.of(context)!.translate('language')!,
                      style: const TextStyle(
                          color:Color(0xff575555),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                    const Spacer(),
                    Text(AppLocalizations.of(context)!.translate('select_language')!,
                      style: const TextStyle(
                          color:Color(0xff7B39FB),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
