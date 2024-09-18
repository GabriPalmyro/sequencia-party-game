import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:router/router_config.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/di/injection.dart';
import 'package:sequencia/routes/routes.dart';
import 'package:sequencia/utils/app_strings.dart';

import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GetIt getIt = GetIt.instance;

  await configureAppDependencies(getIt, routes, Routes.home.path);

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
  final AppRouterConfig router = GetIt.I();

  @override
  Widget build(BuildContext context) {
    return DSTheme(
      data: widget.theme,
      child: MaterialApp.router(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
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
        routerConfig: router,
        title: AppStrings.title,
      ),
    );
  }
}
