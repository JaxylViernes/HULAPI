import 'package:basic/helpers/app_init.dart';
import 'package:flutter/material.dart';

class CustKeyboard extends StatelessWidget {
  const CustKeyboard({super.key, this.children, this.color});
  final Widget? children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: color ?? Application().color.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: children,
      ),
    );
  }
}
