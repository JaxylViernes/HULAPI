import 'package:basic/helpers/app_init.dart';
import 'package:flutter/material.dart';
import '../models/letter.dart';
import 'cust_fontstyle.dart';

// ignore: non_constant_identifier_names
Widget CustLetterbox(Letter letter, {Color textColor = Colors.black}) {
  int size = letter.letter.length == 4
      ? 50
      : letter.letter.length == 5
          ? 50
          : letter.letter.length == 6
              ? 50
              : 43;

  // Check if letter.color is activated (not equal to a default or inactive color)
  bool isActivated = letter.color !=
      Colors.white; // You can also check for any other default inactive color

  print('Letter color: ${letter.color}');

  Color fontcolor = letter.letter.length == 4
      ? Application().color.white
      : letter.letter.length == 5
          ? Application().color.white
          : letter.letter.length == 6
              ? Application().color.white
              : Application().color.white;

  // If not activated, use Colors.white; else use letter.color
  Color borderColor = isActivated ? Colors.white : letter.color;
  Color boxColor = isActivated ? letter.color : Colors.white;

  return Container(
    width: size.toDouble(),
    height: size.toDouble(),
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor, width: 2),
      color: boxColor,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Center(
        child: CustFontstyle(
      fontsize: 17,
      fontcolor: fontcolor,
      fontweight: FontWeight.bold,
      label: letter.letter,
    )),
  );
}
