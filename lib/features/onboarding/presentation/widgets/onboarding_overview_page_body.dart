import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';

class OnboardingOverviewPageBody extends StatefulWidget {
  final String calorieGoalDayString;
  final String carbsGoalString;
  final String fatGoalString;
  final String proteinGoalString;
  final Function(bool active) setButtonActive;
  final double? totalKcalCalculated;

  const OnboardingOverviewPageBody(
      {super.key,
      required this.setButtonActive,
      this.totalKcalCalculated,
      required this.calorieGoalDayString,
      required this.carbsGoalString,
      required this.fatGoalString,
      required this.proteinGoalString});

  @override
  State<OnboardingOverviewPageBody> createState() =>
      _OnboardingOverviewPageBodyState();
}

class _OnboardingOverviewPageBodyState extends State<OnboardingOverviewPageBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  context,
                  title: S.of(context).onboardingOverviewLabel,
                  subtitle: S.of(context).onboardingYourGoalLabel,
                ),
                SizedBox(height: isSmallScreen ? 24.0 : 32.0),
                _buildCalorieGoalCard(context),
                SizedBox(height: isSmallScreen ? 24.0 : 32.0),
                _buildSectionTitle(
                  context,
                  title: S.of(context).onboardingYourMacrosGoalLabel,
                  subtitle: S.of(context).onboardingYourGoalLabel,
                ),
                SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                _buildMacrosGrid(context, isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildCalorieGoalCard(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                widget.calorieGoalDayString,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                S.of(context).onboardingKcalPerDayLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacrosGrid(BuildContext context, bool isSmallScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isVerySmallScreen = screenWidth < 320;
        final isMediumScreen = screenWidth > 400;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: isSmallScreen ? 12.0 : 16.0,
          crossAxisSpacing: isSmallScreen ? 12.0 : 16.0,
          childAspectRatio:
              isVerySmallScreen ? 0.7 : (isMediumScreen ? 1.2 : 1.0),
          children: [
            _buildMacroCard(
              context,
              title: S.of(context).carbsLabel,
              value: widget.carbsGoalString,
              unit: "g",
              icon: Icons.grain,
              color: Colors.orange,
              isSmallScreen: isSmallScreen,
              delay: 0,
            ),
            _buildMacroCard(
              context,
              title: S.of(context).proteinLabel,
              value: widget.proteinGoalString,
              unit: "g",
              icon: Icons.fitness_center,
              color: Colors.blue,
              isSmallScreen: isSmallScreen,
              delay: 100,
            ),
            _buildMacroCard(
              context,
              title: S.of(context).fatLabel,
              value: widget.fatGoalString,
              unit: "g",
              icon: Icons.water_drop,
              color: Colors.red,
              isSmallScreen: isSmallScreen,
              delay: 200,
            ),
            _buildMacroCard(
              context,
              title: S.of(context).onboardingKcalPerDayLabel,
              value: widget.totalKcalCalculated?.toStringAsFixed(0) ?? "0",
              unit: "kcal",
              icon: Icons.local_fire_department,
              color: Colors.amber,
              isSmallScreen: isSmallScreen,
              delay: 300,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMacroCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: InkWell(
          onTap: () {
            // Add haptic feedback
            Feedback.forTap(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isSmallScreen ? 24.0 : 32.0,
                  color: color,
                ),
                SizedBox(height: isSmallScreen ? 4.0 : 8.0),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: isSmallScreen ? 14.0 : null,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 4.0 : 8.0),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isSmallScreen ? 18.0 : null,
                      ),
                ),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: isSmallScreen ? 10.0 : null,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
