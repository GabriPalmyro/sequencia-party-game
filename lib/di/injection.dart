import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:router/page_route.dart';
import 'package:router/router_config.dart';
import 'package:sequencia/di/injection.config.dart';

@InjectableInit(initializerName: r'$initAppGetIt')
Future<void> configureAppDependencies(
  GetIt getIt,
  List<PageRoute> routes,
  String initialLocation,
) async {
  getIt.$initAppGetIt();

  getIt.registerLazySingleton<AppRouterConfig>(
    () => AppRouterConfig(
      routes: routes,
      initialLocation: initialLocation,
    ),
  );
}
