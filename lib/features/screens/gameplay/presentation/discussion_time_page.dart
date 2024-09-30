import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/router/app_navigator.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/core/app_sounds.dart';
import 'package:sequencia/utils/time_formatter.dart';

class DiscussionTimePage extends StatefulWidget {
  const DiscussionTimePage({super.key});

  @override
  State<DiscussionTimePage> createState() => _DiscussionTimePageState();
}

class _DiscussionTimePageState extends State<DiscussionTimePage> {
  Timer? _timer;
  static const int maxSeconds = 180;
  int remainingSeconds = 180;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        remainingSeconds -= 1;
      });
      if (timer.tick == maxSeconds) {
        _finishTimer();
      }
    });
  }

  Future<void> _finishTimer() async {
    _timer?.cancel();

    // Play a sound when the timer finishes
    final player = AudioPlayer();
    await player.play(DeviceFileSource(AppSounds.finishTime));
    
    await Future.delayed(const Duration(seconds: 2));

    GetIt.I<AppNavigator>().pushReplacementNamed(Routes.gameOrderPlayers);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            DSText(
              'Fase de exemplos',
              textAlign: TextAlign.center,
              customStyle: TextStyle(
                fontWeight: theme.font.weight.semiBold,
                color: theme.colors.white,
                fontSize: theme.font.size.sm,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.inline.md,
              ),
              child: DSText(
                'Voces tem 3 minutos para definir os temas e discutir a ordem das cartas',
                textAlign: TextAlign.center,
                customStyle: TextStyle(
                  fontWeight: theme.font.weight.light,
                  color: theme.colors.white,
                  fontSize: theme.font.size.xxs,
                ),
              ),
            ),
            SizedBox(height: theme.spacing.inline.xs),
            DSText(
              TimeFormatter.secondsToTime(remainingSeconds),
              textAlign: TextAlign.center,
              customStyle: TextStyle(
                fontWeight: theme.font.weight.bold,
                color: theme.colors.white,
                fontSize: theme.font.size.xxl,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Lottie.asset(AppAnimations.clock),
            ),
            const Spacer(),
            DSButtonWidget(
              label: 'Pular',
              onPressed: () {
                _timer?.cancel();
                GetIt.I<AppNavigator>().pushReplacementNamed(Routes.gameOrderPlayers);
              },
            ),
            SizedBox(height: theme.spacing.inline.md),
          ],
        ),
      ),
    );
  }
}
