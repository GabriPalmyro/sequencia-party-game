import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/common/router/router_config.dart';
import 'package:sequencia/common/router/routes.dart';

abstract class AppNavigator {
  Future<void> pushNamed(
    Routes route, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? arguments,
  });
  Future<void> pushReplacementNamed(
    Routes route, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? arguments,
  });
  Future<void> pushNamedAndRemoveUntil(
    Routes route, {
    Routes? until,
    Object? arguments,
  });
  void popAndPushNamed(Routes route);
  void pop<T>([T? result]);
  void popUntilRoute(Routes route, {bool checkIfInStack = false});
  bool checkIfRouteIsInStack(Routes route);
  bool canPop();
}

@LazySingleton(as: AppNavigator)
class AppNavigatorImpl implements AppNavigator {
  AppNavigatorImpl(this.navigator);
  final AppRouterConfig navigator;

  @override
  Future<void> pushNamed(
    Routes route, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? arguments,
  }) async =>
      navigator.pushNamed(
        route.name,
        extra: arguments,
        pathParameters: pathParameters ?? {},
        queryParameters: queryParameters ?? {},
      );

  @override
  void pop<T>([T? result]) {
    navigator.canPop() ? navigator.pop(result) : SystemNavigator.pop(animated: true);
  }

  @override
  Future<void> pushReplacementNamed(
    Routes route, {
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? arguments,
  }) async {
    navigator.pushReplacementNamed(
      route.name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: arguments,
    );
  }

  @override
  bool checkIfRouteIsInStack(Routes route) {
    final routeInsideStack = navigator.routerDelegate.currentConfiguration.matches.any((match) {
      return match.matchedLocation == route.path;
    });
    return routeInsideStack;
  }

  @override
  bool canPop() => navigator.canPop();

  @override
  void popUntilRoute(Routes route, {bool checkIfInStack = false}) {
    if (checkIfInStack) {
      if (!checkIfRouteIsInStack(route)) {
        return;
      }
    }

    while (Uri.parse(navigator.location).path != route.path) {
      if (!canPop() || navigator.location == Routes.home.path) {
        return;
      }
      pop();
    }
  }

  @override
  Future<void> pushNamedAndRemoveUntil(
    Routes route, {
    Routes? until,
    Object? arguments,
  }) async {
    while (canPop()) {
      pop();
    }
    pushNamed(route, arguments: arguments);
  }

  @override
  void popAndPushNamed(Routes route) {
    if (!canPop()) {
      pop();
    }
    pushNamed(route);
  }
}
