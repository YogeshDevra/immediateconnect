
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'ImmCoinsPage.dart';
import 'ImmHomePage.dart';
import 'ImmMorePage.dart';
import 'ImmPortfolioPage.dart';
import 'ImmWebPage.dart';

class ImmNavigationPage extends StatefulWidget{
  const ImmNavigationPage({super.key});

  @override
  State<ImmNavigationPage> createState() => _ImmNavigationPageState();
}

class _ImmNavigationPageState extends State<ImmNavigationPage> {
  int selectIndex = 0;
  final PageStorageBucket imBucket = PageStorageBucket();

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
        child: widgetOptions.elementAt(selectIndex),
        bucket: imBucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>ImmWebPage()));
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffFFC727),
        child: Image.asset('assets/icons/plus.png'),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,

        padding: const EdgeInsets.all(10),
        child: Container(
          height: 84,
          //color: const Color(0xffFFFFFF),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 30),
              child: buildNavItem(0, 'images/onlyIcons/imGroup_515.png'),),
              const Spacer(),
              buildNavItem(1, 'images/onlyIcons/imComponent 3.png'),
              // const SizedBox(width: 85,),
              const Spacer(),
              buildNavItem(2, 'images/onlyIcons/im_wallet.png'),
              const Spacer(),
              Padding(padding: EdgeInsets.only(right: 30),
              child:buildNavItem(3, 'images/onlyIcons/im_user_icon.png'),),
            ],
          ),
        ),
      ),

    );
  }


  final List widgetOptions = [
    const ImmHomePage(
      key: PageStorageKey('homePageId'),
    ),
     const ImmPortfolioPage(
      key: PageStorageKey('myPortfolioPageId'),
    ),
    const ImmCoinsPage(
      key: PageStorageKey('coinPageId'),
    ),
    const ImmMorePage(
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