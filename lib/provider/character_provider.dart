import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterProvider extends ChangeNotifier {
  final Set<String> _favorites = <String>{};
  static const String _prefsKey = 'favorites_ids';

  CharacterProvider() {
    _loadFavorites();
  }

  // 🔹 Getter (lista inmutable)
  List<String> get favorites => List.unmodifiable(_favorites);

  // 🔹 Verificar si es favorito
  bool isFavorite(String id) => _favorites.contains(id);

  // 🔹 Agregar favorito
  void addFavorite(String id) {
    if (_favorites.add(id)) {
      _saveFavorites();
      notifyListeners();
    }
  }

  // 🔹 Eliminar favorito
  void removeFavorite(String id) {
    if (_favorites.remove(id)) {
      _saveFavorites();
      notifyListeners();
    }
  }

  // 🔹 Alternar favorito
  void toggleFavorite(String id) {
    if (isFavorite(id)) {
      removeFavorite(id);
    } else {
      addFavorite(id);
    }
  }

  // 🔹 Limpiar favoritos
  void clearFavorites() {
    if (_favorites.isNotEmpty) {
      _favorites.clear();
      _saveFavorites();
      notifyListeners();
    }
  }

  // 🔹 Cargar desde almacenamiento
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey);

      if (list != null && list.isNotEmpty) {
        _favorites.addAll(list);
        notifyListeners();
      }
    } catch (_) {
      if (kDebugMode) {
        print('Warning: no se pudieron cargar favoritos');
      }
    }
  }

  // 🔹 Guardar en almacenamiento
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, _favorites.toList());
    } catch (_) {
      if (kDebugMode) {
        print('Warning: no se pudieron guardar favoritos');
      }
    }
  }
}