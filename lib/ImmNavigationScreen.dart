
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ImmCoinsScreen.dart';
import 'ImmHomeScreen.dart';
import 'ImmMoreScreen.dart';
import 'ImmPortfolioScreen.dart';
import 'ImmFrameScreen.dart';

class ImmNavigationPage extends StatefulWidget{
  const ImmNavigationPage({super.key});

  @override
  State<ImmNavigationPage> createState() => _ImmNavigationPageState();
}

class _ImmNavigationPageState extends State<ImmNavigationPage> {
  int selectIndex = 0;
  final PageStorageBucket imBucket = PageStorageBucket();
  final Future<SharedPreferences> sprefs = SharedPreferences.getInstance();
  String? lanCodeSaved;

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersionPlus(
        androidId: 'com.scode.immediateconnectapp',
    );
    Timer(const Duration(milliseconds: 800),() {
      versionUpdate(newVersion);
    });
    immGetSharedPrefData();
  }
  Future<void> immGetSharedPrefData() async {
    final SharedPreferences prefs = await sprefs;
    setState(() {
      lanCodeSaved = prefs.getString('language_code') ?? "en";
    });
  }
  void versionUpdate(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if(status!=null){
      if(status.canUpdate){
        newVersion.showUpdateDialog(
          context: context,
          versionStatus:status,
          dialogTitle:'Update Available!!!',
          dialogText:'Please Update Your App',
          allowDismissal: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: PageStorage(
        child: widgetOptions.elementAt(selectIndex),
        bucket: imBucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>ImmFrameScreen()));
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffFFC727),
        child: Image.asset('images/onlyIcons/imPlus.png',color: Colors.black),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Spacer(),
            buildNavItem(0, 'images/onlyIcons/imGroup_515.png'),
            const Spacer(),
            buildNavItem(1, 'images/onlyIcons/imComponent 3.png'),
            const SizedBox(width: 85,),
            // const Spacer(),
            buildNavItem(2, 'images/onlyIcons/im_wallet.png'),
            const Spacer(),
            buildNavItem(3, 'images/onlyIcons/im_user_icon.png'),
            const Spacer(),
          ],
        ),
      ),

    );
  }


  final List widgetOptions = [
    const ImmHomeScreen(
      key: PageStorageKey('homePageId'),
    ),
     const ImmPortfolioScreen(
      key: PageStorageKey('myPortfolioPageId'),
    ),
    const ImmCoinsScreen(
      key: PageStorageKey('coinPageId'),
    ),
    const ImmMoreScreen(
      key: PageStorageKey('morePageId'),
    ),
  ];


  void onItemTapped(int index) {
    setState(() {
      selectIndex = index;
      print(selectIndex);
    });
  }

  Widget buildNavItem(int index, String imagePath) {
    return InkWell(
      onTap: () {
        onItemTapped(index);
      },
      child: Image.asset(
        imagePath,
        // Change the color based on the selected index
        color: selectIndex == index ? Colors.black : Colors.grey,
      ),
    );
  }

}