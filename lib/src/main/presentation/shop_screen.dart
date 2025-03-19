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

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  void removeItem(ShoppingList item, BuildContext context) {
    context.read<AppBloc>().add(RemoveShoppingItemEvent(item));
  }

  void removeAll(BuildContext context) {
    context.read<AppBloc>().add(RemoveAllShoppingItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) return const SizedBox();

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 140),
              child:
                  state.shoppingList.length == 0
                      ? Center(child: Text('Shopping list is empty'))
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
                              return Row(
                                children: [
                                  AppButton(
                                    color: ButtonColors.yellow,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: getWidth(
                                              context,
                                              percent: 0.35,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(item.name),
                                            ),
                                          ),
                                          Text(item.quantity),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(11),
                                  AppButton(
                                    color: ButtonColors.yellow,
                                    child: AppIcon(
                                      asset: IconProvider.shop.buildImageUrl(),
                                      width: 50,
                                      height: 43,
                                    ),
                                    onPressed: () => removeItem(item, context),
                                  ),
                                  const Gap(11),
                                  AppButton(
                                    color: ButtonColors.red,
                                    child: AppIcon(
                                      asset:
                                          IconProvider.delete.buildImageUrl(),
                                      width: 50,
                                      height: 43,
                                    ),
                                    onPressed: () => removeItem(item, context),
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppButton(
                                  color: ButtonColors.red,
                                  onPressed: () => removeAll(context),
                                  child: const Text(
                                    'remove all',
                                    style: TextStyle(fontSize: 27),
                                  ),
                                ),
                                AppButton(
                                  color: ButtonColors.yellow,
                                  onPressed: () => removeAll(context),
                                  child: const Text(
                                    'buy all',
                                    style: TextStyle(fontSize: 27),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            ),
            const AppBarWidget(
              widgets: Text('Shopping List'),
              hasBackButton: true,
            ),
          ],
        );
      },
    );
  }
}
