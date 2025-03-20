import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:cluckmazing_recipe/ui_kit/app_bar.dart' show AppBarWidget;
import 'package:cluckmazing_recipe/ui_kit/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/utils/size_utils.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 110,
                bottom: MediaQuery.of(context).padding.bottom + 96,
              ),
              child:
                  state.history.length == 0
                      ? Center(
                        child: Text(
                          'History is empty',
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
                              final item = state.history[index];
                              return AppButton(
                                borderRadius: 22,
                                color: ButtonColors.white,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            getWidth(context, percent: 1) - 70,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 9,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    getWidth(
                                                      context,
                                                      percent: 1,
                                                    ) -
                                                    200,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment:
                                                      Alignment.centerLeft,

                                                  child: Text(
                                                    item.shoppingList.name,
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
                                                          item
                                                              .shoppingList
                                                              .quantity,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      Gap(5),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formatDate(item.dateTime),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
            ),
            AppBarWidget(
              widgets: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shopping history',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ],
              ),
              hasBackButton: true,
            ),
          ],
        );
      },
    );
  }
}

String formatDate(DateTime date) {
  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return "${date.day} ${months[date.month - 1]} ${date.year}";
}
