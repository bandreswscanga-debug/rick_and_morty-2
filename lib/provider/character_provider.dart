import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider que gestiona la lista de favoritos (ids de personajes).
///
/// - Almacena internamente un [Set<String>] para garantizar unicidad.
/// - Expone un getter inmutable `favorites` y métodos de ayuda:
///   `isFavorite`, `addFavorite`, `removeFavorite`, `toggleFavorite`, `clearFavorites`.
class CharacterProvider extends ChangeNotifier {
  final Set<String> _favorites = <String>{};
  static const String _prefsKey = 'favorites_ids';

  CharacterProvider() {
    // Carga asíncrona en background; notificará listeners si hay datos.
    _loadFavorites();
  }

  /// Lista inmutable de ids de personajes marcados como favoritos.
  List<String> get favorites => List.unmodifiable(_favorites);

  /// Devuelve `true` si [id] está en favoritos.
  bool isFavorite(String id) => _favorites.contains(id);

  /// Añade [id] a favoritos. Notifica listeners solo si hubo cambio.
  void addFavorite(String id) {
    if (_favorites.add(id)) {
      _saveFavorites();
      notifyListeners();
    }
  }

  /// Elimina [id] de favoritos. Notifica listeners solo si hubo cambio.
  void removeFavorite(String id) {
    if (_favorites.remove(id)) {
      _saveFavorites();
      notifyListeners();
    }
  }

  /// Alterna el estado de favorito para [id].
  void toggleFavorite(String id) {
    if (isFavorite(id)) {
      removeFavorite(id);
    } else {
      addFavorite(id);
    }
  }

  /// Elimina todos los favoritos y notifica si la colección no estaba vacía.
  void clearFavorites() {
    if (_favorites.isNotEmpty) {
      _favorites.clear();
      _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey);
      if (list != null && list.isNotEmpty) {
        _favorites.addAll(list);
        // Notificar si se cargaron datos (solo si son diferentes del estado actual)
        notifyListeners();
      }
    } catch (_) {
      // Ignorar errores de lectura; no bloquear la UI.
      if (kDebugMode) {
        // ignore: avoid_print
        print('Warning: no se pudieron cargar favoritos desde SharedPreferences');
      }
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, _favorites.toList());
    } catch (_) {
      // Ignorar errores de escritura; opcionalmente loguear en debug.
      if (kDebugMode) {
        // ignore: avoid_print
        print('Warning: no se pudieron guardar favoritos en SharedPreferences');
      }
    }
  }
}