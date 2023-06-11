class SongEnt {
  const SongEnt({
    required this.number,
    required this.text,
    required this.copyr,
    required this.grip,
  });

  final int number;
  final String text;
  final int? copyr;
  final String? grip;

  factory SongEnt.fromJson(Map<String, dynamic> json) {
    return SongEnt(number: json['numer'], text: json['tekst'], copyr: json['copyr'], grip: json['chwyt']);
  }
}
