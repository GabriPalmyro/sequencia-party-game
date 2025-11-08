import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sequencia/utils/app_consts.dart';

extension CustomAnimationExtension on Widget {
  Widget animateIn({
    double beginY = -0.1,
    double endY = 0.0,
    Duration duration = kDefaultAnimationDuration,
    Curve curve = Curves.easeInOut,
    int order = 1,
  }) {
    final delay = (kDefaultAnimationDelay.inMilliseconds +
            (kDefaultAnimationInterval.inMilliseconds * order))
        .ms;

    return animate(
      delay: delay,
    )
      ..fadeIn(
        duration: 300.ms,
        delay: 300.ms,
      )
      ..slide(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
        duration: duration,
        curve: curve,
      );
  }
}
