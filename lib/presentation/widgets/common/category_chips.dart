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
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category),
                label: Text(category),
                elevation: isSelected ? 3 : 0,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected 
                        ? Colors.transparent 
                        : Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
