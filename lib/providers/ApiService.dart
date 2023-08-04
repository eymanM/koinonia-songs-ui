import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:koinonia_songs/models/song_basics.dart';
import 'package:koinonia_songs/models/song_ent_part.dart';
import 'package:localstorage/localstorage.dart';

import '../models/song.dart';

class ApiService {
  String endpoint = 'https://owoydanihd.execute-api.eu-west-1.amazonaws.com/dev';
  List<Song> songsState = List.empty();


  Future<List<SongBasics>> getSongs() async {
    Response response = await get(Uri.parse('$endpoint/songsList?startIndex=1&endIndex=382'));

    final List result = jsonDecode(response.body);
    return result.map(((e) => SongBasics.fromJson(e))).toList();
  }

  Future<List<SongEntPart>> getSong(int songNumber) async {
    LocalStorage storage = LocalStorage('songs');

    var desiredSong = songsState.where((element) => element.number == songNumber).toList();
    if (desiredSong.isNotEmpty) {
      return desiredSong.first.parts;
    }

    await storage.ready;
    List<Song> songs = [];
    if (storage.getItem('songs') != null) {
      List<dynamic> songsJson = json.decode(storage.getItem('songs'));

      for (var song in songsJson) {
        songs.add(Song.fromJson(song));
      }
    }
    Response response = await get(Uri.parse('$endpoint/song?songNo=$songNumber'));

    final List result = jsonDecode(response.body);
    var song = Song(number: songNumber, parts: result.map(((e) => SongEntPart.fromJson(e))).toList());

    songsState = [...songs, song];
    final encodedState = json.encode(songsState);
    storage.setItem('songs', encodedState);
    return song.parts;

  }

  Future<void> setSongsState() async {}
}

final apiProvider = Provider<ApiService>((ref) => ApiService());
