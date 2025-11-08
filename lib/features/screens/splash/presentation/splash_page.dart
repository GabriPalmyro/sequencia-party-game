import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sequencia/common/app_infos/app_infos_service.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/router/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    });
  }

  Future<String> getAppVersion() async {
    return await AppInfosService.getAppVersion();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.logo)
                  .animate(
                    delay: 250.ms,
                  )
                  .fade(
                    duration: 300.ms,
                    delay: 300.ms,
                  )
                  .slide(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DSText(
                      'Versão: ${snapshot.data}',
                      customStyle: TextStyle(
                        fontSize: theme.font.size.xs,
                      ),
                    )
                        .animate(
                          delay: 250.ms,
                        )
                        .fade(
                          duration: 300.ms,
                          delay: 300.ms,
                        )
                        .slide(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                        );
                  } else {
                    return DSText(
                      'Versão: ...',
                      customStyle: TextStyle(
                        fontSize: theme.font.size.xs,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
