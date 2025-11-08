import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/ads/ads_service.dart';
import 'package:sequencia/di/injection.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/locale_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/firebase_options.dart';
import 'package:sequencia/router/app_routes.dart';
import 'package:sequencia/router/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FlutterError.onError =
  // FirebaseCrashlytics.instance.recordFlutterFatalError;

  final GetIt getIt = GetIt.instance;

  await configureAppDependencies(getIt);
  await getIt<AdsService>().initialize();

  final DSThemeData theme = DSThemeAppData();

  runApp(MyApp(theme: theme));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.theme, super.key});
  final DSThemeData theme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DSTheme(
      data: widget.theme,
      child: MultiProvider(
        providers: [
          Provider<AdsService>.value(
            value: GetIt.I<AdsService>(),
          ),
          ChangeNotifierProvider(
            create: (_) => LocaleController(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) => GetIt.I.get<PlayersController>()..getSavedPlayers(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) => GetIt.I<GameController>()..getGameThemes(),
          ),
        ],
        child: Consumer<LocaleController>(
          builder: (context, localeController, _) {
            return MaterialApp(
              locale: localeController.locale,
              theme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
                primaryColor: widget.theme.designTokens.colors.primary,
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: Routes.splash,
            );
          },
        ),
      ),
    );
  }
}
