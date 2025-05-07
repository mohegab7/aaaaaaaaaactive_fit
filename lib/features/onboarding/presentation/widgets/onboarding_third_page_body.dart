import 'package:active_fit/core/presentation/widgets/info_dialog.dart';
import 'package:active_fit/features/onboarding/domain/entity/user_activity_selection_entity.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';

class OnboardingThirdPageBody extends StatefulWidget {
  final Function(bool active, UserActivitySelectionEntity? selectedActivity)
      setButtonContent;

  const OnboardingThirdPageBody({super.key, required this.setButtonContent});

  @override
  State<OnboardingThirdPageBody> createState() =>
      _OnboardingThirdPageBodyState();
}

class _OnboardingThirdPageBodyState extends State<OnboardingThirdPageBody> {
  bool _sedentarySelected = false;
  bool _lowActiveSelected = false;
  bool _activeSelected = false;
  bool _veryActiveSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              title: S.of(context).activityLabel,
              subtitle: S.of(context).onboardingActivityQuestionSubtitle,
            ),
            const SizedBox(height: 32.0),
            _buildActivityCard(
              title: S.of(context).palSedentaryLabel,
              description: S.of(context).palSedentaryDescriptionLabel,
              icon: Icons.sentiment_dissatisfied_outlined,
              isSelected: _sedentarySelected,
              onTap: () => _setSelectedChoiceChip(sedentary: true),
            ),
            const SizedBox(height: 16.0),
            _buildActivityCard(
              title: S.of(context).palLowLActiveLabel,
              description: S.of(context).palLowActiveDescriptionLabel,
              icon: Icons.sentiment_neutral_outlined,
              isSelected: _lowActiveSelected,
              onTap: () => _setSelectedChoiceChip(lowActive: true),
            ),
            const SizedBox(height: 16.0),
            _buildActivityCard(
              title: S.of(context).palActiveLabel,
              description: S.of(context).palActiveDescriptionLabel,
              icon: Icons.sentiment_satisfied_outlined,
              isSelected: _activeSelected,
              onTap: () => _setSelectedChoiceChip(active: true),
            ),
            const SizedBox(height: 16.0),
            _buildActivityCard(
              title: S.of(context).palVeryActiveLabel,
              description: S.of(context).palVeryActiveDescriptionLabel,
              icon: Icons.sentiment_very_satisfied_outlined,
              isSelected: _veryActiveSelected,
              onTap: () => _setSelectedChoiceChip(veryActive: true),
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

  Widget _buildActivityCard({
    required String title,
    required String description,
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
          checkCorrectInput();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => InfoDialog(
                      title: title,
                      body: description,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setSelectedChoiceChip({
    sedentary = false,
    lowActive = false,
    active = false,
    veryActive = false,
  }) {
    setState(() {
      _sedentarySelected = sedentary;
      _lowActiveSelected = lowActive;
      _activeSelected = active;
      _veryActiveSelected = veryActive;
    });
  }

  void checkCorrectInput() {
    UserActivitySelectionEntity? selectedActivity;
    if (_sedentarySelected) {
      selectedActivity = UserActivitySelectionEntity.sedentary;
    } else if (_lowActiveSelected) {
      selectedActivity = UserActivitySelectionEntity.lowActive;
    } else if (_activeSelected) {
      selectedActivity = UserActivitySelectionEntity.active;
    } else if (_veryActiveSelected) {
      selectedActivity = UserActivitySelectionEntity.veryActive;
    }

    if (selectedActivity != null) {
      widget.setButtonContent(true, selectedActivity);
    } else {
      widget.setButtonContent(false, null);
    }
  }
}
