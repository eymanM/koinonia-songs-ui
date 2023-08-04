import 'package:koinonia_songs/models/song_ent_part.dart';

class Song {
  const Song({
    required this.number,
    required this.parts,
  });

  final int number;
  final List<SongEntPart> parts;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(number: json['number'], parts: (json['parts'] as List<dynamic>).map((val) => SongEntPart.fromJson(val)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'parts': parts,
    };
  }
}
