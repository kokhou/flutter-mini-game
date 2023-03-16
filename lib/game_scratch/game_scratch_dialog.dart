import 'package:flutter/material.dart';
import 'package:flutter_mini_game/game_scratch/game_scratch.dart';
import 'package:flutter_mini_game/generated/assets.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

gameDialog(BuildContext context) {
  Dialogs.materialDialog(
    customViewPosition: CustomViewPosition.AFTER_ACTION,
    color: Colors.white,
    msg: "To WIN a Special Prize you need to get 3 scratch with same value",
    title: 'Scratch to win!',
    titleStyle: const TextStyle(
      color: Colors.black,
      fontSize: 24,
    ),
    msgAlign: TextAlign.center,
    msgStyle: const TextStyle(color: Colors.black),
    customView: GameScratchWidget(
      onGameEnd: (amount) {
        Navigator.of(context, rootNavigator: true).pop();
      },
      gameScratchConfig: GameScratchConfig(),
    ),
    context: context,
    barrierDismissible: false,
  );
}

winDialog(BuildContext context, String title, String message,
    final Function onPressed) {
  Dialogs.materialDialog(
      color: Colors.white,
      title: title,
      titleStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      titleAlign: TextAlign.center,
      msgAlign: TextAlign.center,
      msgStyle: const TextStyle(color: Colors.black, fontSize: 36),
      msg: message,
      lottieBuilder: Lottie.asset(
        Assets.gameScratchCongratulation,
        fit: BoxFit.contain,
      ),
      context: context,
      barrierDismissible: false,
      actions: [
        IconsButton(
          onPressed: onPressed,
          text: 'Claim',
          iconData: Icons.done,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
}
