import 'package:active_fit/features/onboarding/domain/entity/user_goal_selection_entity.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';

class OnboardingFourthPageBody extends StatefulWidget {
  final Function(bool active, UserGoalSelectionEntity? selectedGoal)
      setButtonContent;

  const OnboardingFourthPageBody({super.key, required this.setButtonContent});

  @override
  State<OnboardingFourthPageBody> createState() =>
      _OnboardingFourthPageBodyState();
}

class _OnboardingFourthPageBodyState extends State<OnboardingFourthPageBody> {
  bool _looseWeightSelected = false;
  bool _maintainWeightSelected = false;
  bool _gainWeightSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              title: S.of(context).goalLabel,
              subtitle: S.of(context).onboardingGoalQuestionSubtitle,
            ),
            const SizedBox(height: 32.0),
            _buildGoalCard(
              title: S.of(context).goalLoseWeight,
              icon: Icons.trending_down_rounded,
              isSelected: _looseWeightSelected,
              onTap: () => _setSelectedChoiceChip(looseWeight: true),
            ),
            const SizedBox(height: 16.0),
            _buildGoalCard(
              title: S.of(context).goalMaintainWeight,
              icon: Icons.trending_flat_rounded,
              isSelected: _maintainWeightSelected,
              onTap: () => _setSelectedChoiceChip(maintainWeigh: true),
            ),
            const SizedBox(height: 16.0),
            _buildGoalCard(
              title: S.of(context).goalGainWeight,
              icon: Icons.trending_up_rounded,
              isSelected: _gainWeightSelected,
              onTap: () => _setSelectedChoiceChip(gainWeight: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
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

  Widget _buildGoalCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          onTap();
          _checkCorrectInput();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setSelectedChoiceChip(
      {looseWeight = false, maintainWeigh = false, gainWeight = false}) {
    setState(() {
      _looseWeightSelected = looseWeight;
      _maintainWeightSelected = maintainWeigh;
      _gainWeightSelected = gainWeight;
    });
  }

  void _checkCorrectInput() {
    UserGoalSelectionEntity? selectedGoal;
    if (_looseWeightSelected) {
      selectedGoal = UserGoalSelectionEntity.loseWeight;
    } else if (_maintainWeightSelected) {
      selectedGoal = UserGoalSelectionEntity.maintainWeight;
    } else if (_gainWeightSelected) {
      selectedGoal = UserGoalSelectionEntity.gainWeigh;
    }

    if (selectedGoal != null) {
      widget.setButtonContent(true, selectedGoal);
    } else {
      widget.setButtonContent(false, null);
    }
  }
}
