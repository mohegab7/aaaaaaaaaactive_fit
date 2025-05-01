import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:active_fit/core/data/data_source/user_data_source.dart';
import 'package:active_fit/core/data/repository/config_repository.dart';
import 'package:active_fit/core/domain/entity/app_theme_entity.dart';
import 'package:active_fit/core/presentation/main_screen.dart';
import 'package:active_fit/core/presentation/widgets/image_full_screen.dart';
import 'package:active_fit/core/styles/color_schemes.dart';
import 'package:active_fit/core/styles/fonts.dart';
import 'package:active_fit/core/utils/env.dart';
import 'package:active_fit/core/utils/locator.dart';
import 'package:active_fit/core/utils/logger_config.dart';
import 'package:active_fit/core/utils/navigation_options.dart';
import 'package:active_fit/core/utils/theme_mode_provider.dart';
import 'package:active_fit/features/activity_detail/activity_detail_screen.dart';
import 'package:active_fit/features/add_activity/presentation/add_activity_screen.dart';
import 'package:active_fit/features/add_meal/presentation/add_meal_screen.dart';
import 'package:active_fit/features/dashboard/dashboard.dart';
import 'package:active_fit/features/edit_meal/presentation/edit_meal_screen.dart';
import 'package:active_fit/features/login/login_screen.dart';
import 'package:active_fit/features/meal_detail/meal_detail_screen.dart';
import 'package:active_fit/features/onboarding/onboarding_screen.dart';
import 'package:active_fit/features/register/Register_screen.dart';
import 'package:active_fit/features/scanner/scanner_screen.dart';
import 'package:active_fit/features/settings/settings_screen.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:active_fit/model/constants/CaheHelper.dart';
import 'package:active_fit/model/constants/bloc_ofserver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  LoggerConfig.intiLogger();
  await initLocator();
  final isUserInitialized = await locator<UserDataSource>().hasUserData();
  final configRepo = locator<ConfigRepository>();
  final hasAcceptedAnonymousData =
      await configRepo.getConfigHasAcceptedAnonymousData();
  final savedAppTheme = await configRepo.getConfigAppTheme();
  final log = Logger('main');

  // If the user has accepted anonymous data collection, run the app with
  // sentry enabled, else run without it
  if (kReleaseMode && hasAcceptedAnonymousData) {
    log.info('Starting App with Sentry enabled ...');
    _runAppWithSentryReporting(isUserInitialized, savedAppTheme);
  } else {
    log.info('Starting App ...');
    runAppWithChangeNotifiers(isUserInitialized, savedAppTheme);
  }
}

void _runAppWithSentryReporting(
    bool isUserInitialized, AppThemeEntity savedAppTheme) async {
  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDns;
    options.tracesSampleRate = 1.0;
  },
      appRunner: () =>
          runAppWithChangeNotifiers(isUserInitialized, savedAppTheme));
}

void runAppWithChangeNotifiers(
        bool userInitialized, AppThemeEntity savedAppTheme) =>
    runApp(ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(appTheme: savedAppTheme),
        child: ACtiveFitApp(userInitialized: userInitialized)));

class ACtiveFitApp extends StatelessWidget {
  final bool userInitialized;

  const ACtiveFitApp({super.key, required this.userInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: appTextTheme,
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: appTextTheme),
      themeMode: Provider.of<ThemeModeProvider>(context).themeMode,
      // emeModeProvider > (context).themeMode,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: userInitialized
          ? NavigationOptions.loginScreen
          : NavigationOptions.onboardingRoute,
      routes: {
        NavigationOptions.mainRoute: (context) => const MainScreen(),
        NavigationOptions.onboardingRoute: (context) =>
            const OnboardingScreen(),
        NavigationOptions.settingsRoute: (context) => const SettingsScreen(),
        NavigationOptions.addMealRoute: (context) => const AddMealScreen(),
        NavigationOptions.scannerRoute: (context) => const ScannerScreen(),
        NavigationOptions.mealDetailRoute: (context) =>
            const MealDetailScreen(),
        NavigationOptions.editMealRoute: (context) => const EditMealScreen(),
        NavigationOptions.addActivityRoute: (context) =>
            const AddActivityScreen(),
        NavigationOptions.activityDetailRoute: (context) =>
            const ActivityDetailScreen(),
        NavigationOptions.imageFullScreenRoute: (context) =>
            const ImageFullScreen(),
        NavigationOptions.loginScreen: (context) => LoginScreen(),
        NavigationOptions.registerScreen: (context) => RegisterScreen(),
        NavigationOptions.dashboard: (context) => const Dashboard_Screen(),
      },
    );
  }
}
