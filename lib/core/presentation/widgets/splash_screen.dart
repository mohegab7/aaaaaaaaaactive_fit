import 'package:flutter/material.dart';
import 'package:active_fit/core/utils/navigation_options.dart';

class SplashScreen extends StatefulWidget {
  final bool userInitialized;

  const SplashScreen({super.key, required this.userInitialized});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToInitialRoute();
  }

  void _navigateToInitialRoute() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(widget.userInitialized
        ? NavigationOptions.loginScreen
        : NavigationOptions.onboardingRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/icon/active_banner_top.png'
              : 'assets/icon/Active_banner_top_light.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
