import 'dart:async';


import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/cupertino_snack_bar.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';
import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/src/main/model/recipe.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int currentStep = 0;
  Timer? _timer;
  int _timeLeft = 0;
  bool isFavorite = false;
  final GlobalKey shareButtonKey = GlobalKey();
  final GlobalKey shareButtonKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupCurrentStepTimer();
    isFavorite = widget.recipe.isFavorite;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupCurrentStepTimer() {
    _timer?.cancel();

    if (currentStep < widget.recipe.steps.length &&
        widget.recipe.steps[currentStep].timer != null) {
      _timeLeft = widget.recipe.steps[currentStep].timer!;
      if (_timeLeft > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_timeLeft > 0) {
              _timeLeft--;
            } else {
              timer.cancel();
            }
          });
        });
      }
    }
  }

  void _goToNextStep() {
    if (currentStep < widget.recipe.steps.length - 1) {
      setState(() {
        currentStep++;
      });
      _setupCurrentStepTimer();
    } else {
      context.read<AppBloc>().add(
            UpdateRecipeEvent(
              widget.recipe.copyWith(isCompleted: true),
            ),
          );
      showAdaptiveDialog(
          context: context,
          builder: (_) => StatefulBuilder(
                builder: (context, setState) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AppButton(
                          color: ButtonColors.purple,
                          bottomPadding: 14,
                          radius: 19,
                          width: 314,
                          height: 154,
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const GradientText('CONGRATULATIONS!', fontSize: 23, isCenter: true,),
                              Gap(5),
                              const Text('You have completed this recipe!'),
                              _actions(context, () => setState(() {}), true),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 17,
                        child: AppButton(
                          onPressed: () => context
                            ..pop()
                            ..pop(),
                          color: ButtonColors.blue,
                          bottomPadding: 7,
                          radius: 19,
                          widget: const Text('back', style: TextStyle(fontSize: 26),),
                          width: 142,
                          height: 63,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  void _shareRecipe(GlobalKey shareButtonKey) {
    Share.share(
      'Check out this recipe: ${widget.recipe.title}',
      subject: 'Check out this recipe!',
      sharePositionOrigin: shareButtonRect(shareButtonKey),
    );
  }

  Rect? shareButtonRect(GlobalKey shareButtonKey) {
    RenderBox? renderBox =
        shareButtonKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.recipe.steps[currentStep];

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView.separated(
                itemCount: widget.recipe.ingredients.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Gap(16),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        bottomPadding: 6,
                        color: ButtonColors.purple,
                        width:
                            getWidth(context, percent: 1) - 16 - 11 - 61 - 40,
                        height: 87,
                        widget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getWidth(context, percent: 0.44),
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,

                                    child: Text(
                                        widget.recipe.ingredients[index].name,)),
                              ),
                              Text(widget.recipe.ingredients[index].quantity),
                            ],
                          ),
                        ),
                      ),
                      AppButton(
                        color: ButtonColors.blue,
                        width: 61,
                        height: 61,
                        bottomPadding: 5,
                        widget: AppIcon(
                          asset: IconProvider.shop.buildImageUrl(),
                          width: 50,
                          height: 43,
                        ),
                        onPressed: () {
                          context.read<AppBloc>().add(
                                AddShoppingItemEvent(
                                  ShoppingList(
                                    id: const Uuid().v4(),
                                    name: widget.recipe.ingredients[index].name,
                                    quantity: widget
                                        .recipe.ingredients[index].quantity,
                                  ),
                                ),
                              );
                          showCupertinoSnackBar(context,
                              '${widget.recipe.ingredients[index].name}: Added to shopping list');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Gap(30),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    width: getWidth(context, percent: 0.7),
                    height: getHeight(context, percent: 0.4),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: Color(0x7C2A004B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Step ${currentStep + 1} of ${widget.recipe.steps.length}',
                            ),
                            const SizedBox(height: 8),
                            Text(step.description),
                            const SizedBox(height: 8),
                            if (step.timer != null && step.timer! > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppIcon(
                                    asset: IconProvider.time.buildImageUrl(),
                                    width: 73,
                                    height: 74,
                                  ),
                                  Text('$_timeLeft'),
                                ],
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentStep > 0)
                        IconButton(
                          icon: AppIcon(
                            asset: IconProvider.arrow.buildImageUrl(),
                            width: 50,
                            height: 43,
                          ),
                          onPressed: () {
                            if (currentStep > 0) {
                              setState(() {
                                currentStep--;
                              });
                              _setupCurrentStepTimer();
                            }
                          },
                        )
                      else
                        const SizedBox(width: 65),
                      SizedBox(
                        width: getWidth(context, percent: 0.6),
                      ),
                      IconButton(
                        icon: Transform.rotate(
                          angle: 3.14,
                          child: AppIcon(
                            asset: IconProvider.arrow.buildImageUrl(),
                            width: 50,
                            height: 43,
                          ),
                        ),
                        onPressed: _goToNextStep,
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
        AppBarWidget(
          widgets: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: getWidth(context, percent: 0.5),
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(widget.recipe.title))),
                _actions(context, () => setState(() {}), false),
              ],
            ),
          ),
          hasBackButton: true,
        ),
      ],
    );
  }

  Row _actions(BuildContext context, VoidCallback setStatee, bool isdialog) {
    return Row(
      children: [
        IconButton(
          icon: AppIcon(
            asset: IconProvider.heart.buildImageUrl(),
            color: isFavorite ? null : Colors.black.withOpacity(0.5),
            blendMode: BlendMode.srcATop,
            width: 33,
            height: 30,
          ),
          onPressed: () {
            context.read<AppBloc>().add(
                  UpdateRecipeEvent(
                    widget.recipe.copyWith(isFavorite: !isFavorite),
                  ),
                );
            isFavorite = !isFavorite;
            setStatee();
            setState(() {});
          },
        ),
        IconButton(
          key: isdialog ? shareButtonKey2 : shareButtonKey,
          icon: AppIcon(
            asset: IconProvider.share.buildImageUrl(),
            width: 32,
            height: 33,
          ),
          onPressed: () =>
              _shareRecipe(isdialog ? shareButtonKey2 : shareButtonKey),
        ),
      ],
    );
  }
}
