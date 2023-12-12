import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'localization/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen ({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();

}
class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    Onbording();
    super.initState();
  }
  Future<void> Onbording() async {
    Future.delayed(const Duration(milliseconds: 2000)).then((_) {
      Navigator.of(context).pushReplacementNamed('/NavigationPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDEEBE8),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(padding: EdgeInsets.only(left: 24,top: 59),
              child:Image.asset('assets/onboardimage_bs.png'),
            ),
            const SizedBox(height: 80),
            Padding(padding: EdgeInsets.only(left: 24),
              child:Text(AppLocalizations.of(context)!.translate("bitai-6")!,textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 50,fontWeight: FontWeight.w400,color: Color(0xff000000),fontFamily: 'Fontdiner Swanky'
              ),),
            ),
            const SizedBox(height: 80),
            Padding(padding: EdgeInsets.only(left: 24),
              child:Image.asset('assets/onboardim_bs.png'),
            ),
          ],
        ),
      ),

    );
  }
}