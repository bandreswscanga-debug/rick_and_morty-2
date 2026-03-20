import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/character_provider.dart';

/// Placeholder Explore screen: the `Character` model and `ApiService` are
/// maintained by another branch/teammate. This minimal screen avoids
/// importing those files locally to prevent merge conflicts.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharacterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore, size: 84, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Explorar personajes (implementación en otra rama)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Acción mínima: navegar a favoritos
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SizedBox.shrink()));
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Ir a Favoritos'),
              ),
              const SizedBox(height: 8),
              Text('Favoritos: ${provider.favorites.length}'),
            ],
          ),
        ),
      ),
    );
  }
}