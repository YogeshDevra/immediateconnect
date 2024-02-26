// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, must_be_immutable, library_private_types_in_public_api, file_names


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quantumaiapp/ApiConfigConnect.dart';
import 'package:quantumaiapp/privacy.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'AddedPortfolios.dart';
import 'CryptoListViewAll.dart';
import 'HomePage.dart';
import 'QuantumAIAnalytics.dart';
import 'Setting.dart';
import 'WishListScreen.dart';
import 'localization/app_localization.dart';


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
    QuantumAIAnalytics.setCurrentScreen(QuantumAIAnalytics.QuantumAI_Iframe_SCREEN, "Quantum AI Iframe Page");
    super.initState();
    firebaseValueFetch();
  }

  firebaseValueFetch() async{
    setState(() {
      isLoading = true ;
    });
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
            if (request.url.startsWith(ApiConfigConnect.preventUrl)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(ApiConfigConnect.webUrl));
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
                  Scaffold.of(context).openDrawer();
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
        drawer: Drawer(
          backgroundColor: const Color(0xff0F1621),
          child: ListView(
            padding: const EdgeInsets.only(left: 40),
            children: [
              const SizedBox(width: 300,height: 80,),
              const Text('Immediate Connect',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,
                    fontFamily: 'Inter', color: Colors.white),
              ),
              const Padding(padding: EdgeInsets.only(left: 41, top: 140)),
              ListTile(
                  leading: Image.asset('assets/home.png'),
                  title: Text(AppLocalizations.of(context)!.translate('home')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                  }
              ),
              ListTile(
                  leading: Image.asset('assets/clist.png'),
                  // Divider(
                  title: Text(AppLocalizations.of(context)!.translate('crypto_list')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CryptoListViewAll()));
                  }
              ),
              ListTile(
                  leading: Image.asset('assets/swap.png'),
                  // Divider(
                  title: Text(AppLocalizations.of(context)!.translate('swap')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {}
              ),
              ListTile(
                  leading: Image.asset('assets/ACL.png'),
                  // Divider(
                  title: Text(AppLocalizations.of(context)!.translate('added_coin_list')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddedPortfolioScreen()));
                  }
              ),
              ListTile(
                  leading: Image.asset('assets/wishlist.png'),
                  // Divider(
                  title: Text(AppLocalizations.of(context)!.translate('wish_list')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600, fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen()));
                  }
              ),
              ListTile(
                  leading: Image.asset('assets/setting.png',height: 22),
                  title: Text(AppLocalizations.of(context)!.translate('setting')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Setting()));
                  }
              ),
              ListTile(
                  leading: Image.asset('assets/privacy.png',height: 22),
                  title: Text(AppLocalizations.of(context)!.translate('privacy')!, style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Privacy()));
                  }
              ),
            ],
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
