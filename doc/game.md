# BaseGame

`BaseGame` is the most basic and most commonly used `Game` class in Flame.

The `BaseGame` class implements a `Component` based `Game`. Basically it has a list of `Component`s
and passes the `update` and `render` calls to all `Component`s that have been added to the game.

We refer to this component based system as the Flame Component System, FCS for short.

Every time the game needs to be resized, for example when the orientation is changed,
`BaseGame` will call all of the `Component`s `resize` methods and it will also pass this information
to the camera and viewport.

The `BaseGame.camera` controls which point in the coordinate space should be the top-left of the
screen (it defaults to [0,0] like a regular `Canvas`).

A `BaseGame` implementation example can be seen below:

```dart
class MyCrate extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  MyCrate() : super(size: Vector2.all(16));

  Future<void> onLoad() async {
    sprite = await Sprite.load('crate.png');
    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    // We don't need to set the position in the constructor, we can it directly here since it will
    // be called once before the first time it is rendered.
    position = gameSize / 2;
  }
}

class MyGame extends BaseGame {
  MyGame() {
    add(MyCrate());
  }
}

main() {
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
```

**Note:** If you instantiate your game in a build method your game will be rebuilt every time the
 Flutter tree gets rebuilt, which usually is more often than you'd like. To avoid this, you can
 instead create an instance of your game first and reference it within your widget structure, like
 it is done in the example above.

To remove components from the list on a `BaseGame` the `remove` or `removeAll` methods can be used.
The first can be used if you just want to remove one component, and the second can be used when you
want to remove a list of components.

Any component on which the `remove()` method has been called will also be removed. You can do this
simply by doing `yourComponent.remove();`.

## Debug mode

Flame's `BaseGame` class provides a variable called `debugMode`, which by default is `false`. It can
however, be set to `true` to enable debug features for the components of the game. **Be aware** that
the value of this variable is passed through to its components when they are added to the game, so
if you change the `debugMode` at runtime, it will not affect already added components by default.

To read more about the `debugMode` on Flame, please refer to the [Debug Docs](debug.md)

# Game

The `Game` class is a low-level API that can be used when you want to implement the functionality of
how the game engine should be structured. `Game` does not implement any `update` or
`render` function for example and is therefore marked as abstract.

**Note**: The `Game` class allows for more freedom of how to implement things, but you are also
missing out on a lot of the built-in features in Flame if you use it.

An example of how a `Game` implementation could look like:

```dart
class MyGameSubClass extends Game {
  @override
  void render(Canvas canvas) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}

main() {
  final myGame = MyGameSubClass();
  runApp(
    GameWidget(
      game: myGame,
    )
  );
}
```

# GameLoop

The `GameLoop` module is a simple abstraction over the game loop concept. Basically most games are
built upon two methods:

 - The render method takes the canvas for drawing the current state of the game.
 - The update method receives the delta time in seconds since the last update and allows you to move
  to the next state.

The `GameLoop` is used by all of Flame's `Game` implementations.

# Flutter Widgets and Game instances

Since a Flame game can be wrapped in a widget, it is quite easy to use it alongside other Flutter
widgets. But still, there is the Widgets Overlay API that makes things even easier.

`Game.overlays` enables any Flutter widget to be shown on top of a game instance, this makes it very
easy to create things like a pause menu or an inventory screen for example.

This management is done via the `game.overlays.add` and `game.overlays.remove` methods that marks an
overlay to be shown or hidden, respectively, via a `String` argument that identifies the overlay.
After that it can be specified which widgets represent each overlay in the `GameWidget` declaration
by setting a `overlayBuilderMap`.

```dart
// Inside the game methods:
final pauseOverlayIdentifier = 'PauseMenu';

overlays.add(pauseOverlayIdentifier); // Marks 'PauseMenu' to be rendered.
overlays.remove(pauseOverlayIdentifier); // Marks 'PauseMenu' to not be rendered.
```

```dart
// On the widget declaration
final game = MyGame();

Widget build(BuildContext context) {
  return GameWidget(
    game: game,
    overlayBuilderMap: {
      'PauseMenu': (ctx) {
        return Text('A pause menu');
      },
    },
  );
}
```

The order in which the overlays are declared in the `overlayBuilderMap` defines which order the
overlays will be rendered.

Here you can see a
[working example](https://github.com/flame-engine/flame/tree/main/examples/lib/stories/widgets/overlay.dart)
of this feature.
