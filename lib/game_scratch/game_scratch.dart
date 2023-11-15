import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_game/game_scratch/game_scratch_dialog.dart';
import 'package:flutter_mini_game/generated/assets.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'scratch_box.dart';

class Prize {
  double amount;
  int noOfTimes;

  Prize(this.amount, this.noOfTimes);
}

class GameScratchConfig {
  String prizeMessage = "Congratulations!\nYou Won";
  List<Prize> prizes = [
    Prize(5.0, 1),
    Prize(3.0, 1),
    Prize(2.0, 1),
    Prize(1.0, 4),
    Prize(0, 2)
  ];
  int noOfTiles = 9;
  String scratchImage;

  GameScratchConfig({
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
    List<ScratchCard> pieceOfItems = [];
    for (var prize in widget.gameScratchConfig.prizes) {
      for (int i = 0; i < prize.noOfTimes; i++) {
        pieceOfItems.add(ScratchCard(
          amount: prize.amount,
          displayText:
              'RM${NumberFormat('0.00', 'en_Us').format(prize.amount)}',
          scratchImage: widget.gameScratchConfig.scratchImage,
        ));
      }
    }
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

          double totalEarn = selectedScratch.fold(
              0.0,
              (sum, prize) =>
                  (Decimal.parse("$sum") + Decimal.parse("${prize.amount}"))
                      .toDouble());

          winDialog(context, widget.gameScratchConfig.prizeMessage,
              "RM${NumberFormat('0.00', 'en_Us').format(totalEarn)}", () {
            Navigator.of(context, rootNavigator: true).pop();
            widget.onGameEnd?.call(totalEarn);
          });
        });
      }
    });
  }
}
