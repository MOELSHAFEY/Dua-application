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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            child: Hero(
              tag: 'drug_img_${drug.id}',
              child: Stack(
                children: [
                  Center(
                    child: drug.image.contains("http")
                        ? Image.network(
                            drug.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.zoom_in_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(
        Icons.medication_outlined,
        size: 72,
        color: AppColors.textLight,
      ),
    );
  }
}
