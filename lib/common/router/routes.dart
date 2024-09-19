enum Routes {
  home('/home'),
  gameplay('/gameplay');

  const Routes(this.path);

  final String path;

  @override
  String toString() => path;
}
