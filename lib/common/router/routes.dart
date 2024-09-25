enum Routes {
  home('/home'),
  gamePrepare('/game-prepare'),
  gameplay('/gameplay');

  const Routes(this.path);

  final String path;

  @override
  String toString() => path;
}
