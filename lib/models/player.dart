class Player {
  final String name;
  final String position;
  int id;
  final String conference;
  final String picture;

  Player(
      {required this.name,
      required this.position,
      required this.id,
      required this.conference,
      required this.picture});

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Player && other.name == name && other.id == id;
  }
}
