import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';

class CharacterProvider extends ChangeNotifier {
  final Set<String> _favorites = <String>{};
  final Map<String, Map<String, String>> _favoritesData = {};
  static const String _prefsKey = 'favorites_ids';
  static const String _prefsDataKey = 'favorites_data';

  CharacterProvider() {
    _loadFavorites();
  }

  // 🔹 Getter (lista inmutable)
  List<String> get favorites => List.unmodifiable(_favorites);

  /// Devuelve los datos guardados (name, image, status) para un favorito si existen.
  Map<String, String>? favoriteData(String id) => _favoritesData[id];

  // 🔹 Verificar si es favorito
  bool isFavorite(String id) => _favorites.contains(id);

  // 🔹 Agregar favorito
  /// Añade un favorito. Si [character] se proporciona, guarda un resumen para
  /// mostrar nombre/imagen/localmente sin llamar a la API.
  void addFavorite(String id, {Character? character}) {
    if (_favorites.add(id)) {
      if (character != null) {
        _favoritesData[id] = {
          'name': character.name,
          'image': character.image,
          'status': character.status,
        };
      }
      _saveFavorites();
      notifyListeners();
    }
  }

  // 🔹 Eliminar favorito
  void removeFavorite(String id) {
    if (_favorites.remove(id)) {
      _favoritesData.remove(id);
      _saveFavorites();
      notifyListeners();
    }
  }

  // 🔹 Alternar favorito
  /// Alterna favorito; acepta opcionalmente [character] para guardar el resumen
  /// cuando se añade.
  void toggleFavorite(String id, {Character? character}) {
    if (isFavorite(id)) {
      removeFavorite(id);
    } else {
      addFavorite(id, character: character);
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
      }

      final dataStr = prefs.getString(_prefsDataKey);
      if (dataStr != null && dataStr.isNotEmpty) {
        final Map<String, dynamic> decoded = json.decode(dataStr) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          if (value is Map) {
            _favoritesData[key] = value.map((k, v) => MapEntry(k as String, v as String));
          }
        });
      }

      if (_favorites.isNotEmpty) notifyListeners();
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
      await prefs.setString(_prefsDataKey, json.encode(_favoritesData));
    } catch (_) {
      if (kDebugMode) {
        print('Warning: no se pudieron guardar favoritos');
      }
    }
  }
}