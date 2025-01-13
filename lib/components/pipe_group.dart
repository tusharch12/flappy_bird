import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/config/db.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/configuration.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/game/pipe_position.dart';
import 'package:flappy_bird/components/pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();
   static int pipeCount = 0;

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = _getSpacing(heightMinusGround);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    addAll([
      Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 2)),
    ]);
  }

  int getGain(){
    int initial = 10;
    int current = gameRef.bird.score ;
    return (((current- initial)/initial) * 100).toInt();
  }

  void updateScore() {
    gameRef.bird.score += 5;
    gameRef.bird.gain = getGain();
    // FlameAudio.play(Assets.point);
        pipeCount++;  
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
      pipeCount = 0;

    }
  }



    double _getSpacing(double heightMinusGround) {
      print(pipeCount);
    if (pipeCount < 18) {

  // 150 + _random.nextDouble() * (heightMinusGround / 3);
  double space = (250 + _random.nextInt(101)).toDouble();
  print(space);

  return space;
    } else if (pipeCount < 28) {

      // return 100 + _random.nextDouble() * (heightMinusGround / 4);
        double space = (150 + _random.nextInt(101)).toDouble();
        print(space);
      return space ;
    } else {

      // return 75 + _random.nextDouble() * (heightMinusGround / 5);
      
      return 50 + _random.nextInt(101).toDouble();
    }
  }
}
