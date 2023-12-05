import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:immediateconnectapp/ImmApiConfig.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ImmLocalization/ImmAppLocalizations.dart';
import 'ImmNavigationPage.dart';

class ImmWebPage extends StatefulWidget {
  const ImmWebPage({Key? key}) : super(key: key);

  @override
  _ImmWebPageState createState() => _ImmWebPageState();
}

class _ImmWebPageState extends State<ImmWebPage> {
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
            if (request.url.startsWith(ImmApiConfig.ImmPreventIframe!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(ImmApiConfig.ImmFrameLink!));
    setState(() {
      isLoading = false ;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: const Color(0xffFFFFFF),
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap:(){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ImmNavigationPage()));
              },
              child: Icon(Icons.dashboard,),
            ),
            title: Text(ImmAppLocalizations.of(context)!.translate("bitai-6")!,
                style:TextStyle(fontSize: 25,fontWeight: FontWeight.w400)),
            centerTitle: true,
          ),
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
