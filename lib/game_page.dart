import 'package:flutter/material.dart';
import 'package:flutter_mini_game/game_scratch/game_scratch_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Scratcher',
                  style: TextStyle(
                    fontFamily: 'The unseen',
                    color: Colors.blueAccent,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'scratch to win!',
                  style: TextStyle(
                    fontFamily: 'The unseen',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 1,
                  width: 300,
                  color: Colors.black12,
                )
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  gameDialog(context);
                },
                child: const Text('Press Me!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
