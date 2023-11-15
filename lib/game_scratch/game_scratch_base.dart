import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_game/game_scratch/game_scratch_dialog_base.dart';
import 'package:flutter_mini_game/generated/assets.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'scratch_box_base.dart';

class GameScratchConfig {
  double firstPrizeAmount;
  double secondPrizeAmount;
  double thirdPrizeAmount;
  int specialPrizeMultiply;
  String normalPrizeMessage;
  String specialPrizeMessage;
  String firstPrize;
  String secondPrize;
  String thirdPrize;
  String scratchImage;

  GameScratchConfig({
    this.firstPrizeAmount = 1.0,
    this.secondPrizeAmount = 0.5,
    this.thirdPrizeAmount = 0.1,
    this.specialPrizeMultiply = 3,
    this.normalPrizeMessage = "Congratulations!\nYou Won",
    this.specialPrizeMessage = "Congratulation! It's Special Prize!\nYou Won",
    this.firstPrize = Assets.gameScratchGameFirstPrize,
    this.secondPrize = Assets.gameScratchGameSecondPrize,
    this.thirdPrize = Assets.gameScratchGameThirdPrize,
    this.scratchImage = Assets.gameScratchScratch,
  });
}

class GameScratchWidget extends StatefulWidget {
  final Function(double value)? onGameEnd;
  final GameScratchConfig gameScratchConfig;

  const GameScratchWidget({
    Key? key,
    this.onGameEnd,
    required this.gameScratchConfig,
  }) : super(key: key);

  @override
  State<GameScratchWidget> createState() => _GameScratchWidgetState();
}

class _GameScratchWidgetState extends State<GameScratchWidget>
    with SingleTickerProviderStateMixin {
  List<List<ScratchCard>> scratchList = [];
  bool showResultLock = false;

  @override
  void initState() {
    scratchList = randomList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < scratchList.length; i++)
          buildRow(scratchList[i][0], scratchList[i][1], scratchList[i][2])
      ],
    );
  }

  Widget buildRow(ScratchCard left, ScratchCard center, ScratchCard right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScratchBox(
          scratchCard: left,
          onScratchStart: () {
            onScratchedStart();
          },
          onScratchEnd: () {
            onScratchEnd();
          },
        ),
        ScratchBox(
          scratchCard: center,
          onScratchStart: () {
            onScratchedStart();
          },
          onScratchEnd: () {
            onScratchEnd();
          },
        ),
        ScratchBox(
          scratchCard: right,
          onScratchStart: () {
            onScratchedStart();
          },
          onScratchEnd: () {
            onScratchEnd();
          },
        ),
      ],
    );
  }

  List<List<ScratchCard>> randomList() {
    List<ScratchCard> pieceOfItems = [
      ScratchCard(
        prize: "1st",
        amount: widget.gameScratchConfig.firstPrizeAmount,
        image: widget.gameScratchConfig.firstPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "1st",
        amount: widget.gameScratchConfig.firstPrizeAmount,
        image: widget.gameScratchConfig.firstPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "1st",
        amount: widget.gameScratchConfig.firstPrizeAmount,
        image: widget.gameScratchConfig.firstPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "2nd",
        amount: widget.gameScratchConfig.secondPrizeAmount,
        image: widget.gameScratchConfig.secondPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "2nd",
        amount: widget.gameScratchConfig.secondPrizeAmount,
        image: widget.gameScratchConfig.secondPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "2nd",
        amount: widget.gameScratchConfig.secondPrizeAmount,
        image: widget.gameScratchConfig.secondPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "3rd",
        amount: widget.gameScratchConfig.thirdPrizeAmount,
        image: widget.gameScratchConfig.thirdPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "3rd",
        amount: widget.gameScratchConfig.thirdPrizeAmount,
        image: widget.gameScratchConfig.thirdPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      ),
      ScratchCard(
        prize: "3rd",
        amount: widget.gameScratchConfig.thirdPrizeAmount,
        image: widget.gameScratchConfig.thirdPrize,
        scratchImage: widget.gameScratchConfig.scratchImage,
      )
    ];
    pieceOfItems.shuffle();
    return List.generate(
        3, (i) => List.generate(3, (j) => pieceOfItems[(i * 3) + j]));
  }

  onScratchedStart() async {
    var lock = Lock();
    lock.synchronized(() {
      if (scratchList.fold(
              0,
              (sum, row) =>
                  sum + row.where((element) => element.scratched).length) >=
          3) {
        setState(() {
          for (var row in scratchList) {
            for (var element in row) {
              element.enableScratched = element.scratched;
            }
          }
        });
      }
    });
  }

  onScratchEnd() async {
    var lock = Lock();
    lock.synchronized(() {
      if (scratchList.fold(
              0,
              (sum, row) =>
                  sum +
                  row.where((element) => element.thresholdReached).length) >=
          3) {
        if (showResultLock) {
          return;
        }
        showResultLock = true;

        setState(() {
          // is scratched 3 prizes
          // if scratched then reveal
          List<ScratchCard> selectedScratch = [];
          for (var row in scratchList) {
            for (var element in row) {
              if (element.scratched) {
                selectedScratch.add(element);
                element.startReveal();
              }
            }
          }
          bool isSpecial =
              selectedScratch.map((item) => item.amount).toSet().length == 1;

          double totalEarn = selectedScratch.fold(
              0.0,
              (sum, prize) =>
                  (Decimal.parse("$sum") + Decimal.parse("${prize.amount}"))
                      .toDouble());
          if (isSpecial) {
            totalEarn =
                totalEarn * widget.gameScratchConfig.specialPrizeMultiply;
          }

          String normalPrize = widget.gameScratchConfig.normalPrizeMessage;
          String specialPrize = widget.gameScratchConfig.specialPrizeMessage;

          winDialog(context, isSpecial ? specialPrize : normalPrize,
              "RM${NumberFormat('0.00', 'en_Us').format(totalEarn)}", () {
            Navigator.of(context, rootNavigator: true).pop();
            widget.onGameEnd?.call(totalEarn);
          });
        });
      }
    });
  }
}
