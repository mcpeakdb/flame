import 'dart:typed_data';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:test/test.dart';

void main() async {
  // Generate a image
  final data = Uint8List(4);
  for (var i = 0; i < data.length; i += 4) {
    data[i] = 255;
    data[i + 1] = 255;
    data[i + 2] = 255;
    data[i + 3] = 255;
  }
  final image = await Flame.images.decodeImageFromPixels(data, 1, 1);

  final size = Vector2(1.0, 1.0);

  group('SpriteAnimationComponent shouldRemove test', () {
    test('removeOnFinish is true and animation#loop is false', () {
      final game = BaseGame();
      final animation = SpriteAnimation.spriteList(
        [
          Sprite(image),
          Sprite(image),
        ],
        stepTime: 1,
        loop: false,
      );
      final component = SpriteAnimationComponent(
        animation: animation,
        removeOnFinish: true,
      );

      game.onResize(size);
      game.add(component);

      // runs a cycle to add the component
      game.update(0.1);
      expect(component.shouldRemove, false);
      expect(game.components.length, 1);

      game.update(2);
      expect(component.shouldRemove, true);

      // runs a cycle to remove the component
      game.update(0.1);
      expect(game.components.length, 0);
    });

    test('removeOnFinish is true and animation#loop is true', () {
      final game = BaseGame();
      final animation = SpriteAnimation.spriteList(
        [
          Sprite(image),
          Sprite(image),
        ],
        stepTime: 1,
        // ignore: avoid_redundant_argument_values
        loop: true,
      );
      final component = SpriteAnimationComponent(
        animation: animation,
        removeOnFinish: true,
      );

      game.onResize(size);
      game.add(component);

      // runs a cycle to add the component
      game.update(0.1);
      expect(component.shouldRemove, false);
      expect(game.components.length, 1);

      game.update(2);
      expect(component.shouldRemove, false);

      // runs a cycle to remove the component, but failed
      game.update(0.1);
      expect(game.components.length, 1);
    });

    test('removeOnFinish is false and animation#loop is false', () {
      final game = BaseGame();
      final animation = SpriteAnimation.spriteList(
        [
          Sprite(image),
          Sprite(image),
        ],
        stepTime: 1,
        loop: false,
      );
      final component = SpriteAnimationComponent(
        animation: animation,
        // ignore: avoid_redundant_argument_values
        removeOnFinish: false,
      );

      game.onResize(size);
      game.add(component);

      // runs a cycle to add the component
      game.update(0.1);
      expect(component.shouldRemove, false);
      expect(game.components.length, 1);

      game.update(2);
      expect(component.shouldRemove, false);

      // runs a cycle to remove the component, but failed
      game.update(0.1);
      expect(game.components.length, 1);
    });

    test('removeOnFinish is false and animation#loop is true', () {
      final game = BaseGame();
      final animation = SpriteAnimation.spriteList(
        [
          Sprite(image),
          Sprite(image),
        ],
        stepTime: 1,
        // ignore: avoid_redundant_argument_values
        loop: true,
      );
      final component = SpriteAnimationComponent(
        animation: animation,
        // ignore: avoid_redundant_argument_values
        removeOnFinish: false,
      );

      game.onResize(size);
      game.add(component);

      // runs a cycle to add the component
      game.update(0.1);
      expect(component.shouldRemove, false);
      expect(game.components.length, 1);

      game.update(2);
      expect(component.shouldRemove, false);

      // runs a cycle to remove the component, but failed
      game.update(0.1);
      expect(game.components.length, 1);
    });
  });
}
