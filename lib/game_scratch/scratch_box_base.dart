import 'package:flutter/material.dart';
import 'package:flutter_mini_game/generated/assets.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCard {
  String prize;
  String image;
  String scratchImage;
  bool scratched;
  bool thresholdReached;
  double amount;
  bool enableScratched;
  final key = GlobalKey<ScratcherState>();

  ScratchCard({
    this.prize = "first",
    required this.image,
    this.scratched = false,
    this.scratchImage = Assets.gameScratchScratch,
    this.thresholdReached = false,
    this.amount = 0,
    this.enableScratched = true,
  });

  void startReveal() {
    if (scratched) {
      key.currentState?.reveal(
        duration: const Duration(milliseconds: 2000),
      );
    }
  }

  @override
  String toString() {
    return 'ScratchCard{prize: $prize, image: $image, scratched: $scratched, threshold: $thresholdReached, amount: $amount, enableScratched: $enableScratched}';
  }
}

class ScratchBox extends StatefulWidget {
  const ScratchBox({
    super.key,
    required this.scratchCard,
    this.onScratch,
    this.onScratchStart,
    this.onScratchEnd,
  });

  final ScratchCard scratchCard;
  final VoidCallback? onScratch;
  final VoidCallback? onScratchStart;
  final VoidCallback? onScratchEnd;

  @override
  State<ScratchBox> createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> {
  // ignore: non_constant_identifier_names
  bool DEBUG = false;

  double opacity = 0.2;

  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 750),
      child: Image.asset(
        widget.scratchCard.image,
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),
    );

    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(10),
      child: Scratcher(
        key: widget.scratchCard.key,
        enabled: widget.scratchCard.enableScratched,
        accuracy: ScratchAccuracy.low,
        color: Colors.blueGrey,
        image: Image.asset(widget.scratchCard.scratchImage),
        brushSize: 15,
        threshold: 30,
        onThreshold: () {
          if (DEBUG) {
            print("onThreshold");
          }
          setState(() {
            opacity = 1;
            widget.scratchCard.thresholdReached = true;
          });
        },
        onScratchStart: () {
          if (DEBUG) {
            print("onScratchStart");
          }
          widget.onScratchStart?.call();
        },
        onScratchUpdate: () {
          if (widget.scratchCard.enableScratched) {
            if (DEBUG) {
              print("onScratchUpdate");
            }

            widget.scratchCard.scratched = true;
            widget.onScratch?.call();
          }
        },
        onScratchEnd: () {
          if (DEBUG) {
            print("onScratchEnd");
          }
          if (widget.scratchCard.thresholdReached) {
            widget.onScratchEnd?.call();
          }
        },
        child: Container(child: icon),
      ),
    );
  }
}
