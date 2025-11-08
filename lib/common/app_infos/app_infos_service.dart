import 'package:package_info_plus/package_info_plus.dart';

abstract final class AppInfosService {
  const AppInfosService._();

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
