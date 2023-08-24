// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, must_be_immutable, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, await_only_futures, prefer_collection_literals, file_names

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../ImmAnalyisConn.dart';
import '../ImmLocalCon/ImmAppLocalCon.dart';
import '../ImmUtilCon/ImmColorCon.dart';
import 'ImmMenuSheetCon.dart';


class ImmFrameShtConn extends StatefulWidget {
  ImmFrameShtConn({Key? key}) : super(key: key);

  @override
  _ImmFrameShtConn createState() => _ImmFrameShtConn();
}

class _ImmFrameShtConn extends State<ImmFrameShtConn> {

  String immIfrmShtConn = '';
  String immPrvShtConn = '';
  late WebViewController immCinShtConn;
  bool immLdIfrmShtConn= false ;

  @override
  void initState() {
    setState(() {
      immLdIfrmShtConn = true ;
    });
    ImmAnalyisConn.setCurrentScreen(ImmAnalyisConn.ImmFrm_Conn, "ImmediateFramePage");
    immLnkValIfrmConn();
    super.initState();
  }

  immLnkValIfrmConn() async{


    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      immIfrmShtConn = remoteConfig.getString('immediate_frame_connect').trim();
      immPrvShtConn = remoteConfig.getString('immediate_prevent_url_connect');

    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }

    immCinShtConn = WebViewController()
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
            if (request.url.startsWith(immPrvShtConn)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(immIfrmShtConn));

    setState(() {
      immLdIfrmShtConn = false ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
        },
        child: immLdIfrmShtConn ?const Center(child: CircularProgressIndicator(color: Colors.black),):
        WebViewWidget(
            gestureRecognizers: Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()
              )),
            controller: immCinShtConn),
      ),

    );
  }
}