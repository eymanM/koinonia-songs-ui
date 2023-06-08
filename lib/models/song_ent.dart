class SongEnt {
  const SongEnt({
    required this.id,
    required this.number,
    required this.text,
    required this.copyr,
  });

  final int id;
  final int number;
  final String text;
  final int? copyr;

  factory SongEnt.fromJson(Map<String, dynamic> json) {
    return SongEnt(id: json['id'], number: json['numer'], text: json['tekst'], copyr: json['copyr']);
  }
}
