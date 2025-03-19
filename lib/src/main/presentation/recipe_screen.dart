import 'dart:async';

import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/cupertino_snack_bar.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';
import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/src/main/model/recipe.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';
import 'package:cluckmazing_recipe/ui_kit/app_bar.dart';
import 'package:cluckmazing_recipe/ui_kit/gradient_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../ui_kit/app_button.dart';
import '../../core/utils/animated_button.dart';

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
        UpdateRecipeEvent(widget.recipe.copyWith(isCompleted: true)),
      );
      showCupertinoDialog(
        context: context,
        builder:
            (_) => Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              child: SizedBox(
                width: 230,
                height: 270,
                child: StatefulBuilder(
                  builder:
                      (context, setState) => Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AppButton(
                            color: ButtonColors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _actions(context, () => setState(() {}), true),
                                Text(
                                  'Winner Winner Chicken Dinner!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF66A14A),
                                    fontSize: 32,
                                  ),
                                ),
                                Gap(15),
                                const Text('You have completed this recipe!'),
                                Gap(10),
                                AppButton(
                                  fixedSize: Size(161, 61),
                                  borderRadius: 17,
                                  onPressed:
                                      () =>
                                          context
                                            ..pop()
                                            ..pop(),
                                  color: ButtonColors.yellow,
                                  child: const Text(
                                    'back',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ),
      );
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: AppIcon(
                    asset: widget.recipe.image,
                    width: getWidth(context, percent: 1) - 32,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                Gap(15),

                ListView.separated(
                  itemCount: widget.recipe.ingredients.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Gap(16),
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color(0xFFFDC662),
                              ),
                              child: SizedBox(
                                width: 52,
                                height: 52,
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AppButton(
                              borderRadius: 22,
                              color: ButtonColors.white,
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 10,
                                ),
                                child: SizedBox(
                                  width: getWidth(context, percent: 1) - 110,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width:
                                              getWidth(context, percent: 1) -
                                              283,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,

                                            child: Text(
                                              widget
                                                  .recipe
                                                  .ingredients[index]
                                                  .name,
                                              style: TextStyle(
                                                color: Color(0xFF66A14A),
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Color(0xFFFDC662),
                                              width: 2,
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 71,
                                            height: 52,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                  ),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    widget
                                                        .recipe
                                                        .ingredients[index]
                                                        .quantity,
                                                    style: TextStyle(
                                                      color: Color(0xFFFDC662),
                                                      fontSize: 23,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(10),
                                        AppButton(
                                          color: ButtonColors.yellow,
                                          borderRadius: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: AppIcon(
                                              asset:
                                                  IconProvider.shop
                                                      .buildImageUrl(),
                                              width: 32,
                                              height: 32,
                                            ),
                                          ),
                                          onPressed: () {
                                            context.read<AppBloc>().add(
                                              AddShoppingItemEvent(
                                                ShoppingList(
                                                  id: const Uuid().v4(),
                                                  name:
                                                      widget
                                                          .recipe
                                                          .ingredients[index]
                                                          .name,
                                                  quantity:
                                                      widget
                                                          .recipe
                                                          .ingredients[index]
                                                          .quantity,
                                                ),
                                              ),
                                            );
                                            showCupertinoSnackBar(
                                              context,
                                              '${widget.recipe.ingredients[index].name}: Added to shopping list',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
                Gap(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF97c480),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.08),
                          offset: Offset(0, 4),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          SizedBox(
                            width: getWidth(context, percent: 0.7),
                            height: getHeight(context, percent: 0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Step ${currentStep + 1} of ${widget.recipe.steps.length}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    step.description,
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                        Text(
                                          '$_timeLeft',
                                          style: TextStyle(
                                            fontSize: 58,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          if (currentStep > 0)
                          Positioned( left: 0, child: AnimatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: AppIcon(
                                asset: IconProvider.back.buildImageUrl(),
                                width: 50,
                                height: 43,
                              ),
                            ),
                            onPressed: () {
                              if (currentStep > 0) {
                                setState(() {
                                  currentStep--;
                                });
                                _setupCurrentStepTimer();
                              }
                            },
                          ),),
                          Positioned( right: 0, child: AnimatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Transform.rotate(
                                angle: 3.14,
                                child: AppIcon(
                                  asset: IconProvider.back.buildImageUrl(),
                                  width: 50,
                                  height: 43,
                                ),
                              ),
                            ),
                            onPressed: _goToNextStep,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
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
                    child: Text(
                      widget.recipe.title,
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                  ),
                ),
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
      mainAxisAlignment: isdialog? MainAxisAlignment.end :MainAxisAlignment.start,
      children: [
        AnimatedButton(
          child: AppIcon(
            asset:
                isFavorite
                    ? IconProvider.heart.buildImageUrl()
                    : IconProvider.heartGrey.buildImageUrl(),
            width: 42,
            height: 39,
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
          icon: DecoratedBox(
            decoration: BoxDecoration(
              color: isdialog? Color(0xFFFDC662):Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.only(right:isdialog? 2:0),
              child: AppIcon(
                asset: IconProvider.share.buildImageUrl(),
                width: 42,
                height: 42,
              ),
            ),
          ),
          onPressed:
              () => _shareRecipe(isdialog ? shareButtonKey2 : shareButtonKey),
        ),
      ],
    );
  }
}
