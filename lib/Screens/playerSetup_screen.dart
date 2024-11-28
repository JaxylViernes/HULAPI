import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/playerData.dart';
import 'package:basic/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'FUNCTION/func_playerSetup.dart';

class PlayersetupScreen extends StatefulWidget {
  const PlayersetupScreen({super.key});

  @override
  _PlayersetupScreenState createState() => _PlayersetupScreenState();
}

class _PlayersetupScreenState extends State<PlayersetupScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerSetupViewModel(),
      child: Consumer<PlayerSetupViewModel>(
        builder: (context, viewModel, _) {
          // Listen for page changes
          viewModel.pageController.addListener(() {
            viewModel.onPageChanged(viewModel.pageController.page!);
          });

          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImage().SETUP),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(setResponsiveSize(context, baseSize: 200)),
                          CustFontstyle(
                            fontalign: TextAlign.center,
                            label:
                                'Lagdaan ang pangalan at pumili nang avatar na iyong gusto para makapaglaro',
                            fontsize: 16,
                            fontcolor: AppColor().white,
                            fontweight: FontWeight.w500,
                          ),
                          Gap(setResponsiveSize(context, baseSize: 20)),
                          _buildNameInputField(viewModel),
                          Gap(setResponsiveSize(context, baseSize: 30)),
                          _buildAvatarRow(viewModel),
                          Gap(setResponsiveSize(context, baseSize: 100)),
                          ElevatedButton(
                            onPressed: () {
                              // Create a Player object with the entered name and default avatar/image
                              Player player = Player(
                                name: viewModel.nameController.text,
                                image: viewModel.avatarImages[
                                    viewModel.selectedAvatarIndex],
                                level: 1,
                                score: 0,
                              );

                              // Proceed to start the game by passing context and player
                              viewModel.startGame(context, player);
                            },
                            style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 18),
                              ),
                              elevation: WidgetStateProperty.all<double>(4),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  AppColor().yellow),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: AppColor().white, width: 4),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            child: CustFontstyle(
                              label: 'Isumite',
                              fontsize: 25,
                              fontcolor: AppColor().black,
                              fontweight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameInputField(PlayerSetupViewModel viewModel) {
    return TextField(
      textAlign: TextAlign.center,
      controller: viewModel.nameController,
      decoration: InputDecoration(
        hintText: 'Pangalan',
        hintStyle: TextStyle(
          color: AppColor().darkGrey.withOpacity(0.8),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        labelStyle: TextStyle(
          color: AppColor().dark,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColor().white,
        border: viewModel.borderCust,
        enabledBorder: viewModel.borderCust,
        focusedBorder: viewModel.borderCust,
        contentPadding: const EdgeInsets.all(15),
      ),
      style: TextStyle(
        color: AppColor().dark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAvatarRow(PlayerSetupViewModel viewModel) {
    return Column(
      children: [
        CustFontstyle(
          label: 'Pumili ng avatar:',
          fontsize: 18,
          fontcolor: AppColor().white,
          fontweight: FontWeight.w500,
        ),
        const Gap(15),
        Container(
          height: setResponsiveSize(context, baseSize: 150),
          decoration: BoxDecoration(
            color: AppColor().white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(setResponsiveSize(context, baseSize: 10)),
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.avatarImages.length,
                itemBuilder: (context, index) {
                  final isSelected = viewModel.selectedAvatarIndex == index;

                  return GestureDetector(
                    onTap: () {
                      viewModel.selectedAvatarIndex = index;
                      viewModel.notifyListeners();
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: setResponsiveSize(context,
                                baseSize: isSelected ? 100 : 80),
                            width: setResponsiveSize(context,
                                baseSize: isSelected ? 100 : 80),
                            decoration: BoxDecoration(
                              color: viewModel.listBackground[index],
                              border: Border.all(
                                color: isSelected
                                    ? AppColor().darkGrey
                                    : Colors.transparent,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:
                                    AssetImage(viewModel.avatarImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: AppColor().white,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
