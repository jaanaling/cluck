import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';
import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';
import 'package:cluckmazing_recipe/ui_kit/app_bar.dart';
import 'package:cluckmazing_recipe/ui_kit/app_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/animated_button.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  void removeItem(ShoppingList item, BuildContext context) {
    context.read<AppBloc>().add(RemoveShoppingItemEvent(item));
  }

  void removeAll(BuildContext context) {
    context.read<AppBloc>().add(RemoveAllShoppingItemsEvent());
  }

  void buyItem(ShoppingList item, BuildContext context) {
    context.read<AppBloc>().add(SaveHistoryItemEvent(item));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) return const SizedBox();

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 110,
                bottom: MediaQuery.of(context).padding.bottom + 96,
              ),
              child:
                  state.shoppingList.length == 0
                      ? Center(
                        child: Text(
                          'Shopping list is empty',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      )
                      : Column(
                        children: [
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: state.shoppingList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => const Gap(16),
                            itemBuilder: (context, index) {
                              final item = state.shoppingList[index];
                              return AppButton(
                                borderRadius: 22,
                                color: ButtonColors.white,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 10,
                                  ),
                                  child: SizedBox(
                                    width: getWidth(context, percent: 1) - 70,
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
                                                item.name,
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                      item.quantity,
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFFDC662,
                                                        ),
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
                                            onPressed:
                                                () => buyItem(item, context),
                                          ),
                                          const Gap(11),
                                          AnimatedButton(
                                            child: AppIcon(
                                              asset:
                                                  IconProvider.delete
                                                      .buildImageUrl(),
                                              width: 33,
                                              height: 33,
                                            ),
                                            onPressed:
                                                () => removeItem(item, context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
            ),
            AppBarWidget(
              widgets: Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Shopping List',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    Spacer(),
                    AnimatedButton(
                      child: const Icon(
                        size: 32,
                        Icons.history_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.push('/home/history');
                      },
                    ),
                    Gap(32)
                  ],
                ),
              ),
              hasBackButton: true,
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getWidth(context, percent: 1) - 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        borderRadius: 17,
                        elevation: 1,
                        fixedSize: Size(161, 61),
                        color: ButtonColors.red,
                        onPressed: () => removeAll(context),
                        child: const Text(
                          'remove all',
                          style: TextStyle(fontSize: 29, color: Colors.white),
                        ),
                      ),
                      AppButton(
                        borderRadius: 17,
                        elevation: 1,
                        fixedSize: Size(161, 61),
                        color: ButtonColors.yellow,
                        onPressed: () => removeAll(context),
                        child: const Text(
                          'buy all',
                          style: TextStyle(fontSize: 29, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
