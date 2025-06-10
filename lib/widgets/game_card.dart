import 'package:flutter/material.dart';
import 'package:gamemate/modules/games/data/models/games_model.dart';

class GameCard extends StatelessWidget {
  final IGDBGame game;

  const GameCard({required this.game, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 193;
    const double imageHeight = 250;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagem do jogo com borda arredondada
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: imageHeight,
              child: Image.network(
                game.coverImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.white70, size: 40),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Nome do jogo abaixo da imagem
          Text(
            game.name,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
