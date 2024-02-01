import 'package:flutter/material.dart';


import 'CryptoPage.dart';
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
        body: Center(
          child: Stack(

            children: [
              Image.asset('assets/Onbarding.png'),
              Container(
                alignment: Alignment.center,
                child:Text('Welcome to Crypto',style: TextStyle(fontSize: 36.52,fontWeight: FontWeight.w300,color: Color(0xffFFFFFF),fontFamily: 'Gilroy'),textAlign: TextAlign.center,)
                ,
              ),
              Container(
                padding: EdgeInsets.only(top: 700,left: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cryptolist()));
                },
                child: Image.asset(
                  'assets/Button.png',),
                  // Fixes border issues


              ),
              )
              ],
            ),
          ),


      );}
}