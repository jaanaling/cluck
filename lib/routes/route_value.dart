enum RouteValue {
  splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  shop(
    path: 'shop',
  ),
  recipe(
    path: 'recipe',
  ),

  privacy(path: '/privacy'),

  unknown(
    path: '',
  );

  final String path;
  const RouteValue({
    required this.path,
  });
}
