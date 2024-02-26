// ignore_for_file: library_private_types_in_public_api, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quantumaiapp/CoinSwapScreen.dart';
import 'HomePage.dart';
import 'localization/app_localization.dart';
import 'models/CryptoData.dart';

class SwapSuccessScreen extends StatefulWidget{
  CryptoData selectedCrypto1;
  CryptoData selectedCrypto2;
  double fromValue;
  double getValue;
  SwapSuccessScreen(this.selectedCrypto1, this.selectedCrypto2, this.fromValue, this.getValue, {super.key});

  @override
  _SwapSuccessScreenState createState() => _SwapSuccessScreenState();
}

class _SwapSuccessScreenState extends State<SwapSuccessScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff353945),
      appBar: AppBar(
        backgroundColor: const Color(0xff353945),
        leading: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Icon(Icons.arrow_back)
        ),
        title: Text(AppLocalizations.of(context)!.translate('home_8')!),
        titleTextStyle: const TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,
            fontSize: 18,color: Color(0xffFFFFFF)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  'assets/swap success.svg',
                  // semanticsLabel: 'My SVG Image',
                  // height: 10,
                  // width: 10,
                ),
              ),
              Text(AppLocalizations.of(context)!.translate('home_9')!,
                style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400,
                    fontSize: 24, color: Color(0xffFFFFFF)),textAlign: TextAlign.center,),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text('You just swapped ${widget.fromValue} ${widget.selectedCrypto1.symbol} to get ${widget.getValue} ${widget.selectedCrypto2.symbol} successfully.',
              //     style: TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400,
              //         fontSize: 20, color: Color(0xff959EA3)),textAlign: TextAlign.center,),
              // )
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '${AppLocalizations.of(context)!.translate('home_10')!} ',
                  style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400,
                            fontSize: 20, color: Color(0xff959EA3)),
                  children: <TextSpan>[
                    TextSpan(text: '${widget.fromValue} ${widget.selectedCrypto1.symbol}',
                    style: const TextStyle(fontFamily: 'Source Sans Pro', fontWeight: FontWeight.w400,
                    fontSize: 20, color: Color(0xff3772FF))),
                    TextSpan(text: '\n ${AppLocalizations.of(context)!.translate('to_get')!} ',
                        style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400,
                            fontSize: 20, color: Color(0xff959EA3))),
                    TextSpan(text: '${widget.getValue} ${widget.selectedCrypto2.symbol}',
                        style: const TextStyle(fontFamily: 'Source Sans Pro', fontWeight: FontWeight.w400,
                            fontSize: 20, color: Color(0xff3772FF))),
                    TextSpan(text: '\n ${AppLocalizations.of(context)!.translate('home_11')!}',
                        style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400,
                            fontSize: 20, color: Color(0xff959EA3)))
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CoinSwapScreen()));
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
                      child: Text(AppLocalizations.of(context)!.translate('home_12')!,
                          style: const TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400)
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                      child: Text(AppLocalizations.of(context)!.translate('home_13')!,
                          style: const TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 18, fontWeight: FontWeight.w400)
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}