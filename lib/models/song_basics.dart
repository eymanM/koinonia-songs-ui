class SongBasics {
  const SongBasics({
    required this.number,
    required this.title,
    required this.toSpirit,
  });

  final int number;
  final String title;
  final bool? toSpirit;

  factory SongBasics.fromJson(Map<String, dynamic> json) {
    return SongBasics(number: json['numer'], title: json['tytul'], toSpirit: json['doDucha']);
  }

  Map<String, dynamic> toJson() => {
    'numer': number,
    'tytul': title,
    'doDucha': toSpirit,
  };
}
