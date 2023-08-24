// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:awesome_loader_null_safety/awesome_loader_null_safety.dart';
import 'package:flutter/material.dart';

import 'ImmUtilCon/ImmColorCon.dart';

class ImmLoadBitCon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader2,
        color: getColorFromHex("#217EFD"),
      ),
    );
  }
}
