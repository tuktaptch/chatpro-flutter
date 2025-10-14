import 'package:chat_pro/authentication/login/login_screen_provider.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/assets_manager.dart';
import 'package:chat_pro/utilities/country_picker_helper.dart';
import 'package:chat_pro/widgets/c_text_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/authentication/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AssetsManager.bg2Image, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 160,
                    width: 200,
                    child: Lottie.asset(AssetsManager.chatBubble),
                  ),
                  Text(
                    'Chat Pro',
                    style: CTypography.display1.copyWith(
                      color: CColors.hotPink,
                    ),
                  ),
                  ConstSpacer.height18(),
                  Text(
                    "Add your phone number will send you a code to verify",
                    style: CTypography.title.copyWith(color: CColors.darkGray),
                    textAlign: TextAlign.center,
                  ),
                  ConstSpacer.height18(),
                  const PhoneNumberField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return CTextField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      prefixIcon: const PhoneNumberPrefixIcon(),
      controller: context.read<LoginScreenProvider>().controller,
      onChanged: (value) =>
          context.read<LoginScreenProvider>().updatePhoneNumber(value),
      suffixIcon: const PhoneNumberSuffixIcon(),
      borderColor: CColors.vividPink,
      placeHolderText: 'Phone number',
    );
  }
}

class PhoneNumberPrefixIcon extends StatelessWidget {
  const PhoneNumberPrefixIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LoginScreenProvider, Country>(
      selector: (_, provider) => provider.selectedCountry,
      builder: (_, selectedCountry, __) {
        return Container(
          padding: const EdgeInsets.only(top: 14, left: 8, right: 8),
          child: InkWell(
            onTap: () => showCustomCountryPicker(
              context: context,
              onCountrySelected: (country) {
                context.read<LoginScreenProvider>().updateSelectedCountry(
                  country,
                );
              },
            ),
            child: Text(
              '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
              style: CTypography.caption2.copyWith(color: CColors.darkGray),
            ),
          ),
        );
      },
    );
  }
}

class PhoneNumberSuffixIcon extends StatelessWidget {
  const PhoneNumberSuffixIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Selector<LoginScreenProvider, int>(
      selector: (_, prov) => prov.controller.text.length,
      builder: (_, textLength, __) {
        if (textLength <= 8) {
          return const SizedBox.shrink();
        }
        if (authProvider.isLoading) {
          return CircularProgressIndicator();
        }
        // กรณีพร้อมส่งเบอร์โทร
        return InkWell(
          onTap: () {
            final prov = context.read<LoginScreenProvider>();
            authProvider.signInWithPhoneNumber(
              phoneNumber:
                  '+${prov.selectedCountry.phoneCode}${prov.controller.text}',
              context: context,
            );
          },
          child: Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: CColors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.done, color: CColors.pureWhite, size: 20),
          ),
        );
      },
    );
  }
}
