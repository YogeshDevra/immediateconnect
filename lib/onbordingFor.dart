import 'package:flutter/material.dart';
import 'package:quantumaiapp/localization/app_localization.dart';


import 'HomePage.dart';
class OnBordingFor extends StatefulWidget {
  const OnBordingFor({super.key});

  @override
  State<OnBordingFor> createState() => _OnBordingForState();
}
class _OnBordingForState extends State<OnBordingFor>{
  @override
  Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Onbarding.png')
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(40),
                child:Text(AppLocalizations.of(context)!.translate('home_6')!,
                  style: const TextStyle(fontSize: 36.52,fontWeight: FontWeight.w300,
                      color: Color(0xffFFFFFF),fontFamily: 'Gilroy'),textAlign: TextAlign.center,),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff5C428F)
                  ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top:5,bottom:5,left:20,right:20),
                  child: Text(AppLocalizations.of(context)!.translate('home_7')!,
                    style: const TextStyle(fontFamily: 'Gilroy', fontSize: 25.11,
                        fontWeight: FontWeight.w600, color: Color(0xffffffff)),
                  ),
                ),
              )
              ],
            ),
          ),
      );
  }
}