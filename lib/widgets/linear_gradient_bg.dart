import 'package:chat_pro/constraints/c_colors.dart';
import 'package:flutter/material.dart';

class LinearGradientBackground extends StatelessWidget {
  const LinearGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CColors.hotPink.withAlpha(50),
              CColors.pinkOrange.withAlpha(30),
              CColors.salmonPink.withAlpha(20),
            ],
            stops: const [
              0.0, // เริ่มต้น
              0.5, // ครึ่งทาง
              1.0, // สุดท้าย
            ],
          ),
        ),
      ),
    );
  }
}
