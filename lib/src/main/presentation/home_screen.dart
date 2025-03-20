import 'dart:io';

import 'package:cluckmazing_recipe/routes/route_value.dart';
import 'package:cluckmazing_recipe/src/core/utils/animated_button.dart';
import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/cupertino_snack_bar.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';
import 'package:cluckmazing_recipe/src/core/utils/text_with_border.dart';
import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/src/main/model/recipe.dart';
import 'package:cluckmazing_recipe/ui_kit/app_bar.dart';
import 'package:cluckmazing_recipe/ui_kit/app_button.dart';
import 'package:cluckmazing_recipe/ui_kit/gradient_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

enum RecipeScreenMode { common, cluckmazing, favorites }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeScreenMode currentMode = RecipeScreenMode.common;
  String searchQuery = '';
  bool showCompletedOnly = false;
  int showDiffulty = 0;
  int showSpicy = 0;

  void showFilterPopup() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => CupertinoActionSheet(
            title: const Text('Select filter',
              style: TextStyle(
                fontFamily: 'mexe',
              ),),
            message: const Text('Filter by spice or difficulty',
              style: TextStyle(
                fontFamily: 'mexe',
              ),),
            actions: [
              CupertinoActionSheetAction(
                child: const Text(
                  'Filter by difficulty',
                  style: TextStyle(
                    fontFamily: 'mexe',
                    color: Color(0xFF4B0000),
                  ),
                ),
                onPressed: () {
                  // Закрываем ActionSheet и открываем Picker
                  context.pop();
                  showDifficultyPicker();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text(
                  'Filter by spicy',
                  style: TextStyle(
                    fontFamily: 'mexe',
                    color: Color(0xFF4B0000),
                  ),
                ),
                onPressed: () {
                  // Закрываем ActionSheet и открываем Picker
                  context.pop();
                  showSpicyPicker();
                },
              ),
              if (Platform.isIOS)
                CupertinoActionSheetAction(
                  child: const Text(
                    'Reset filters',
                    style: TextStyle(
                      fontFamily: 'mexe',
                      color: Color(0xFF4B0000),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showCompletedOnly = false;
                      showDiffulty = 0;
                    });
                    context.pop();
                  },
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Clear',
                style: TextStyle(fontFamily: 'mexe', color: Color(0xFF780000)),
              ),
              isDefaultAction: true,
              onPressed: () {
                context.pop();
              },
            ),
          ),
    );
  }

  // Метод, который показывает выбор сложности
  void showDifficultyPicker() {
    // Сохраняем текущее значение сложности,
    // чтобы при прокрутке Picker не менять
    // состояние экрана до подтверждения
    int tempDifficulty = showDiffulty;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: tempDifficulty,
                  ),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    tempDifficulty = index;
                  },
                  children: List<Widget>.generate(6, (int index) {
                    // Можно ограничить, например, от 0 до 5, где 0 = без фильтра
                    return Center(
                      child: Text(
                        index == 0
                            ? "Clear"
                            : getChickenRecipeDifficulty(index),
                        style: TextStyle(
                          fontFamily: 'mexe',
                          color: Color(0xFF4B0000),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Apply',
                  style: TextStyle(fontFamily: 'mexe'),
                ),
                onPressed: () {
                  setState(() {
                    showDiffulty = tempDifficulty;
                  });
                  context.pop(); // Закрываем Picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getChickenRecipeDifficulty(int level) {
    switch (level) {
      case 1:
        return "Easy";
      case 2:
        return "Basic";
      case 3:
        return "Medium";
      case 4:
        return "Hard";
      case 5:
        return "Expert";
      default:
        return "Invalid";
    }
  }

  String getSpicinessLevel(int level) {
    switch (level) {
      case 1:
        return "Mild";
      case 2:
        return "Low";
      case 3:
        return "Medium";
      case 4:
        return "Hot";
      case 5:
        return "Fiery";
      default:
        return "Invalid";
    }
  }

  void showSpicyPicker() {
    // Сохраняем текущее значение сложности,
    // чтобы при прокрутке Picker не менять
    // состояние экрана до подтверждения
    int tempSpicy = showSpicy;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: tempSpicy,
                  ),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    tempSpicy = index;
                  },
                  children: List<Widget>.generate(6, (int index) {
                    // Можно ограничить, например, от 0 до 5, где 0 = без фильтра
                    return Center(
                      child: Text(
                        index == 0 ? "Clear" : getSpicinessLevel(index),
                        style: TextStyle(
                          fontFamily: 'mexe',
                          color: Color(0xFF4B0000),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Apply',
                  style: TextStyle(fontFamily: 'mexe'),
                ),
                onPressed: () {
                  setState(() {
                    showSpicy = tempSpicy;
                  });
                  context.pop(); // Закрываем Picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Recipe> filteredRecipes(List<Recipe> allRecipes) {
    List<Recipe> byCategory;
    switch (currentMode) {
      case RecipeScreenMode.common:
        byCategory =
            allRecipes
                .where((r) => r.category == RecipeCategory.normal)
                .toList();
      case RecipeScreenMode.cluckmazing:
        byCategory =
            allRecipes
                .where((r) => r.category == RecipeCategory.cluckmazing)
                .toList();
      case RecipeScreenMode.favorites:
        byCategory = allRecipes.where((r) => r.isFavorite).toList();
    }

    if (showCompletedOnly) {
      byCategory = byCategory.where((r) => r.isCompleted).toList();
    }

    if (showDiffulty > 0) {
      byCategory =
          byCategory.where((r) => r.difficulty == showDiffulty).toList();
    }
    if (showSpicy > 0) {
      byCategory = byCategory.where((r) => r.spicy == showSpicy).toList();
    }

    if (searchQuery.isNotEmpty) {
      byCategory =
          byCategory
              .where(
                (r) =>
                    r.title.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    }

    return byCategory;
  }

  void toggleFavorite(Recipe recipe) {
    context.read<AppBloc>().add(
      UpdateRecipeEvent(recipe.copyWith(isFavorite: !recipe.isFavorite)),
    );
  }

  void openRecipe(Recipe recipe) {
    context.push(
      '${RouteValue.home.path}/${RouteValue.recipe.path}',
      extra: recipe,
    );
  }

  void openShoppingList() {
    context.push('${RouteValue.home.path}/${RouteValue.shop.path}');
  }

  Widget buildCategoryButtons() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: SizedBox(
            width: getWidth(context, percent: 1) - 19,
            height: getHeight(context, baseSize: 75) + 45,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryButton(
                category: Category.ordinary,
                isActive: currentMode == RecipeScreenMode.common,
                onTap: () {
                  setState(() {
                    currentMode = RecipeScreenMode.common;
                  });
                },
              ),
              _buildCategoryButton(
                category: Category.cluckmazing,
                isActive: currentMode == RecipeScreenMode.cluckmazing,
                onTap: () {
                  setState(() {
                    currentMode = RecipeScreenMode.cluckmazing;
                  });
                },
              ),
              _buildCategoryButton(
                category: Category.favorites,
                isActive: currentMode == RecipeScreenMode.favorites,
                onTap: () {
                  setState(() {
                    currentMode = RecipeScreenMode.favorites;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required Category category,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onPressed: onTap,
      child: Opacity(
        opacity: isActive ? 1 : 0.36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: category.colors,
                    ),
                  ),
                  child: SizedBox(
                    width: getWidth(context, baseSize: 102),
                    height: getHeight(context, baseSize: 66),
                  ),
                ),
                AppIcon(
                  asset: category.iconPath,
                  width: getWidth(context, baseSize: 102),
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            Gap(4),
            SizedBox(
              width: getWidth(context, baseSize: 102),
              child: Text(
                category.label,

                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: category.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTop(List<Recipe> allRecipes, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: AppIcon(
            asset: IconProvider.filter.buildImageUrl(),
            width: 32,
            height: 32,
          ),
          onPressed: () {
            showFilterPopup();
          },
        ),
        SizedBox(
          height: 51,
          width: getWidth(context, baseSize: 221),
          child: CupertinoTextField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                filteredRecipes(allRecipes);
              });
            },
            prefix: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: AppIcon(asset: IconProvider.search.buildImageUrl()),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white.withOpacity(0.54)],
              ),
            ),
          ),
        ),
        Gap(11),
        buildCartIcon(count),
      ],
    );
  }

  Widget buildCartIcon(int count) {
    return AnimatedButton(
      onPressed: openShoppingList,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppIcon(
            asset: IconProvider.shop.buildImageUrl(),
            width: 32,
            height: 32,
          ),
          if (count > 0)
            Positioned(
              right: -3,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withOpacity(0.1),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRecipeItem(Recipe recipe, bool isLocked, int requiredCount) {
    return Stack(
      children: [
        AppButton(
          elevation: 0.5,
          gradientColors:
              isLocked ? [Color(0xFFf66f30), Color(0xFFca7236)] : null,
          fixedSize: Size(152, 266),
          color: ButtonColors.yellow,
          child:
              !isLocked
                  ? Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: AppIcon(
                            asset: recipe.image,
                            width: 139,
                            height: 93,
                          ),
                        ),
                        Gap(6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140,
                                child: Text(
                                  recipe.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        recipe.title.length < 23 ? 20 : 17,
                                    color: Color(0xFF4B0000),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    AppIcon(
                                      asset:
                                          IconProvider.difficulty
                                              .buildImageUrl(),
                                      width: 32,
                                      height: 32,
                                    ),
                                    Gap(5),
                                    Text(
                                      recipe.difficulty.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF4B0000),
                                      ),
                                    ),
                                    Gap(19),
                                    AppIcon(
                                      asset:
                                          IconProvider.ingredients
                                              .buildImageUrl(),
                                      width: 32,
                                      height: 32,
                                    ),
                                    Gap(5),
                                    Text(
                                      recipe.ingredients.length.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF4B0000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(3),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    AppIcon(
                                      asset: IconProvider.spicy.buildImageUrl(),
                                      width: 32,
                                      height: 32,
                                    ),
                                    Gap(5),
                                    Text(
                                      recipe.spicy.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF4B0000),
                                      ),
                                    ),
                                    Gap(19),
                                    AppIcon(
                                      asset: IconProvider.timer.buildImageUrl(),
                                      width: 32,
                                      height: 32,
                                    ),
                                    Gap(5),
                                    Text(
                                      recipe.timeInMinutes.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF4B0000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (recipe.isCompleted)
                                    const Text(
                                      'done',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF4B0000),
                                      ),
                                    )
                                  else
                                    const Text(
                                      'in progress',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF4B0000),
                                      ),
                                    ),
                                  Gap(10),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child:
                                          recipe.isCompleted
                                              ? Icon(
                                                CupertinoIcons.check_mark,
                                                color: Color(0xFF4B0000),
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  : Stack(
                    children: [
                      Positioned(
                        top: 12,
                        left: 12,
                        child: AppIcon(
                          asset: IconProvider.close.buildImageUrl(),
                          width: 30,
                          height: 30,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(22),
                            ),
                            color: Colors.black.withOpacity(0.44),
                          ),
                          child: SizedBox(
                            width: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Need to unlock $requiredCount more',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: AppIcon(
                          asset: IconProvider.closeRes.buildImageUrl(),
                          width: 152,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
          onPressed:
              () =>
                  isLocked
                      ? showCupertinoSnackBar(
                        context,
                        'This recipe is locked. Need complite previous recipes to unlock this one. You need to complete $requiredCount more',
                      )
                      : openRecipe(recipe),
        ),
        if (!isLocked)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 9),
            child: AnimatedButton(
              child: AppIcon(
                fit: BoxFit.cover,
                asset:
                    recipe.isFavorite
                        ? IconProvider.heart.buildImageUrl()
                        : IconProvider.heartGrey.buildImageUrl(),
                width: 34,
                height: 32,
              ),
              onPressed: () {
                toggleFavorite(recipe);
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded)
          return const Center(child: CupertinoActivityIndicator());

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 80),
              child: SafeArea(
                child: Column(
                  children: [
                    buildCategoryButtons(),
                    Gap(22),
                    if (currentMode != RecipeScreenMode.cluckmazing)
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children:
                            filteredRecipes(state.recipes).map((recipe) {
                              return buildRecipeItem(recipe, false, 0);
                            }).toList(),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            for (final recipe in filteredRecipes(state.recipes))
                              buildRecipeItem(
                                recipe,
                                recipe.isLocked,
                                recipe.requiredCountToUnlock -
                                    state.recipes
                                        .where((r) => r.isCompleted)
                                        .length,
                              ),
                          ],
                        ),
                      ),
                    Gap(22),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                child: buildTop(state.recipes, state.shoppingList.length),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum Category {
  ordinary(
    colors: [Color(0xFF6499FC), Color(0xFF3C5B96)],
    iconPath: 'assets/images/ord_res.png',
    label: 'Ordinary\nrecipes',
    textColor: Color(0xFF1E68D7),
  ),
  cluckmazing(
    colors: [Color(0xFFBF64FC), Color(0xFF723C96)],
    iconPath: 'assets/images/cl_res.png',
    label: 'Cluckmazing\nrecipes',
    textColor: Color(0xFF54009E),
  ),
  favorites(
    colors: [Color(0xFFBDEA2B), Color(0xFF969B00)],
    iconPath: 'assets/images/fav_res.png',
    label: 'Favorite\nrecipes',
    textColor: Color(0xFF579E00),
  );

  final List<Color> colors;
  final String iconPath;
  final String label;
  final Color textColor;

  const Category({
    required this.colors,
    required this.iconPath,
    required this.label,
    required this.textColor,
  });
}
