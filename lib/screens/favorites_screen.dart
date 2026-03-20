import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/character_provider.dart';
import '../models/character.dart';
import 'explore_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use watch so the list updates when favorites cambian
    final favorites = context.watch<CharacterProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              tooltip: 'Limpiar favoritos',
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('¿Deseas eliminar todos los favoritos?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ).then((confirm) {
                  if (confirm == true) {
                    if (!context.mounted) return;
                    context.read<CharacterProvider>().clearFavorites();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favoritos eliminados')),
                    );
                  }
                });
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? _EmptyFavorites(onExplore: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExploreScreen()),
              );
            })
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final id = favorites[index];
                final data = context.read<CharacterProvider>().favoriteData(id);
                final displayName = data != null ? data['name'] ?? 'Personaje' : 'Personaje ID: $id';
                final displayStatus = data != null ? data['status'] ?? '' : 'ID: $id';
                final imageUrl = data != null ? data['image'] ?? '' : '';

                return Dismissible(
                  key: ValueKey(id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    // capture data for undo
                    final removedData = context.read<CharacterProvider>().favoriteData(id);
                    context.read<CharacterProvider>().removeFavorite(id);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed favorite: $displayName'),
                        action: SnackBarAction(
                          label: 'Deshacer',
                          onPressed: () {
                            if (removedData != null) {
                              // recreate a minimal Character for restoring
                              context.read<CharacterProvider>().addFavorite(
                                  id,
                                  character: Character(
                                    id: int.tryParse(id) ?? 0,
                                    name: removedData['name'] ?? '',
                                    status: removedData['status'] ?? '',
                                    image: removedData['image'] ?? '',
                                  ));
                            } else {
                              context.read<CharacterProvider>().addFavorite(id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: imageUrl.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                          : CircleAvatar(
                              child: Text(
                                id.isNotEmpty ? id[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                      title: Text(displayName),
                      subtitle: Text(displayStatus),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context.read<CharacterProvider>().removeFavorite(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Quitado de favoritos')),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyFavorites({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 84, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'No tienes favoritos aún',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.explore),
              label: const Text('Explorar personajes'),
            ),
          ],
        ),
      ),
    );
  }
}