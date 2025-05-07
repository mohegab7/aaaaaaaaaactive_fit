import 'package:active_fit/core/presentation/widgets/app_banner_version.dart';
import 'package:active_fit/core/utils/app_const.dart';
import 'package:active_fit/core/utils/url_const.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingIntroPageBody extends StatefulWidget {
  const OnboardingIntroPageBody({super.key, required this.setPageContent});

  final Function(bool active, bool acceptedDataCollection) setPageContent;

  @override
  State<OnboardingIntroPageBody> createState() =>
      _OnboardingIntroPageBodyState();
}

class _OnboardingIntroPageBodyState extends State<OnboardingIntroPageBody> {
  bool _acceptedPolicy = false;
  bool _acceptedDataCollection = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppConst.getVersionNumber(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  AppBannerVersion(
                    versionNumber: snapshot.requireData,
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    S.of(context).appDescription,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    S.of(context).onboardingIntroDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  _buildCheckboxTile(
                    value: _acceptedPolicy,
                    onChanged: _togglePolicy,
                    title: S.of(context).readLabel,
                    subtitle: S.of(context).privacyPolicyLabel,
                  ),
                  const SizedBox(height: 16.0),
                  _buildCheckboxTile(
                    value: _acceptedDataCollection,
                    onChanged: _toggleDataCollection,
                    title: S.of(context).dataCollectionLabel,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required VoidCallback onChanged,
    required String title,
    String? subtitle,
  }) {
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
        onTap: onChanged,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        leading: Checkbox(
          value: value,
          onChanged: (value) => onChanged(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  void _togglePolicy() {
    setState(() {
      _acceptedPolicy = !_acceptedPolicy;
      widget.setPageContent(_acceptedPolicy, _acceptedDataCollection);
    });
  }

  void _toggleDataCollection() {
    setState(() {
      _acceptedDataCollection = !_acceptedDataCollection;
      widget.setPageContent(_acceptedPolicy, _acceptedDataCollection);
    });
  }

  // ignore: unused_element
  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(URLConst.privacyPolicyURLEn),
        mode: LaunchMode.externalApplication)) {}
  }
}
