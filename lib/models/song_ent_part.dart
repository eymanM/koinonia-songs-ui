class SongEntPart {
  const SongEntPart({
    required this.number,
    required this.text,
    required this.copyr,
    required this.grip,
  });

  final int number;
  final String text;
  final int? copyr;
  final String? grip;

  factory SongEntPart.fromJson(Map<String, dynamic> json) {
    return SongEntPart(number: json['numer'], text: json['tekst'], copyr: json['copyr'], grip: json['chwyt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'numer': number,
      'tekst': text,
      'copyr': copyr,
      'chwyt': grip,
    };
  }
}
