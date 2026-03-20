import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../services/api_service.dart';
import '../provider/character_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Character>> _futureCharacters;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureCharacters = _api.fetchCharacters();
  }

  Future<void> _refresh() async {
    setState(() => _load());
    await _futureCharacters;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CharacterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar')),
      body: FutureBuilder<List<Character>>(
        future: _futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 72, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    const Text('Error al cargar personajes'),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _load()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final characters = snapshot.data ?? <Character>[];

          if (characters.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore, size: 84, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No se encontraron personajes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 8),
                    Text('Favoritos: ${provider.favorites.length}'),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final c = characters[index];
                final isFav = provider.isFavorite(c.id.toString());

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(c.image),
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(c.name),
                    subtitle: Text(c.status),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(c.id.toString(), character: c);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isFav
                                ? 'Quitado de favoritos'
                                : 'Añadido a favoritos'),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}