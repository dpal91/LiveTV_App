import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testlive/HomePage/models.dart';

class CategoryPanel extends StatelessWidget {
  final List<Categories> categories;
  final int selectedIndex;
  final Function(int) onSelect;
  final FocusNode focusNode;

  const CategoryPanel({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print('Selected: ${categories[index].name}');
              }
              onSelect(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              color: selected ? Colors.blueAccent : Colors.transparent,
              child: Text(
                categories[index].name,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
