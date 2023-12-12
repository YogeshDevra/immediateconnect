import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/api_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_navigation.dart';
import 'homepage.dart';
import 'localization/app_localizations.dart';

class IframeHomePage extends StatefulWidget {
  const IframeHomePage({Key? key}) : super(key: key);

  @override
  _IframeHomePageState createState() => _IframeHomePageState();
}

class _IframeHomePageState extends State<IframeHomePage> {
  late WebViewController controller;
  bool isLoading = true ;

  @override
  void initState() {
    setState(() {
      isLoading = true ;
    });
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(api_config.PreventIframe!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(api_config.FrameLink!));
    setState(() {
      isLoading = false ;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xffFFFFFF),
          elevation: 0,
          // automaticallyImplyLeading: false,
          leading: InkWell(
            onTap:(){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => NavigationPage()));
            },
            child: Icon(Icons.dashboard_customize_sharp,size: 25,),
          ),
          title: Text(AppLocalizations.of(context)!.translate("bitai-6")!,style: GoogleFonts.openSans(textStyle:
          TextStyle(fontSize: 25),fontWeight: FontWeight.w400),),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 3));
            },
            child: isLoading ?
            const Center(child: CircularProgressIndicator(color: Color(0xff23C562))):
            WebViewWidget(
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer()
                  )),
                controller: controller)));
  }
}
