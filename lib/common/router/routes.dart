enum Routes {
  home('/home'),
  gamePrepare('/game-prepare'),
  discussionTime('/discussion-time'),
  gameOrderPlayers('/game-order-players'),
  gameplay('/gameplay');

  const Routes(this.path);

  final String path;

  @override
  String toString() => path;
}
