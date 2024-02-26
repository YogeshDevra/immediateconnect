import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'localization/app_localization.dart';
class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}
class _PrivacyState extends State<Privacy>{
  @override
  Widget build(BuildContext context){
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
        title: Text(AppLocalizations.of(context)!.translate('privacy_policy')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(10),
        // height: 520,
        child : ListView(
          children: [
            Text(AppLocalizations.of(context)!.translate('pp1')!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xffF4F5F6)),
            ),
            Text(AppLocalizations.of(context)!.translate('pp2')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp3')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp4')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp5')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp6')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp7')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp8')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp9')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp10')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp11')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.translate('pp12')!,
              softWrap: true,
              style: const TextStyle(fontSize: 16, color: Color(0xffF4F5F6)),
            ),
          ],
        ),
      ),
    );
  }
}
