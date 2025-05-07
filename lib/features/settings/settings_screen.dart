import 'package:active_fit/core/domain/entity/app_theme_entity.dart';
import 'package:active_fit/core/utils/locator.dart';
import 'package:active_fit/core/utils/theme_mode_provider.dart';
import 'package:active_fit/features/diary/presentation/bloc/calendar_day_bloc.dart';
import 'package:active_fit/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:active_fit/features/home/presentation/bloc/home_bloc.dart';
import 'package:active_fit/features/login/login_screen.dart';
import 'package:active_fit/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:active_fit/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:active_fit/features/settings/presentation/widgets/calculations_dialog.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsBloc _settingsBloc;
  late ProfileBloc _profileBloc;
  late HomeBloc _homeBloc;
  late DiaryBloc _diaryBloc;
  late CalendarDayBloc _calendarDayBloc;

  @override
  void initState() {
    _settingsBloc = locator<SettingsBloc>();
    _profileBloc = locator<ProfileBloc>();
    _homeBloc = locator<HomeBloc>();
    _diaryBloc = locator<DiaryBloc>();
    _calendarDayBloc = locator<CalendarDayBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingsLabel),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: _settingsBloc,
        builder: (context, state) {
          if (state is SettingsInitial) {
            _settingsBloc.add(LoadSettingsEvent());
          } else if (state is SettingsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: Icon(Icons.ac_unit_outlined,
                            color: colorScheme.primary),
                        title: Text(S.of(context).settingsUnitsLabel),
                        onTap: () =>
                            _showUnitsDialog(context, state.usesImperialUnits),
                      ),
                      ListTile(
                        leading: Icon(Icons.calculate_outlined,
                            color: colorScheme.primary),
                        title: Text(S.of(context).settingsCalculationsLabel),
                        onTap: () => _showCalculationsDialog(context),
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_medium_outlined,
                            color: colorScheme.primary),
                        title: Text(S.of(context).settingsThemeLabel),
                        onTap: () => _showThemeDialog(context, state.appTheme),
                      ),
                      ListTile(
                        leading: Icon(Icons.error_outline_outlined,
                            color: colorScheme.primary),
                        title: Text(S.of(context).settingAboutLabel),
                        onTap: () => _showAboutDialog(context),
                      ),
                      ListTile(
                        leading: Icon(Icons.bug_report_outlined,
                            color: colorScheme.primary),
                        title: Text(S.of(context).settingsReportErrorLabel),
                        onTap: () => _showReportErrorDialog(context),
                      ),
                      const SizedBox(height: 32.0),
                      Center(
                        child: Image.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? 'assets/icon/active_banner_top.png'
                              : 'assets/icon/Active_banner_top_light.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      icon: Icon(Icons.logout, color: colorScheme.error),
                      label: Text(
                        'Sign Out',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            colorScheme.errorContainer.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorScheme.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingAboutLabel),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team members:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('1. Youssef Mahmoud'),
              Text('2. Yassin Barakat'),
              Text('3. Mohamed Hegab'),
              Text('4. Moatz Ashraf'),
              Text('5. Mohamed Magdy'),
              Text('6. Ali Mahmoud'),
              Text('7. Ahmed Essam'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUnitsDialog(BuildContext context, bool usesImperialUnits) async {
    SystemDropDownType selectedUnit = usesImperialUnits
        ? SystemDropDownType.imperial
        : SystemDropDownType.metric;
    final shouldUpdate = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingsUnitsLabel),
          content: Wrap(children: [
            Column(
              children: [
                DropdownButtonFormField(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    enabled: true,
                    filled: false,
                    labelText: S.of(context).settingsSystemLabel,
                  ),
                  onChanged: (value) {
                    selectedUnit = value ?? SystemDropDownType.metric;
                  },
                  items: [
                    DropdownMenuItem(
                      value: SystemDropDownType.metric,
                      child: Text(S.of(context).settingsMetricLabel),
                    ),
                    DropdownMenuItem(
                      value: SystemDropDownType.imperial,
                      child: Text(S.of(context).settingsImperialLabel),
                    )
                  ],
                )
              ],
            )
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(S.of(context).dialogOKLabel),
            )
          ],
        );
      },
    );

    if (shouldUpdate == true) {
      _settingsBloc
          .setUsesImperialUnits(selectedUnit == SystemDropDownType.imperial);
      _settingsBloc.add(LoadSettingsEvent());

      // Update blocs
      _profileBloc.add(LoadProfileEvent());
      _homeBloc.add(LoadItemsEvent());
      _diaryBloc.add(const LoadDiaryYearEvent());
    }
  }

  void _showThemeDialog(BuildContext context, AppThemeEntity currentAppTheme) {
    AppThemeEntity selectedTheme = currentAppTheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(S.of(context).settingsThemeLabel),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: Text(S.of(context).settingsThemeSystemDefaultLabel),
                    value: AppThemeEntity.system,
                    groupValue: selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value as AppThemeEntity;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(S.of(context).settingsThemeLightLabel),
                    value: AppThemeEntity.light,
                    groupValue: selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value as AppThemeEntity;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(S.of(context).settingsThemeDarkLabel),
                    value: AppThemeEntity.dark,
                    groupValue: selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value as AppThemeEntity;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).dialogCancelLabel),
            ),
            TextButton(
              onPressed: () async {
                _settingsBloc.setAppTheme(selectedTheme);
                _settingsBloc.add(LoadSettingsEvent());
                setState(() {
                  Provider.of<ThemeModeProvider>(context, listen: false)
                      .updateTheme(selectedTheme);
                });
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).dialogOKLabel),
            ),
          ],
        );
      },
    );
  }

  void _showCalculationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CalculationsDialog(
        settingsBloc: _settingsBloc,
        profileBloc: _profileBloc,
        homeBloc: _homeBloc,
        diaryBloc: _diaryBloc,
        calendarDayBloc: _calendarDayBloc,
      ),
    );
  }

  void _showReportErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).settingsReportErrorLabel),
          content: Text('Something went wrong? Let us know and we\'ll fix it.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).dialogCancelLabel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final Uri url =
                      Uri.parse('https://guileless-mousse-213f63.netlify.app/');
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $url')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error launching URL: $e')),
                    );
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(S.of(context).dialogOKLabel),
            ),
          ],
        );
      },
    );
  }
}
