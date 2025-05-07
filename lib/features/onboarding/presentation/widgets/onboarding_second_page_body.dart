import 'package:active_fit/core/utils/calc/unit_calc.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingSecondPageBody extends StatefulWidget {
  final Function(bool active, double? selectedHeight, double? selectedWeight,
      bool usesImperialUnits) setButtonContent;

  const OnboardingSecondPageBody({super.key, required this.setButtonContent});

  @override
  State<OnboardingSecondPageBody> createState() =>
      _OnboardingSecondPageBodyState();
}

class _OnboardingSecondPageBodyState extends State<OnboardingSecondPageBody> {
  final _heightFormKey = GlobalKey<FormState>();
  final _weightFormKey = GlobalKey<FormState>();
  final _isUnitSelected = [true, false];
  double? _parsedHeight;
  double? _parsedWeight;

  bool get _isImperialSelected => _isUnitSelected[1];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              title: S.of(context).heightLabel,
              subtitle: S.of(context).onboardingHeightQuestionSubtitle,
            ),
            const SizedBox(height: 24.0),
            _buildHeightInput(),
            const SizedBox(height: 32.0),
            _buildSectionTitle(
              title: S.of(context).weightLabel,
              subtitle: S.of(context).onboardingWeightQuestionSubtitle,
            ),
            const SizedBox(height: 24.0),
            _buildWeightInput(),
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

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _heightFormKey,
          child: TextFormField(
            onChanged: (text) {
              if (_heightFormKey.currentState!.validate()) {
                _parsedHeight = double.tryParse(text.replaceAll(',', '.'));
                checkCorrectInput();
              } else {
                _parsedHeight = null;
                checkCorrectInput();
              }
            },
            validator: validateHeight,
            decoration: InputDecoration(
              labelText: _isImperialSelected ? 'ft' : 'cm',
              hintText: _isImperialSelected
                  ? S.of(context).onboardingHeightExampleHintFt
                  : S.of(context).onboardingHeightExampleHintCm,
              prefixIcon: Icon(
                Icons.height,
                color: Theme.of(context).colorScheme.primary,
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              !_isImperialSelected
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+([.,]\d{0,1})?$'))
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        _buildUnitToggle(),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _weightFormKey,
          child: TextFormField(
            onChanged: (text) {
              if (_weightFormKey.currentState!.validate()) {
                _parsedWeight = double.tryParse(text);
                checkCorrectInput();
              } else {
                checkCorrectInput();
              }
            },
            validator: validateWeight,
            decoration: InputDecoration(
              labelText: _isImperialSelected
                  ? S.of(context).lbsLabel
                  : S.of(context).kgLabel,
              hintText: _isImperialSelected
                  ? S.of(context).onboardingWeightExampleHintLbs
                  : S.of(context).onboardingWeightExampleHintKg,
              prefixIcon: Icon(
                Icons.monitor_weight,
                color: Theme.of(context).colorScheme.primary,
              ),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const SizedBox(height: 16.0),
        _buildUnitToggle(),
      ],
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        isSelected: _isUnitSelected,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < _isUnitSelected.length; i++) {
              _isUnitSelected[i] = i == index;
            }
            _heightFormKey.currentState!.validate();
            _weightFormKey.currentState!.validate();
            checkCorrectInput();
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text(
              S.of(context).cmLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text(
              S.of(context).ftLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateHeight(String? value) {
    if (value == null) return S.of(context).onboardingWrongHeightLabel;

    if (_isImperialSelected) {
      if (value.isEmpty || !RegExp(r'^[0-9]+([.,][0-9])?$').hasMatch(value)) {
        return S.of(context).onboardingWrongHeightLabel;
      } else {
        return null;
      }
    } else {
      if (value.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
        return S.of(context).onboardingWrongHeightLabel;
      } else {
        return null;
      }
    }
  }

  String? validateWeight(String? value) {
    if (value == null) return S.of(context).onboardingWrongWeightLabel;
    if (value.isEmpty || !RegExp(r'^[0-9]').hasMatch(value)) {
      return S.of(context).onboardingWrongHeightLabel;
    } else {
      return null;
    }
  }

  void checkCorrectInput() {
    final isHeightValid = _heightFormKey.currentState?.validate() ?? false;
    final isWeightValid = _weightFormKey.currentState?.validate() ?? false;

    if (isHeightValid && isWeightValid) {
      if (_parsedHeight != null && _parsedWeight != null) {
        final heightCm = _isImperialSelected
            ? UnitCalc.feetToCm(_parsedHeight!)
            : _parsedHeight!;
        final weightKg = _isImperialSelected
            ? UnitCalc.lbsToKg(_parsedWeight!)
            : _parsedWeight!;

        widget.setButtonContent(true, heightCm, weightKg, _isImperialSelected);
      } else {
        widget.setButtonContent(false, null, null, _isImperialSelected);
      }
    } else {
      widget.setButtonContent(false, null, null, _isImperialSelected);
    }
  }
}
