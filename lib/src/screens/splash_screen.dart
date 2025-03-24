import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/route_value.dart';
import '../main/bloc/app_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    context.go(RouteValue.home.path);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(IconProvider.background.buildImageUrl()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AppIcon(
              asset: IconProvider.logo.buildImageUrl(),
              width: getWidth(context, percent: 0.7),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              bottom: !isIpad(context)? getWidth(context, baseSize: 46) + 10:getWidth(context, baseSize: 46) + 30,
              left: 0,
              right: 0,
              child: ChickenAnimation(),
            ),
            Positioned(
              bottom: getWidth(context, baseSize: 46),
              child: AppIcon(
                asset: IconProvider.path.buildImageUrl(),
                width: getWidth(context, percent: 1),
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChickenAnimation extends StatefulWidget {
  const ChickenAnimation({super.key});

  @override
  _ChickenAnimationState createState() => _ChickenAnimationState();
}

class _ChickenAnimationState extends State<ChickenAnimation>
    with TickerProviderStateMixin {
  late AnimationController _positionController;
  late AnimationController _tiltController;
  late Animation<double> _positionAnimation;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();

    final screenWidth =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    _positionController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: false);

    _positionAnimation = Tween<double>(
      begin: -screenWidth / 2, // Курицу ставим за левый край экрана
      end: screenWidth / 2, // Курица добегает до правого края
    ).animate(
      CurvedAnimation(parent: _positionController, curve: Curves.slowMiddle),
    );

    _tiltController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..repeat(reverse: true);

    _tiltAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _positionController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_positionAnimation == null) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([_positionController, _tiltController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_positionAnimation.value, 0),
          child: Transform.rotate(angle: _tiltAnimation.value, child: child),
        );
      },
      child: SizedBox(
        width: 38,
        height: 39,
        child: AppIcon(
          asset: IconProvider.chickenSplash.buildImageUrl(),
          width: 38,
          height: 39,
        ),
      ),
    );
  }
}
