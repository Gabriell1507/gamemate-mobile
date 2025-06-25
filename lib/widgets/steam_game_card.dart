import 'package:flutter/material.dart';

class SteamGameCard extends StatelessWidget {
  final String name;
  final String? coverUrl;
  final VoidCallback? onTap;

  const SteamGameCard({
    required this.name,
    this.coverUrl,
    this.onTap,
    Key? key,
  }) : super(key: key);

  static const double cardWidth = 193;
  static const double imageHeight = 250;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: imageHeight,
                child: coverUrl != null
                    ? Image.network(
                        coverUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.blueAccent,
                            ),
                          );
                        },
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
            ),
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
