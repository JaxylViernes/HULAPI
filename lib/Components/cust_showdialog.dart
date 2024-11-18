import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../helpers/app_init.dart';
import 'cust_fontstyle.dart';

class ShowDialogHelper with Application {
  static Future<void> showHowToPlay(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 750,
                    decoration: BoxDecoration(
                      color: AppColor().white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustTimeNewRoman(
                            label: '▣ Paano Laruin:',
                            fontsize: 20,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w900,
                          ),
                          const Divider(),
                          const Gap(5),
                          CustTimeNewRoman(
                            label: 'Hulaan ang salita sa loob ng 6 na subok.',
                            fontsize: 14,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w500,
                          ),
                          const Gap(10),
                          CustTimeNewRoman(
                            label:
                                '▪ Ang bawat hula ay dapat maging isang wastong salita na may 5 titik.',
                            fontsize: 14,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w500,
                          ),
                          const Gap(10),
                          CustTimeNewRoman(
                            label:
                                '▪ Nagbabago ang kulay ng kahon upang ipakita kung gaano kalapit ang iyong hula sa tamang sagot.',
                            fontsize: 14,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w500,
                          ),
                          const Gap(20),
                          CustTimeNewRoman(
                            label: 'Halimbawa:',
                            fontsize: 15,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w700,
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLetterBox('B',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('E',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('N',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('T',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('E',
                                  color: Colors.grey, fontcolor: Colors.white),
                            ],
                          ),
                          const Gap(10),
                          Center(
                            child: CustTimeNewRoman(
                              fontalign: TextAlign.center,
                              label:
                                  'Ang letrang B ay nasa tamang puwesto ng salita.',
                              fontsize: 14,
                              fontcolor: AppColor().dark,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLetterBox('B',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('E',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('N',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('T',
                                  color: Colors.grey, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('A',
                                  color: Colors.amber, fontcolor: Colors.white),
                            ],
                          ),
                          const Gap(10),
                          Center(
                            child: CustTimeNewRoman(
                              fontalign: TextAlign.center,
                              label:
                                  'Ang letrang A ay nasa tamang salita ngunit nasa maling puwesto.',
                              fontsize: 14,
                              fontcolor: AppColor().dark,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLetterBox('B',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('A',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('Y',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('A',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('D',
                                  color: Colors.grey, fontcolor: Colors.white),
                            ],
                          ),
                          const Gap(10),
                          Center(
                            child: CustTimeNewRoman(
                              label: 'Ang letrang D ay wala sa tamang salita.',
                              fontsize: 14,
                              fontcolor: AppColor().dark,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                          const Gap(30),
                          CustTimeNewRoman(
                            label: 'Tamang Sagot:',
                            fontsize: 15,
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.w700,
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLetterBox('B',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('A',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('Y',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('A',
                                  color: Colors.green, fontcolor: Colors.white),
                              const Gap(5),
                              _buildLetterBox('N',
                                  color: Colors.green, fontcolor: Colors.white),
                            ],
                          ),
                          const Gap(10),
                          Center(
                            child: CustTimeNewRoman(
                              label: 'Tamang Hula: BAYANAN! ⭐',
                              fontsize: 14,
                              fontcolor: AppColor().dark,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor().dark, width: 2),
                        ),
                        child: Center(
                          child: CustFontstyle(
                            label: 'X',
                            fontcolor: AppColor().dark,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildLetterBox(String letter,
      {Color color = Colors.transparent,
      Color fontcolor = Colors.transparent}) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: CustFontstyle(
          label: letter,
          fontcolor: fontcolor,
          fontweight: FontWeight.bold,
        ),
      ),
    );
  }
}
