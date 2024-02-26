// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, library_private_types_in_public_api, non_constant_identifier_names

import 'package:quantumaiapp/HomePage.dart';
import 'package:quantumaiapp/db/WishListDatabase.dart';
import 'package:flutter/material.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConfigConnect.dart';
import 'models/CryptoData.dart';

class WishListScreen extends StatefulWidget{
  const WishListScreen({super.key});

  @override
  _WishListScreenState createState() => _WishListScreenState();
}
class _WishListScreenState extends State<WishListScreen>{
  SharedPreferences? sharedPreferences;
  final dbHelperr = WishListDatabase.instancee;
  bool loading = false;
  double diffRate = 0;
  List <CryptoData> Wishlist = [];

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    // BuyshareAnalytics.setCurrentScreen(BuyshareAnalytics.Watchlist_SCREEN, "Shares Sphere watchlist");
    dbHelperr.queryAllRows().then((notes) {
      for (var note in notes) {
        Wishlist.add(CryptoData.fromJson(note));
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

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
        title: Text(AppLocalizations.of(context)!.translate('wish_list')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      backgroundColor: const Color(0xff000000),
      body: loading ? const Center(child: CircularProgressIndicator()) :
      Wishlist.isEmpty ? Center(
          child: Text(AppLocalizations.of(context)!.translate('home_15')!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25,color: Color(0xffffffff)))
      ): ListView.builder(
          shrinkWrap: true,
          itemCount: Wishlist.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context,int i){
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(20),
                  child:Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                    color:const Color(0xffFFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child:Image.network('${Wishlist[i].icon}',width: 30,height: 30),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width/4,
                                      child: Text('${Wishlist[i].fullName}',
                                          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-SemiBold',
                                            color: Color(0xff000000),overflow: TextOverflow.ellipsis,),maxLines: 2),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        double.parse(Wishlist[i].diffRate!) >= 0 ?
                                        const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                            : const Icon(
                                          Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                        ),
                                        Text(double.parse(Wishlist[i].diffRate!).toStringAsFixed(2),
                                            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                                color: double.parse(Wishlist[i].diffRate!) >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F))),
                                      ],
                                    ),
                                    Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width/3.5,
                                        child: Text("\$${Wishlist[i].rate!.toStringAsFixed(2)}",
                                            style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                                fontSize: 20,color: Color(0xff595959)
                                            )
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     _deleteCoinsToLocalStorage(Wishlist[i]);
                              //     // Ensure that 'i' is a valid index
                              //   },
                              //   child: const Icon(
                              //     Icons.delete,
                              //     color: Colors.blue,
                              //     size: 23,
                              //   ),
                              // ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: MediaQuery.of(context).size.width/5,
                    top: MediaQuery.of(context).size.width/3.2,
                    child:InkWell(
                      onTap: () {
                        _deleteCoinsToLocalStorage(Wishlist[i]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffEF466F)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(AppLocalizations.of(context)!.translate('home_16')!,
                            style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xffffffff)),),
                        ),
                      ),
                    )
                )
              ],
            );
          }
      ),
    );
  }

  _deleteCoinsToLocalStorage(CryptoData cryptoData) async {
    setState(() async {
      final  id = await dbHelperr.delete(cryptoData.symbol!);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '${cryptoData.fullName} ${AppLocalizations.of(context)!.translate('delete_watchlist')}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WishListScreen()),
      );
    });
  }
}