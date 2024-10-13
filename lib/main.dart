import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/di/injection.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/router/app_routes.dart';
import 'package:sequencia/router/routes.dart';
import 'package:sequencia/utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GetIt getIt = GetIt.instance;

  await configureAppDependencies(getIt);

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
          ChangeNotifierProvider(
            create: (_) => GetIt.I.get<PlayersController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => GetIt.I<GameController>(),
          ),
        ],
        child: MaterialApp(
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
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', ''),
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: Routes.splash,
          title: AppStrings.title,
        ),
      ),
    );
  }
}
