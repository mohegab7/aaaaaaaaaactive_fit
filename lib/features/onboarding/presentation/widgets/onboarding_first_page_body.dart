import 'package:active_fit/features/onboarding/domain/entity/user_gender_selection_entity.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class OnboardingFirstPageBody extends StatefulWidget {
  final Function(
          bool active, UserGenderSelectionEntity? gender, DateTime? birthday)
      setPageContent;

  const OnboardingFirstPageBody({super.key, required this.setPageContent});

  @override
  State<OnboardingFirstPageBody> createState() =>
      _OnboardingFirstPageBodyState();
}

class _OnboardingFirstPageBodyState extends State<OnboardingFirstPageBody> {
  final _dateInput = TextEditingController();
  DateTime? _selectedDate;

  bool _maleSelected = false;
  bool _femaleSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              title: S.of(context).genderLabel,
              subtitle: S.of(context).onboardingGenderQuestionSubtitle,
            ),
            const SizedBox(height: 32.0),
            _buildGenderSelection(),
            const SizedBox(height: 48.0),
            _buildSectionTitle(
              title: S.of(context).ageLabel,
              subtitle: S.of(context).onboardingBirthdayQuestionSubtitle,
            ),
            const SizedBox(height: 24.0),
            _buildDatePicker(),
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

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildGenderCard(
            label: S.of(context).genderMaleLabel,
            icon: Icons.male,
            isSelected: _maleSelected,
            onTap: () => _selectGender(true),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildGenderCard(
            label: S.of(context).genderFemaleLabel,
            icon: Icons.female,
            isSelected: _femaleSelected,
            onTap: () => _selectGender(false),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCard({
    required String label,
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12.0),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        onTap: onDateInputClicked,
        leading: Icon(
          Icons.calendar_month_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          _dateInput.text.isEmpty
              ? S.of(context).onboardingEnterBirthdayLabel
              : _dateInput.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _dateInput.text.isEmpty
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _selectGender(bool isMale) {
    setState(() {
      _maleSelected = isMale;
      _femaleSelected = !isMale;
      checkCorrectInput();
    });
  }

  void onDateInputClicked() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _selectedDate = pickedDate;
        _dateInput.text = formattedDate;
        checkCorrectInput();
      });
    }
  }

  void checkCorrectInput() {
    UserGenderSelectionEntity? selectedGender;
    if (_maleSelected) {
      selectedGender = UserGenderSelectionEntity.genderMale;
    } else if (_femaleSelected) {
      selectedGender = UserGenderSelectionEntity.genderFemale;
    }

    if (selectedGender != null && _selectedDate != null) {
      widget.setPageContent(true, selectedGender, _selectedDate);
    } else {
      widget.setPageContent(false, null, null);
    }
  }
}
