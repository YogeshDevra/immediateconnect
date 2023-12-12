
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:newproject/MorePage.dart';
import 'package:newproject/homepage.dart';
import 'package:newproject/portfolio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Iframe.dart';
import 'coins.dart';

class NavigationPage extends StatefulWidget{
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  SharedPreferences? sharedPreferences;
  int _selectedIndex = 0;
  String? languageCodeSaved;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    // final newVersion = NewVersionPlus(
    //     iOSId: 'com.example.newproject',
    //     iOSAppStoreCountry: 'GB'
    // );
    // Timer(const Duration(milliseconds: 800),() {
    //   versionUpdate(newVersion);
    // });
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
        child: _widgetOptions.elementAt(_selectedIndex),
        bucket: bucket,
      ),
      // bottomNavigationBar: _bottomNav,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>IframeHomePage()));
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffFFC727),
        child: Image.asset('assets/icons/plus.png'),
      ),
      // floatingActionButton: _fab,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Spacer(),
            _buildNavItem(0, 'assets/icons/Group 515.png'),
            const Spacer(),
            _buildNavItem(1, 'assets/icons/Component 3.png'),
            const SizedBox(width: 85,),
            const Spacer(),
            _buildNavItem(2, 'assets/icons/wallet.png'),
            const Spacer(),
            _buildNavItem(3, 'assets/icons/user_icon.png'),
            const Spacer(),
          ],
        ),
      ),

    );
  }

  final List _widgetOptions = [
    const HomePage(
      key: PageStorageKey('homePageId'),
    ),
     const PortfolioPage(
      key: PageStorageKey('myPortfolioPageId'),
    ),
    const CoinsPage(
      key: PageStorageKey('coinPageId'),
    ),
    const MorePage(
      key: PageStorageKey('morePageId'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  Widget _buildNavItem(int index, String imagePath) {
    return InkWell(
      onTap: () {
        _onItemTapped(index);
      },
      child: Image.asset(
        imagePath,
        // Change the color based on the selected index
        color: _selectedIndex == index ? Colors.black : Colors.grey,
      ),
    );
  }
}