import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/core/constants/enums.dart';

class CategoryChips extends StatelessWidget {
  final RxString selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      ...FoodCategory.values.map((e) => e.displayName),
    ];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = selectedCategory.value == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category),
                label: Text(category),
                backgroundColor: Colors.grey[200],
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
