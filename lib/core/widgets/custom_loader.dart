import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/colors.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const CustomLoader({
    super.key,
    this.size = 70,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? AppColors.primary;
    final accent = accentColor ?? primary.withOpacity(0.2);

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow effect
            FadeIn(
              duration: const Duration(milliseconds: 300),
              child: Pulse(
                infinite: true,
                duration: const Duration(milliseconds: 2000),
                child: Container(
                  width: size * 1.1,
                  height: size * 1.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.15),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Outer rotating ring with gradient
            Spin(
              infinite: true,
              duration: const Duration(milliseconds: 2000),
              spins: 1,
              child: Container(
                width: size * 0.85,
                height: size * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      primary,
                      primary.withOpacity(0.7),
                      accent,
                      accent.withOpacity(0.1),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.4, 0.6, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Middle static ring for depth
            Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent.withOpacity(0.3), width: 2),
              ),
            ),

            // Counter-rotating inner ring
            SpinPerfect(
              infinite: true,
              duration: const Duration(milliseconds: 3000),
             
              child: Container(
                width: size * 0.55,
                height: size * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      primary.withOpacity(0.5),
                      primary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Central pulsing icon container
            Pulse(
              infinite: true,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                width: size * 0.4,
                height: size * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: size * 0.25,
                ),
              ),
            ),

            // Subtle inner highlight
            Positioned(
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative minimalist loader
class CustomLoaderMinimal extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoaderMinimal({super.key, this.size = 50, this.color});

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? AppColors.primary;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Spin(
              infinite: true,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border(
                    top: BorderSide(color: loaderColor, width: 3),
                    right: BorderSide(
                      color: loaderColor.withOpacity(0.3),
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: loaderColor.withOpacity(0.1),
                      width: 3,
                    ),
                    left: BorderSide(
                      color: loaderColor.withOpacity(0.6),
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
            Icon(
              Icons.medical_services_rounded,
              color: loaderColor,
              size: size * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}

// Dots loader variant
class CustomLoaderDots extends StatelessWidget {
  final Color? color;

  const CustomLoaderDots({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? AppColors.primary;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(dotColor, 0),
          const SizedBox(width: 8),
          _buildDot(dotColor, 200),
          const SizedBox(width: 8),
          _buildDot(dotColor, 400),
        ],
      ),
    );
  }

  Widget _buildDot(Color color, int delay) {
    return FadeInUp(
      from: 10,
      delay: Duration(milliseconds: delay),
      duration: const Duration(milliseconds: 600),
      child: Pulse(
        infinite: true,
        delay: Duration(milliseconds: delay),
        duration: const Duration(milliseconds: 1200),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
