# Rick and Morty App 🚀

Una aplicación móvil desarrollada en **Flutter** que permite explorar personajes de la serie **Rick and Morty** usando la API oficial de la serie.

## 🌟 Características

- **Exploración de Personajes**: Visualiza un listado completo de todos los personajes de la serie
- **Filtrado por Estado**: Filtra personajes según su estado (Alive, Dead, Unknown)
- **Sistema de Favoritos**: Guarda tus personajes favoritos localmente
- **Persistencia de Datos**: Los favoritos se almacenan en el dispositivo para acceso rápido
- **Interfaz Material Design 3**: Diseño moderno y responsivo


## 📱 Pantallas

### Home Screen
Pantalla de inicio que muestra un bienvenido al usuario y acceso navegación principal.

### Explore Screen
- Visualiza el listado de personajes
- Filtra por estado (Alive, Dead, Unknown)
- Muestra imagen, nombre y estado de cada personaje
- Opción para agregar/remover favoritos

### Favorites Screen
- Accede a tus personajes favoritos guardados
- Visita rápidamente tus personajes preferidos
- Opción para remover favoritos

## 🛠️ Tecnologías Utilizadas

### Framework
- **Flutter**: SDK para desarrollo multiplataforma
- **Dart**: Lenguaje de programación

### Dependencias Principales
- **provider** (^6.0.5): Gestión del estado reactiva
- **http** (^0.13.6): Cliente HTTP para llamadas a API
- **shared_preferences** (^2.0.15): Almacenamiento local persistente
- **cupertino_icons** (^1.0.8): Iconografía iOS

### DevDependencies
- **flutter_lints** (^6.0.0): Análisis de código y linting



## 🚀 Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/rick_and_morty.git
cd rick_and_morty-2
```

### 2. Obtener dependencias
```bash
flutter pub get
```

### 3. Ejecutar la aplicación



**En Web:**
```bash
flutter run -d chrome
```

**En Windows:**
```bash
flutter run -d windows
```



**En Linux:**
```bash
flutter run -d linux
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Entrada principal de la aplicación
├── models/
│   └── character.dart        # Modelo de datos del Personaje
├── services/
│   └── api_service.dart      # Servicio para comunicación con API
├── provider/
│   └── character_provider.dart   # Gestor de estado con Provider
└── screens/
    ├── home_screen.dart      # Pantalla de inicio
    ├── explore_screen.dart   # Pantalla de exploración
    └── favorites_screen.dart # Pantalla de favoritos

assets/                        # Recursos estáticos (si existen)
android/                       # Configuración Android
ios/                          # Configuración iOS
web/                          # Configuración Web
windows/                      # Configuración Windows
macos/                        # Configuración macOS
linux/                        # Configuración Linux
```

## 🔌 API

La aplicación utiliza la **Rick and Morty API** gratuita y sin autenticación:

**Endpoint Base:** `https://rickandmortyapi.com/api/character`

### Endpoints Utilizados
- `GET /character` - Obtiene el listado de todos los personajes

**Respuesta de Ejemplo:**
```json
{
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "status": "Alive",
      "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    }
  ]
}
```

## 💾 Almacenamiento Local

Los favoritos se guardan localmente usando `shared_preferences`:

- **Clave de IDs**: `favorites_ids` (Set de strings con IDs)
- **Clave de Datos**: `favorites_data` (JSON con nombre, imagen y estado)



## 🐛 Manejo de Errores

- **Error de conexión**: Muestra un mensaje de error si no se puede conectar a la API
- **Datos vacíos**: Maneja correctamente cuando no hay personajes disponibles
- **Persistencia fallida**: Los favoritos se mantienen en memoria si falla el almacenamiento local

## 🔄 Flujo de Datos

```
API → ApiService → CharacterProvider → UI Screens
                       ↓
                SharedPreferences (persistencia)
```

## 📝 Ejemplo de Uso

### Agregar un favorito
```dart
final provider = Provider.of<CharacterProvider>(context, listen: false);
provider.addFavorite(characterId, character: characterObject);
```

### Verificar si es favorito
```dart
bool isFav = provider.isFavorite(characterId);
```

### Remover un favorito
```dart
provider.removeFavorite(characterId);
```

## 🚧 Limitaciones y Mejoras Futuras

### Limitaciones Actuales

- No hay búsqueda por nombre
- No hay filtros avanzados (origen, especie, etc.)

### Mejoras Posibles
- Implementar paginación infinita (infinite scroll)
- Agregar búsqueda y filtros avanzados
- Mostrar más detalles del personaje (ubicación, especie, etc.)
- Agregar animaciones y transiciones
- Agregar modo oscuro
- Pruebas unitarias y de integración


