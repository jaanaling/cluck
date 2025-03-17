enum IconProvider {
  logo(imageName: 'logo.png'),
  arrow(imageName: 'arrow.png'),
  clRes(imageName: 'cl_res.png'),
  close(imageName: 'close.png'),
  closeRes(imageName: 'close_res.png'),
  delete(imageName: 'delete.png'),
  difficulty(imageName: 'difficulty.png'),
  favRes(imageName: 'fav_res.png'),
  filter(imageName: 'filter.png'),
  heart(imageName: 'heart.png'),
  ingredients(imageName: 'ingredients.png'),
  background(imageName: 'background.png'),
  ordRes(imageName: 'ord_res.png'),
  share(imageName: 'share.png'),
  shop(imageName: 'shop.png'),
  spicy(imageName: 'spicy.png'),
  time(imageName: 'time.png'),
  timer(imageName: 'timer.png'),

  unknown(imageName: '');

  const IconProvider({required this.imageName});

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
