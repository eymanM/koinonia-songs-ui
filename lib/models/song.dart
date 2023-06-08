class Song {
  const Song({
    required this.number,
    required this.title,
    required this.toSpirit,
  });

  final int number;
  final String title;
  final bool? toSpirit;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(number: json['numer'], title: json['tytul'], toSpirit: json['doDucha']);
  }

  Map<String, dynamic> toJson() => {
    'numer': number,
    'tytul': title,
    'doDucha': toSpirit,
  };
}
