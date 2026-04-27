import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:testlive/HomePage/CategoryPannel.dart';
import 'package:testlive/HomePage/ChannelGrid.dart';
import 'package:testlive/HomePage/HomeViewController.dart';
import 'package:testlive/HomePage/Searchbar.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  HomeController controller = Get.put(HomeController());
  final FocusNode categoryFocus = FocusNode();
  final FocusNode gridFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
                !controller.showCategories.value) {
              controller.showCategories.toggle();
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(
            () {
              return Column(
                children: [
                  // Search Bar at the top
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchBarPannel(
                      onSearchChanged: controller.updateSearchText,
                    ),
                  ),

                  // Main content (category panel and grid)
                  Expanded(
                    child: Row(
                      children: [
                        /// LEFT PANEL – Categories
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: controller.showCategories.value ? 260 : 0,
                          child: controller.showCategories.value
                              ? CategoryPanel(
                                  categories:
                                      controller.filteredCategories.value,
                                  selectedIndex:
                                      controller.selectedCategoryIndex.value,
                                  onSelect: controller.openGrid,
                                  focusNode: categoryFocus,
                                )
                              : const SizedBox.shrink(),
                        ),

                        /// RIGHT PANEL – Grid
                        Expanded(
                          child: ChannelGrid(
                            channels: controller.selectedCategory.channels,
                            focusNode: gridFocus
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
