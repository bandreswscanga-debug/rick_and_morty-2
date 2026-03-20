import 'package:flutter/material.dart';

import 'explore_screen.dart';
import 'favorites_screen.dart';

/// Home con navegación inferior entre Explore y Favorites.
///
/// Mejoras aplicadas:
/// - Usa IndexedStack para preservar el estado de cada pantalla al cambiar pestaña.
/// - Añade keys a las páginas para ayudar al framework a mantener el estado.
/// - Mejora visual del BottomNavigationBar con colores del tema.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      ExploreScreen(key: ValueKey('explore')),
      FavoritesScreen(key: ValueKey('favorites')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // IndexedStack mantiene el estado de las pantallas no visibles.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
  selectedItemColor: theme.colorScheme.primary,
  // Avoid using withOpacity (deprecated); use withAlpha for consistent behavior.
  unselectedItemColor: theme.colorScheme.onSurface.withAlpha(153),
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}