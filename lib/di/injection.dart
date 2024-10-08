import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/di/injection.config.dart';

@InjectableInit(initializerName: r'$initAppGetIt')
Future<void> configureAppDependencies(
  GetIt getIt,
) async {
  getIt.$initAppGetIt();
}
