import 'dart:async';

import '../models/character.dart';

/// Servicio mínimo que devuelve una lista vacía de personajes.
/// Puedes reemplazar la implementación para hacer llamadas HTTP reales.
class ApiService {
  Future<List<Character>> fetchCharacters() async {
    // Implementación mínima: retornar lista vacía para no romper la UI.
    return Future.value(<Character>[]);
  }
}
