import 'package:flutter/material.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';

class ImmOnboardPage extends StatefulWidget {
  const ImmOnboardPage ({super.key});

  @override
  State<ImmOnboardPage> createState() => _ImmOnboardPageState();

}
class _ImmOnboardPageState extends State<ImmOnboardPage> {
  @override
  void initState() {
    OnbordingScreen();
    super.initState();
  }
  Future<void> OnbordingScreen() async {
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
              child:Image.asset('images/im_onboardimage.png'),
            ),
            const SizedBox(height: 80),
            Padding(padding: EdgeInsets.only(left: 24),
              child:Text(ImmAppLocalizations.of(context)!.translate("bitai-6")!,textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 50,fontWeight: FontWeight.w400,color: Color(0xff000000)
              ),),
            ),
            const SizedBox(height: 80),
            Padding(padding: EdgeInsets.only(left: 24),
              child:Image.asset('images/im_onboardim.png'),
            ),
          ],
        ),
      ),
    );
  }
}