import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const CustomLoader({
    super.key,
    this.size = 36,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? AppColors.primary;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

class CustomLoaderMinimal extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoaderMinimal({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        ),
      ),
    );
  }
}

class CustomLoaderDots extends StatelessWidget {
  final Color? color;

  const CustomLoaderDots({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        ),
      ),
    );
  }
}
