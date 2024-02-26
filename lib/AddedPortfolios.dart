// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quantumaiapp/UpdateCoinScreen.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConfigConnect.dart';
import 'HomePage.dart';
import 'db/PortfolioDatabase.dart';
import 'models/PortfolioBitcoin.dart';

class AddedPortfolioScreen extends StatefulWidget {
  const AddedPortfolioScreen({super.key});

  @override
  State<AddedPortfolioScreen> createState() => _AddedPortfolioScreenState();
}

class _AddedPortfolioScreenState extends State<AddedPortfolioScreen> {
  TextEditingController? coinCountTextEditingController;
  final dbHelper = PortfolioDatabase.instance;
  List<PortfolioBitcoin> portfolios = [];
  SharedPreferences? sharedPreferences;
  double totalValuesOfPortfolio = 0.0;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    coinCountTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        portfolios.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      }
      print('portfolio ${portfolios.length}');
      setState(() {
        loading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        title: Text(AppLocalizations.of(context)!.translate('added_coin')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xffffffff)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('${AppLocalizations.of(context)!.translate('total_portfolio')!} \n ${totalValuesOfPortfolio.toStringAsFixed(2)}'),
              ),
            ),
          ),
          loading ? const Center(child: CircularProgressIndicator(color: Color(0xffffffff))) :
          portfolios.isEmpty ? Center(
              child: Text(AppLocalizations.of(context)!.translate('no_portfolio_added')!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25,color: Color(0xffffffff)))
          ) : ListView.builder(
              shrinkWrap: true,
              itemCount: portfolios.length,
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
                                        child:Image.network(portfolios[i].icon,width: 30,height: 30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width/4,
                                          child: Text(portfolios[i].fullName,
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
                                            double.parse(portfolios[i].diffRate) >= 0 ?
                                            const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                                : const Icon(
                                              Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                            ),
                                            Text(double.parse(portfolios[i].diffRate).toStringAsFixed(2),
                                                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                                    color: double.parse(portfolios[i].diffRate) >= 0 ? const Color(0xff02BA36): const Color(0xffEF466F))),
                                          ],
                                        ),
                                        Container(
                                            alignment: Alignment.topRight,
                                            width: MediaQuery.of(context).size.width/3.5,
                                            child: Text("\$${portfolios[i].rateDuringAdding.toStringAsFixed(2)}",
                                                style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                                    fontSize: 20,color: Color(0xff595959)
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${AppLocalizations.of(context)!.translate('coins')!} : ${portfolios[i].numberOfCoins}',
                                    style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xff000000)),),
                                  Text(portfolios[i].totalValue.toStringAsFixed(2),
                                    style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xff000000)),),
                                ],
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: MediaQuery.of(context).size.width/5,
                        top: MediaQuery.of(context).size.width/2.8,
                        child:Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCoinScreen(portfolios[i])));
                                },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xff5C428F)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(AppLocalizations.of(context)!.translate('update')!,
                                    style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xffffffff)),),
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            InkWell(
                              onTap: () {
                                _deleteCoinsToLocalStorage(portfolios[i]);
                                                            },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffEF466F)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(AppLocalizations.of(context)!.translate('remove')!,
                                    style: const TextStyle(fontFamily: 'Gilroy-Bold', fontWeight: FontWeight.w400, fontSize: 15,color: Color(0xffffffff)),),
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
  _deleteCoinsToLocalStorage(PortfolioBitcoin portfolioBitcoin) async {
    setState(() async {
      final  id = await dbHelper.delete(portfolioBitcoin.name);
      print('delete row id: $id');
      ApiConfigConnect.toastMessage(message: '${portfolioBitcoin.fullName} ${AppLocalizations.of(context)!.translate('delete_portfolio')!}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddedPortfolioScreen()),);
    });
  }
}