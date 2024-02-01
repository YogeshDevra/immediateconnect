import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Trends extends StatefulWidget{

  const Trends({super.key});


  @override
  _TrendsState createState() => _TrendsState();

}
class _TrendsState extends State<Trends> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  String _type = 'Month';
  String name = "";
  @override
  void initState(){
    Trendsdetail();
    super.initState();
  }
  Future<void> Trendsdetail() async {
    print(_type);
    final SharedPreferences prefs = await _sprefs;

    var currName = prefs.getString("Symbol") ?? 'A';
    name = currName;
    var uri = "http://161.97.157.232:8085/Bitcoin/resources/getBitcoinCryptoGraph?type=${_type}&name=${name}&currency=USD";


        print(uri);
        var response = await get(Uri.parse(uri));
        //  print(response.body);
        final data = json.decode(response.body) as Map;
        //print(data);
        if (data['error'] == false) {
          setState(() {
            TrendList = data['data'].map<Trenddata>((json) =>
                Trenddata.fromJson(json)).toList();
            diffRate = double.parse(data['diffRate']);
            price = data['data'][0]['price'];
            currencyData = [];
            TrendList.forEach((element) {
              currencyData.add(new CartData(element.date!, element.price!));
            });
            print("currency data"+currencyData.length.toString());
            isLoading = false;
          });
        }
        else {
          //  _ackAlert(context);

        }
      } catch (e) {
        toastMessage(message: 'error occured while fetching data');
        setState(() {
          isLoading = false;
        });
      }
    }else {
      toastMessage(message: 'no internet');
      setState(() {
        isLoading = false;
      });
    }internetConnection();

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Trends',style: TextStyle(fontFamily: 'Gilroy-SemiBold',fontWeight: FontWeight.w400,fontSize: 27.39),

        ),
      ),
      backgroundColor: Colors.black,

    );
  }

}