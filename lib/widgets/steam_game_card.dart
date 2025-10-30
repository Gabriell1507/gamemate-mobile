import 'package:flutter/material.dart';

class SteamGameCard extends StatelessWidget {
  final String name;
  final String? coverUrl;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool isPlatinado; // novo parâmetro para animação platinado

  const SteamGameCard({
    required this.name,
    this.coverUrl,
    this.onTap,
    this.borderColor,
    this.isPlatinado = false,
    Key? key,
  }) : super(key: key);

  static const double cardWidth = 193;
  static const double imageHeight = 250;
  static const double borderWidth = 2;

  @override
  Widget build(BuildContext context) {
    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: imageHeight,
        child: coverUrl != null
            ? Image.network(
                coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white70,
                    size: 40,
                  ),
                ),
              )
            : Container(
                color: Colors.grey[800],
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
      ),
    );

    // Se for platinado, aplica borda animada
    if (isPlatinado) {
      cardContent = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 6),
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: borderWidth, color: Colors.transparent),
            ),
            child: ShaderMask(
              shaderCallback: (rect) {
                return SweepGradient(
                  startAngle: 0,
                  endAngle: 6.28319,
                  colors: const [
                    Color(0xFFE5E4E2),
                    Color(0xFFE5E4E2),
                    Color(0xFF00FFFF),
                    Color(0xFF00FFC4),
                    Color(0xFF00FFFF),
                    Color(0xFFE5E4E2),
                    Color(0xFFE5E4E2),
                  ],
                  stops: const [0, 0.2, 0.33, 0.42, 0.52, 0.64, 1],
                  transform: GradientRotation(6.28319 * value),
                ).createShader(rect);
              },
              child: Container(
                margin: const EdgeInsets.all(borderWidth),
                child: child,
              ),
            ),
          );
        },
        child: cardContent,
      );
    } else if (borderColor != null) {
      // Borda sólida para outros status
      cardContent = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor!, width: borderWidth),
        ),
        child: cardContent,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cardContent,
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
