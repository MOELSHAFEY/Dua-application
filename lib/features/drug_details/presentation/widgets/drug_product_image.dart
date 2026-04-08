import 'package:flutter/material.dart';
import 'package:dua/core/theme/colors.dart';
import 'package:dua/core/entities/drug.dart';

class DrugProductImage extends StatelessWidget {
  final Drug drug;
  final VoidCallback onTap;

  const DrugProductImage({
    super.key,
    required this.drug,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Hero(
          tag: 'drug_img_${drug.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              drug.image.contains("http")
                  ? Image.network(
                    drug.image,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                  )
                  : _buildPlaceholderImage(),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fullscreen_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.medication_rounded,
          size: 100,
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
