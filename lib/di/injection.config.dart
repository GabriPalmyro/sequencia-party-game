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
import 'package:sequencia/features/controller/card_view_controller.dart'
    as _i637;
import 'package:sequencia/features/controller/game_controller.dart' as _i973;
import 'package:sequencia/features/controller/players_controller.dart' as _i524;

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
    gh.factory<_i637.CardViewController>(() => _i637.CardViewController());
    gh.factory<_i973.GameController>(() => _i973.GameController());
    gh.lazySingleton<_i306.AppNavigator>(
        () => _i306.AppNavigatorImpl(gh<_i753.AppRouterConfig>()));
    gh.lazySingleton<_i762.LocalDatabase>(
        () => _i762.SharedPreferencesDatabase());
    gh.factory<_i524.PlayersController>(() =>
        _i524.PlayersController(localDatabase: gh<_i762.LocalDatabase>()));
    return this;
  }
}
