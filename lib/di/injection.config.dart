// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sequencia/common/local_database/local_database.dart' as _i762;
import 'package:sequencia/common/router/app_navigator.dart' as _i306;
import 'package:sequencia/common/router/router_config.dart' as _i753;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initAppGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i306.AppNavigator>(
        () => _i306.AppNavigatorImpl(gh<_i753.AppRouterConfig>()));
    gh.lazySingleton<_i762.LocalDatabase>(
        () => _i762.SharedPreferencesDatabase());
    return this;
  }
}
