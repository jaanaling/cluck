enum IconProvider {
  logo(imageName: 'logo.png'),
  back(imageName: 'back.svg'),
  clRes(imageName: 'cl_res.png'),
  close(imageName: 'close.png'),
  closeRes(imageName: 'close_res.png'),
  delete(imageName: 'delete.svg'),
  difficulty(imageName: 'difficulty.png'),
  favRes(imageName: 'fav_res.png'),
  filter(imageName: 'filter.svg'),
  heart(imageName: 'heart.png'),
  heartGrey(imageName: 'heart_grey.png'),
  ingredients(imageName: 'ingredients.png'),
  background(imageName: 'background.png'),
  ordRes(imageName: 'ord_res.png'),
  share(imageName: 'share.svg'),
  shop(imageName: 'shop.svg'),
  spicy(imageName: 'spicy.png'),
  search(imageName: 'search.svg'),
  time(imageName: 'time.png'),
  timer(imageName: 'timer.png'),
  path(imageName: 'path.svg'),
  chickenSplash(imageName: 'chicken_splash.svg'),

  unknown(imageName: '');

  const IconProvider({required this.imageName});

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
