import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustFontstyle extends StatelessWidget {
  final String? label;
  final double? fontsize;
  final double? fontspace;
  final FontWeight? fontweight;
  final Color? fontcolor;
  final TextAlign? fontalign;

  const CustFontstyle({
    super.key,
    this.label,
    this.fontsize,
    this.fontspace,
    this.fontweight,
    this.fontcolor,
    this.fontalign,
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

  const CustTimeNewRoman({
    super.key,
    this.label,
    this.fontsize,
    this.fontspace,
    this.fontweight,
    this.fontcolor,
    this.fontalign,
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
      ),
    );
  }
}
