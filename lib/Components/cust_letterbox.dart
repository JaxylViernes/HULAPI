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
  return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: letter.color, width: 2),
        color: letter.color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
          child: CustFontstyle(
        fontsize: 17,
        fontcolor: Colors.white,
        fontweight: FontWeight.bold,
        label: letter.letter,
      )));
}
