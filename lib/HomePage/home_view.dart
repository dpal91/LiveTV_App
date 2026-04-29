import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:testlive/HomePage/category_pannel.dart';
import 'package:testlive/HomePage/channel_grid.dart';
import 'package:testlive/HomePage/home_view_controller.dart';
import 'package:testlive/HomePage/search_bar.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());
  final FocusNode categoryFocus = FocusNode();
  final FocusNode gridFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: Column(
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
                            categories: controller.filteredCategories,
                            selectedIndex:
                                controller.selectedCategoryIndex.value,
                            onSelect: controller.openGrid,
                            focusNode: categoryFocus,
                          )
                        : const SizedBox.shrink(),
                  ),

                  /// RIGHT PANEL – Grid
                  Expanded(
                    child: controller.filteredCategories.isNotEmpty &&
                            controller.selectedCategoryIndex.value >= 0
                        ? ChannelGrid(
                            channels: controller.selectedCategory.channels,
                            focusNode: gridFocus,
                          )
                        : const Center(
                            child: Text('No channels to display',
                                style: TextStyle(color: Colors.white)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
