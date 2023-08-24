// ignore_for_file: sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';


class ImmPrivacyScnCon extends StatefulWidget {
  const ImmPrivacyScnCon({Key? key}) : super(key: key);

  @override
  _ImmPrivacyScnCon createState() => _ImmPrivacyScnCon();
}

class _ImmPrivacyScnCon extends State<ImmPrivacyScnCon> {
  ScrollController? _controllerList;

  @override
  void initState() {
    _controllerList = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getColorFromHex("#FAFAFA"),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: getColorFromHex("#FAFAFA"),
          centerTitle: true,
          title: Text(
            ImmAppLocalCon.of(context)!.translate('privacy_policy')!,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            textAlign: TextAlign.start,
          ),
          leading: InkWell(
            child: Container(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          leadingWidth: 35,
        ),
        body: ListView(
          controller: _controllerList,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp1')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp2')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp3')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp4')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp5')!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp6')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp7')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp8')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp9')!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp10')!,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp11')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp12')!,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp13')!,
                        style: const TextStyle(fontSize: 18, color: Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp14')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp15')!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp16')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp17')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp18')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ImmAppLocalCon.of(context)!.translate('pp19')!,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
