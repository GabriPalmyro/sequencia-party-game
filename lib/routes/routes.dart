enum Routes {
  //! COMMON
  home('/home');

  const Routes(this.path);

  final String path;

  @override
  String toString() => path;
}
