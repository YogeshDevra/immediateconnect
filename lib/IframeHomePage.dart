// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, must_be_immutable, library_private_types_in_public_api


import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:immediate_connect/portfoliopage.dart';
import 'package:immediate_connect/topcoin.dart';
import 'package:immediate_connect/trendsPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ImmediateConnectAnalytics.dart';
import 'coinsPage.dart';
import 'dashboard_home.dart';
import 'localization/app_localization.dart';


class IframeHomePage extends StatefulWidget {
  const IframeHomePage({Key? key}) : super(key: key);

  @override
  _IframeHomePageState createState() => _IframeHomePageState();
}

class _IframeHomePageState extends State<IframeHomePage> {
  String preventIframeImmediate = '';
  String? iFrameUrl;
  bool? displayiframe;
  late WebViewController controller;
  bool isLoading = true ;

  @override
  void initState() {
    ImmediateConnectAnalytics.setCurrentScreen(ImmediateConnectAnalytics.ImmediateConnect_Iframe_SCREEN, "ImmediateConnect Iframe Page");
    super.initState();
    firebaseValueFetch();
  }

  firebaseValueFetch() async{
    setState(() {
      isLoading = true ;
    });
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      preventIframeImmediate = remoteConfig.getString('immediate_connect_prevent_sst').trim();
      iFrameUrl = remoteConfig.getString('immediate_connect_iframe_url_sst').trim();
      displayiframe = remoteConfig.getBool('bool_immediate_connect_sst');
      print(displayiframe);
    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
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
            if (request.url.startsWith(preventIframeImmediate)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(iFrameUrl!));
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
            leading:InkWell(
                onTap: () {
                  setState(() {
                    _modalBottomMenu();
                  });
                }, // Image tapped
                child: const Icon(Icons.menu_rounded,color: Color(0xffd76614),)
            ),
            title: Image.asset("assets/image/logo_hor.png"),
            // flexibleSpace: Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(height: 20),
            //       Text(AppLocalizations.of(context)!.translate("bitai-5")!, style: const TextStyle(fontFamily: 'Open Sans', fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff61656A))),
            //       Text(AppLocalizations.of(context)!.translate("bitai-6")!, style: const TextStyle(fontFamily: 'Open Sans', fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xff17181A)))
            //     ],
            //   ),
            // ),
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

  _modalBottomMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ), builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, setState) =>
              SingleChildScrollView(
                child:Container(
                  decoration: const BoxDecoration(image: DecorationImage(
                    image: AssetImage("assets/image/Group 33770.png",),
                    fit: BoxFit.fill,
                  ),),
                  height: MediaQuery.of(context).size.height/1.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget> [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            if(displayiframe == true)
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => IframeHomePage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset("assets/image/iframeicon.png",height: 60,width: 60,)),
                                  Text("Immediate Connect",textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DashboardHome()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33764.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('home'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TopCoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33765.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CoinsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33766.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('coins'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TrendsPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33767.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('trends'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PortfolioPage()),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child:
                                      Image.asset("assets/image/Group 33768.png",height: 60,width: 60,)),
                                  Text(AppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
      );});
  }

}
