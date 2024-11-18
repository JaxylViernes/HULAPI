import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'FUNCTION/func_playerSetup.dart';

class PlayersetupScreen extends StatefulWidget {
  const PlayersetupScreen({super.key});

  @override
  _PlayersetupScreenState createState() => _PlayersetupScreenState();
}

class _PlayersetupScreenState extends State<PlayersetupScreen>
    with SingleTickerProviderStateMixin {
  List<String> letters = ["H", "U", "L", "A", "P", "I"];
  List<Animation<double>> animations = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat animation

    for (int i = 0; i < letters.length; i++) {
      animations
          .add(Tween<double>(begin: 0, end: i % 2 == 0 ? -10 : 10).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.1, // Delay start of each letter animation
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            body: Stack(
              children: [
                _buildBackground(),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildWordleTitle(viewModel),
                        const Gap(100),
                        _buildNameInputField(viewModel),
                        const Gap(30),
                        _buildAvatarGrid(viewModel),
                        const Gap(100),
                        _buildStartGameButton(viewModel, context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWordleTitle(PlayerSetupViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(letters.length, (index) {
        return AnimatedBuilder(
          animation: animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, animations[index].value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: viewModel.listOfColors[index].withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor().white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  letters[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.pressStart2p().fontFamily,
                    color: AppColor().white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage().back),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildNameInputField(PlayerSetupViewModel viewModel) {
    return TextField(
      textAlign: TextAlign.center,
      controller: viewModel.nameController,
      decoration: InputDecoration(
        labelText: 'Pangalan: ',
        labelStyle: TextStyle(
          color: AppColor().white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColor().white.withOpacity(0.1),
        border: viewModel.borderCust,
        enabledBorder: viewModel.borderCust,
        focusedBorder: viewModel.borderCust,
        contentPadding: const EdgeInsets.all(20),
      ),
      style: TextStyle(
          color: AppColor().white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.poppins().fontFamily),
    );
  }

  Widget _buildAvatarGrid(PlayerSetupViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor().white, width: 1),
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustFontstyle(
            label: 'Pumili ng avatar:',
            fontsize: 18,
            fontcolor: AppColor().white,
            fontweight: FontWeight.w500,
          ),
          const Gap(15),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: viewModel.avatarImages.length,
            itemBuilder: (context, index) {
              final isSelected = viewModel.selectedAvatarIndex == index;

              return GestureDetector(
                onTap: () {
                  viewModel.selectedAvatarIndex =
                      index; // Update selected index
                  viewModel.notifyListeners(); // Notify listeners for UI update
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: viewModel.listBackground[index],
                        border: Border.all(
                          color: isSelected
                              ? AppColor().white
                              : Colors.transparent,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(viewModel.avatarImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(
                          Icons.check_circle,
                          color: AppColor().white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartGameButton(
      PlayerSetupViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().white, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () {
        viewModel.startGame(context);
      },
      child: Text(
        'MAGLARO NA',
        style: TextStyle(
          fontSize: 17,
          letterSpacing: 0.5,
          color: AppColor().white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
