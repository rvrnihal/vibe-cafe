import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';

class FoodCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const FoodCard({
    super.key,
    required this.foodItem,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddToCart,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with discount badge
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.asset(
                      foodItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          '🍽️',
                          style: context.textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (foodItem.discount != null && foodItem.discount! > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${foodItem.discount!.toStringAsFixed(0)}%',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        foodItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: foodItem.isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    foodItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating and Review Count
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${foodItem.rating}',
                        style: context.textTheme.labelSmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${foodItem.reviewCount})',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (foodItem.discount != null && foodItem.discount! > 0)
                            Text(
                              foodItem.price.toCurrency(),
                              style: context.textTheme.labelSmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            foodItem.discountedPrice.toCurrency(),
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      // Add to cart button
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
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
