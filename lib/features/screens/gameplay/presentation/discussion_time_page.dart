import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/widgets/ads/banner_ad_slot.dart';
import 'package:sequencia/core/ads/ads_service.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/core/app_sounds.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/exit_game_dialog_widget.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';
import 'package:sequencia/router/routes.dart';
import 'package:sequencia/utils/time_formatter.dart';

class DiscussionTimePage extends StatefulWidget {
  const DiscussionTimePage({super.key});

  @override
  State<DiscussionTimePage> createState() => _DiscussionTimePageState();
}

class _DiscussionTimePageState extends State<DiscussionTimePage> {
  Timer? _timer;
  static const int maxSeconds = 180;
  int remainingSeconds = maxSeconds;
  final player = AudioPlayer();

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
    final adsService = context.read<AdsService>();

    try {
      // Play a sound when the timer finishes
      await player.setVolume(1);
      await player.setAsset(AppSounds.finishTime);
      player.play();
    } catch (e) {
      log('Error playing sound: $e');
    }

    await Future.delayed(const Duration(seconds: 2));
    await adsService.showInterstitialIfAvailable();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(Routes.gameOrderPlayers);
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (_) => const ExitGameDialogWidget(),
        );
      },
      child: Scaffold(
        backgroundColor: theme.colors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(),
              DSText(
                context.l10n.discussionPhaseTitle,
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
                  context.l10n.discussionPhaseSubtitle,
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
              SizedBox(height: theme.spacing.inline.xxs),
              const BannerAdSlot(
                placement: AdBannerPlacement.countdown,
              ),
              const Spacer(),
              DSButtonWidget(
                label: context.l10n.skipLabel,
                onPressed: _finishTimer,
              ),
              SizedBox(height: theme.spacing.inline.md),
            ],
          ),
        ),
      ),
    );
  }
}
