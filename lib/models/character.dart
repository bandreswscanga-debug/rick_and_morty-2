class Character {
  final int id;
  final String name;
  final String status;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      status: json['status'] as String? ?? 'unknown',
      image: json['image'] as String? ?? '',
    );
  }
}
