
import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';
import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/src/main/model/shopping_list.dart';
import 'package:cluckmazing_recipe/ui_kit/app_bar.dart';

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
              child: state.shoppingList.length == 0
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
                                  bottomPadding: 6,
                                  color: ButtonColors.purple,
                                  widget: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              getWidth(context, percent: 0.35),
                                          child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(item.name)),
                                        ),
                                        Text(item.quantity),
                                      ],
                                    ),
                                  ),
                                  width: getWidth(context, percent: 1) -
                                      16 -
                                      22 -
                                      140,
                                  height: 87,
                                ),
                                const Gap(11),
                                AppButton(
                                  color: ButtonColors.blue,
                                  bottomPadding: 5,
                                  widget: AppIcon(
                                    asset: IconProvider.shop.buildImageUrl(),
                                    width: 50,
                                    height: 43,
                                  ),
                                  onPressed: () => removeItem(item, context),
                                  width: 61,
                                  height: 61,
                                ),
                                const Gap(11),
                                AppButton(
                                  color: ButtonColors.red,
                                  width: 61,
                                  height: 61,
                                  bottomPadding: 5,
                                  widget: AppIcon(
                                    asset: IconProvider.remove.buildImageUrl(),
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
                                width: getWidth(context, percent: 0.4),
                                color: ButtonColors.red,
                                onPressed: () => removeAll(context),
                                widget: const Text('remove all', style: TextStyle(fontSize: 27),),
                                height: 80,
                                bottomPadding: 8,
                              ),
                              AppButton(
                                width: getWidth(context, percent: 0.4),
                                height: 80,
                                bottomPadding: 8,
                                color: ButtonColors.green,
                                onPressed: () => removeAll(context),
                                widget: const Text('buy all', style: TextStyle(fontSize: 27),),
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
