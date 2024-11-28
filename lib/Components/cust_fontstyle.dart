import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustFontstyle extends StatelessWidget {
  final String? label;
  final double? fontsize;
  final double? fontspace;
  final FontWeight? fontweight;
  final Color? fontcolor;
  final TextAlign? fontalign;

  final TextDecoration? fontDecoration;

  const CustFontstyle({
    super.key,
    this.label,
    this.fontsize,
    this.fontspace,
    this.fontweight,
    this.fontcolor,
    this.fontalign,
    this.fontDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label ?? '',
      textAlign: fontalign,
      style: GoogleFonts.poppins(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: fontcolor,
        letterSpacing: fontspace,
        decoration: fontDecoration,
      ),
    );
  }
}

class CustTimeNewRoman extends StatelessWidget {
  final String? label;
  final double? fontsize;
  final double? fontspace;
  final FontWeight? fontweight;
  final Color? fontcolor;
  final TextAlign? fontalign;

  final TextDecoration? fontDecoration;

  const CustTimeNewRoman({
    super.key,
    this.label,
    this.fontsize,
    this.fontspace,
    this.fontweight,
    this.fontcolor,
    this.fontalign,
    this.fontDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label ?? '',
      textAlign: fontalign,
      style: GoogleFonts.lora(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: fontcolor,
        letterSpacing: fontspace,
        decoration: fontDecoration,
      ),
    );
  }
}
