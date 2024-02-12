import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiConfigConnect{
  static bool hideValue = false;
  static String apiUrl = 'http://161.97.157.232:8085';
  static String webUrl = 'https://d3lghnkitl0gac.cloudfront.net/pearl/?source_id=ImmediateConnect';
  static String preventUrl = 'www';

  static Future<bool> internetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }

  static Future<void> toastMessage({required String message}) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}