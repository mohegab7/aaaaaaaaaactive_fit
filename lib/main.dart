import 'package:active_fit/features/dashboard/dashboard.dart';
import 'package:active_fit/features/login/login_screen.dart';
import 'package:active_fit/features/register/Register_screen.dart';
import 'package:active_fit/model/constants/bloc_ofserver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:active_fit/core/data/data_source/user_data_source.dart';
import 'package:active_fit/core/data/repository/config_repository.dart';
import 'package:active_fit/core/domain/entity/app_theme_entity.dart';
import 'package:active_fit/core/presentation/main_screen.dart';
import 'package:active_fit/core/presentation/widgets/image_full_screen.dart';
import 'package:active_fit/core/presentation/widgets/splash_screen.dart';
import 'package:active_fit/core/styles/color_schemes.dart';
import 'package:active_fit/core/styles/fonts.dart';
import 'package:active_fit/core/utils/env.dart';
import 'package:active_fit/core/utils/locator.dart';
import 'package:active_fit/core/utils/logger_config.dart';
import 'package:active_fit/core/utils/navigation_options.dart';
import 'package:active_fit/core/utils/theme_mode_provider.dart';
import 'package:active_fit/features/activity_detail/activity_detail_screen.dart';
import 'package:active_fit/features/add_meal/presentation/add_meal_screen.dart';
import 'package:active_fit/features/add_activity/presentation/add_activity_screen.dart';
import 'package:active_fit/features/edit_meal/presentation/edit_meal_screen.dart';
import 'package:active_fit/features/onboarding/onboarding_screen.dart';
import 'package:active_fit/features/scanner/scanner_screen.dart';
import 'package:active_fit/features/meal_detail/meal_detail_screen.dart';
import 'package:active_fit/features/settings/settings_screen.dart';
import 'package:active_fit/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await CacheHelper.init();
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
        child: active_fitApp(userInitialized: userInitialized)));

class active_fitApp extends StatefulWidget {
  final bool userInitialized;

  const active_fitApp({super.key, required this.userInitialized});

  @override
  State<active_fitApp> createState() => _active_fitAppState();
}

class _active_fitAppState extends State<active_fitApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: appTextTheme),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: appTextTheme),
      themeMode: Provider.of<ThemeModeProvider>(context).themeMode,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: SplashScreen(userInitialized: widget.userInitialized),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case NavigationOptions.loginScreen:
            page = LoginScreen();
            break;
          case NavigationOptions.registerScreen:
            page = RegisterScreen();
            break;
          case NavigationOptions.mainRoute:
            page = const MainScreen();
            break;
          case NavigationOptions.onboardingRoute:
            page = const OnboardingScreen();
            break;
          case NavigationOptions.settingsRoute:
            page = const SettingsScreen();
            break;
          case NavigationOptions.addMealRoute:
            page = const AddMealScreen();
            break;
          case NavigationOptions.scannerRoute:
            page = const ScannerScreen();
            break;
          case NavigationOptions.mealDetailRoute:
            page = const MealDetailScreen();
            break;
          case NavigationOptions.editMealRoute:
            page = const EditMealScreen();
            break;
          case NavigationOptions.addActivityRoute:
            page = const AddActivityScreen();
            break;
          case NavigationOptions.activityDetailRoute:
            page = const ActivityDetailScreen();
            break;
          case NavigationOptions.imageFullScreenRoute:
            page = const ImageFullScreen();
            break;
          case NavigationOptions.dashboard:
            page = const Dashboard_Screen();
            break;
          default:
            page = const MainScreen();
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
      },
    );
  }
}
