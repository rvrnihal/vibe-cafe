import 'package:flutter/material.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    color: isDark ? const Color(0xFF252528) : const Color(0xFFF7ECE1).withOpacity(0.3),
                    child: Image.asset(
                      foodItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Text(
                          '☕',
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                  
                  // Discount Badge
                  if (foodItem.discount != null && foodItem.discount! > 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3B30).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${foodItem.discount!.toStringAsFixed(0)}%',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    
                  // Favorite Button
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          foodItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: foodItem.isFavorite ? const Color(0xFFFF3B30) : Colors.grey[600],
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    foodItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Rating & Prep Time
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF6C453)),
                      const SizedBox(width: 4),
                      Text(
                        '${foodItem.rating}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.grey[300] : const Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${foodItem.reviewCount})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 3),
                      Text(
                        '${foodItem.preparationTime}m',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Bottom Row: Price & Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (foodItem.discount != null && foodItem.discount! > 0)
                            Text(
                              foodItem.price.toCurrency(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                              ),
                            ),
                          Text(
                            foodItem.discountedPrice.toCurrency(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      
                      // Animated Add Button
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20,
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
