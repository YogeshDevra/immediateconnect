// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quantumaiapp/AddedPortfolios.dart';
import 'package:quantumaiapp/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'ApiConfigConnect.dart';
import 'HomePage.dart';
import 'db/PortfolioDatabase.dart';
import 'models/PortfolioBitcoin.dart';

class AddCoinScreen extends StatefulWidget {
  String name;
  String fullName;
  String icon;
  String diffRate;
  double rate;
  AddCoinScreen(this.name, this.fullName, this.icon, this.diffRate, this.rate, {super.key});

  @override
  State<AddCoinScreen> createState() => _AddCoinScreenState();
}

class _AddCoinScreenState extends State<AddCoinScreen>{
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController? coinCountTextEditingController;
  final dbHelper = PortfolioDatabase.instance;
  List<PortfolioBitcoin> portfolios = [];
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    coinCountTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        portfolios.add(PortfolioBitcoin.fromMap(note));
      }
      setState(() {});
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
        title: Text(AppLocalizations.of(context)!.translate('add_coin')!,
            style: const TextStyle(fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xffF4F5F6), fontFamily: 'Gilroy-SemiBold')),
        backgroundColor: const Color(0xff000000),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(14.33),
              ),
                // width: MediaQuery.of(context).size.width/7,
                // height: MediaQuery.of(context).size.height/12,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FadeInImage(
                              height: MediaQuery.of(context).size.height/12,
                              width: MediaQuery.of(context).size.width/7,
                              placeholder: const AssetImage('assets/image/cob.png'),
                              // image: NetworkImage("${widget.cryptoData.icon}"),
                              image: NetworkImage(widget.icon),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width/3.5,
                                // child: Text("${widget.cryptoData.fullName}",
                                child: Text(widget.fullName,
                                    style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16.18,color: Color(0xff121212))),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                // double.parse(widget.cryptoData.diffRate!) >= 0 ?
                                double.parse(widget.diffRate) >= 0 ?
                                const Icon(Icons.arrow_drop_up_rounded, color: Color(0xff02BA36))
                                    : const Icon(
                                  Icons.arrow_drop_down_rounded, color: Color(0xffEF466F),
                                ),
                                // Text(double.parse(widget.cryptoData.diffRate!).toStringAsFixed(2),
                                Text(double.parse(widget.diffRate).toStringAsFixed(2),
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13,
                                        // color: double.parse(widget.cryptoData.diffRate!) >= 0
                                        color: double.parse(widget.diffRate) >= 0
                                            ? const Color(0xff02BA36): const Color(0xffEF466F))),
                              ],
                            ),
                            Container(
                                alignment: Alignment.topRight,
                                width: MediaQuery.of(context).size.width/3.5,
                                // child: Text("\$${widget.cryptoData.rate!.toStringAsFixed(2)}",
                                child: Text("\$${widget.rate.toStringAsFixed(2)}",
                                    style: const TextStyle(fontFamily:'Gilroy-Bold',fontWeight: FontWeight.w400,
                                        fontSize: 20,color: Color(0xff595959)
                                    )
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xffEFEFEF),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      // decoration: BoxDecoration(,
                      //     border: Border.all(color: Colors.white, width: 2)
                      // ),
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          controller: coinCountTextEditingController,
                          style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.end,
                          keyboardType: const TextInputType.numberWithOptions(signed: true,decimal: true),
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            hintText: 'Enter the number of coins',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 20,),
                            fillColor: Colors.black,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          ],
                          validator: (val) {
                            print('val $val');
                            if (coinCountTextEditingController!.text == "" || double.parse(coinCountTextEditingController!.value.text) <= 0) {
                              return AppLocalizations.of(context)!.translate('invalid_coins')!;
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // FadeInImage(
                //   placeholder: const AssetImage('assets/image/cob.png'),
                //   image: NetworkImage("${cryptoList[i].icon}"),
                // )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                _addSaveCoinsToLocalStorage(widget.name, widget.fullName,widget.icon, widget.diffRate,widget.rate);
              },
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/14,
                width: MediaQuery.of(context).size.width/1.5,
                decoration: const BoxDecoration(
                    color: Color(0xff777E90),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Text(AppLocalizations.of(context)!.translate('add_coin')!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400,
                    color: Color(0xffFFFFFF), fontFamily: 'Gilroy-SemiBold'),textAlign: TextAlign.center),
              ),
            ),
          )
        ],
      ),
    );
  }
  // _addSaveCoinsToLocalStorage(CryptoData cryptoData) async {
  _addSaveCoinsToLocalStorage(String name, String fullName, String icon, String diffRate, double rate) async {
    if (_formKey2.currentState!.validate()) {
      if (portfolios.isNotEmpty) {
        PortfolioBitcoin? bitcoinLocal = portfolios.firstWhereOrNull((element) => element.name == name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            PortfolioDatabase.columnName: bitcoinLocal.name,
            PortfolioDatabase.columnFullName: bitcoinLocal.fullName,
            PortfolioDatabase.columnIcon: bitcoinLocal.icon,
            PortfolioDatabase.columnRateDuringAdding: rate,
            PortfolioDatabase.columnDiffRate: diffRate,
            PortfolioDatabase.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            PortfolioDatabase.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate) + bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
          print('Updated row id: $id');
          ApiConfigConnect.toastMessage(message: '${bitcoinLocal.fullName} ${AppLocalizations.of(context)!.translate('update_portfolio')!}');
        } else {
          Map<String, dynamic> row = {
            PortfolioDatabase.columnName: name,
            PortfolioDatabase.columnFullName: fullName,
            PortfolioDatabase.columnIcon: icon,
            PortfolioDatabase.columnRateDuringAdding: rate,
            PortfolioDatabase.columnDiffRate: diffRate,
            PortfolioDatabase.columnCoinsQuantity: double.parse(coinCountTextEditingController!.value.text),
            PortfolioDatabase.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) * (rate),
          };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
          ApiConfigConnect.toastMessage(message: '$fullName ${AppLocalizations.of(context)!.translate('add_portfolio')!}');
        }
      } else {
        Map<String, dynamic> row = {
          PortfolioDatabase.columnName: name,
          PortfolioDatabase.columnFullName: fullName,
          PortfolioDatabase.columnIcon: icon,
          PortfolioDatabase.columnRateDuringAdding: rate,
          PortfolioDatabase.columnDiffRate: diffRate,
          PortfolioDatabase.columnCoinsQuantity: double.parse(coinCountTextEditingController!.text),
          PortfolioDatabase.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) * (rate),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
        ApiConfigConnect.toastMessage(message: '$fullName ${AppLocalizations.of(context)!.translate('add_portfolio')!}');
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddedPortfolioScreen()));
    } else {}
  }
}