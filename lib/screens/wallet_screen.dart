import 'package:flappy_bird/config/db.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<int> lastFiveScores = [];
  int? maxScore;

  Future<void> loadScores() async {
    final scores = await GameDatabase.instance.getLastFiveScores();
    final max = await GameDatabase.instance.getMaxScore();
    setState(() {
      lastFiveScores = scores;
      maxScore = max;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/${Assets.backgorund}"),
              fit: BoxFit.cover,
            ),
          ),
          child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (maxScore != null)
              Text(
                'Maximum Score: $maxScore',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            const Text(
              'Last 5 Scores:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < lastFiveScores.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Game ${i + 1}: ${lastFiveScores[i]}',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            if (lastFiveScores.isEmpty)
              const Text('No scores yet', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),

      ),
    );
  }
}