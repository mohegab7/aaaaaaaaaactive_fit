import 'package:flutter/material.dart';

class DynamicOntLogo extends StatelessWidget {
  const DynamicOntLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light
          ? 'assets/icon/active_logo_square.png'
          : 'assets/icon/active_logo_square_light.png',
    );
  }
}
