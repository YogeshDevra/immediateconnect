import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return Color(int.parse(hexColor, radix: 16));
}

Color getPrimaryColor() {
  return getColorFromHex("#1264FF");
}

Color getAllappBackground() {
  return getColorFromHex("#FAFAFA");
}

Color getDarkBackground() {
  return getColorFromHex("#E9EDF6");
}

Color getTextDarkBackground1() {
  return getColorFromHex("#868990");
}

Color getGradient1Color() {
  return getColorFromHex("#272735");
}

Color getGradient2Color() {
  return getColorFromHex("#217EFD");
}

Color getTrend1Color() {
  return getColorFromHex("#ECECEC");
}

Color getTrend2Color() {
  return getColorFromHex("#E9FEC5");
}

Color getAddButtonColor() {
  return getColorFromHex("#E8E8E8");
}

Color getConBckColor() {
  return getColorFromHex("#D1D6E0");
}

Color getappBarTextColor() {
  return getColorFromHex("#2D2E31");
}

Color getPortTextColor() {
  return getColorFromHex("#868990");
}
