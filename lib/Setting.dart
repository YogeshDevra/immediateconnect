import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Setting',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),

        ),
      ),
      backgroundColor: Colors.black,
body: Center(
child: Container(
    height: 140,
    width: double.infinity,
    padding: EdgeInsets.only(left: 15, right: 15),
    margin: EdgeInsets.only(left: 20, right: 20),
    decoration: BoxDecoration(
color: Colors.white,
        borderRadius: BorderRadius.circular(8),
    ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
children: [
  SizedBox(height: 10),
InkWell(
onTap: (){
showDialog(
  context: context,
    builder: (BuildContext context){
return AlertDialog(
title: Center(
child: Text('Select Language',style: TextStyle(color: Colors.grey,),
),
),
content: Container(
  width: double.maxFinite,
child: ListView.builder(
shrinkWrap: true,
  itemCount: languages.length,
itemBuilder: (BuildContext context,
    int i){
return Container(
child: Column(
children: <Widget>[
InkWell(
onTap: ()async {
  appLanguage.changeLanguage(
      Locale(languages[
      i]
          .languageCode!));
  //await getSharedPrefData();
  Navigator.pop(
      context);

},
    child: Row(
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,
      children: <Widget>[
        Text(
            languages[i]
                .languageName!,
            style:
            TextStyle(
                color: Color(0xff202020)
            )),
        languageCodeSaved ==
            languages[
            i]
                .languageCode
            ? Icon(
            Icons
                .radio_button_checked,
            color:
            Color(0xffFF897E)
        )
            : Icon(
            Icons
                .radio_button_unchecked,
            color:
            Color(0xffFF897E)
        ),
      ],
    ),

),
  const Divider()
],
),
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

              borderRadius:
              BorderRadius.circular(
                  16),color: Color(0xffFF897E)),
          child: Center(
            child: Text(
                style: TextStyle(

                  color: Color(0xff202020),
                ),
                'Cancel'
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
        // child: Image.asset(
        //   "assetsFortune/imagesFortune/Vector16Fortune.png",
        //   color: Color(0xff575555)
        // ),
      ),
      SizedBox(width: 15),
      Text(
        "Language",
        style: TextStyle(
            color:Color(0xff575555),
            fontWeight: FontWeight.w400,
            fontSize: 16),
        textAlign: TextAlign.start,
      ),
      Spacer(),
      Text(
        "Select",
        style: TextStyle(
            color:Colors.brown,
            fontWeight: FontWeight.w400,
            fontSize: 16),
        textAlign: TextAlign.start,
      ),
    ],
  ),

),
  SizedBox(height: 20),
  Row(
    children: [
      Container(
        width: 25,
        // child: Image.asset(
        //   "assetsFortune/imagesFortune/Vector17Fortune.png",
        //   color: Color(0xff575555)
        // ),
      ),
      SizedBox(width: 15),


      // Container(
      //   decoration: BoxDecoration(
      //       color: themeChange.darkTheme
      //           ? getLight1Color()
      //           : getBottombgColor(),
      //       borderRadius: BorderRadius.circular(29)),
      //   // padding: EdgeInsets.only(left: 20, right: 20),
      //   child: DropdownButtonHideUnderline(
      //     child: DropdownButton(
      //       // Initial Value
      //       value: themedropdownvalue,
      //       // ThemeMode.dark,
      //       dropdownColor: getBottombgColor(),
      //       iconEnabledColor: getBottomBarbgColor(),

      //       // Array list of items
      //       items: themeitems.map((String items) {
      //         return DropdownMenuItem(
      //           onTap: () {},
      //           value: items,
      //           child: Text(
      //             items,
      //             style: TextStyle(
      //                 color: getBottomBarbgColor()),
      //           ),
      //         );
      //       }).toList(),

      //       onChanged: (newValue) {
      //         setState(() {
      //           themeChange.darkTheme =
      //               !themeChange.darkTheme;
      //           themedropdownvalue = newValue!;
      //         });
      //       },
      //     ),
      //   ),
      // ),
      // Switch(
      //   value:
      //       _themeManager.themeMode == ThemeMode.light,
      //   onChanged: (newValue) {
      //     _themeManager.toggleTheme(newValue);
      //   },
      // )
      // Container(
      //   decoration: BoxDecoration(
      //       color: getBottombgColor(),
      //       borderRadius: BorderRadius.circular(29)),
      //   // padding: EdgeInsets.only(left: 20, right: 20),
      //   child: DropdownButtonHideUnderline(
      //     child: DropdownButton(
      //       // Initial Value
      //       // value: _themeManager.themeMode ==
      //           // ThemeMode.dark,
      //       dropdownColor: getBottombgColor(),
      //       iconEnabledColor: getBottomBarbgColor(),
      //       // Down Arrow Icon

      //       // Array list of items
      //       items: themeitems.map((String items) {
      //         return DropdownMenuItem(
      //           value: items,
      //           child: Text(
      //             items,
      //             style: TextStyle(
      //                 color: getBottomBarbgColor()),
      //           ),
      //         );
      //       }).toList(),

      //       onChanged: (newValue) {
      //         setState(() {
      //           _themeManager.toggleTheme(newValue);
      //         });
      //       },
      //     ),
      //   ),
      // ),
    ],
  ),
],
  ),
),
),
    );
  }

}
