import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/models/song_basics.dart';
import 'package:koinonia_songs/models/song_ent_part.dart';
import 'package:localstorage/localstorage.dart';
import '../models/song.dart';
import 'ApiService.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  LocalStorage storage;
  Ref ref;

  SongsNotifier(this.storage, this.ref) : super([{}] as List<Song>);

  Future<Song> getSong(int songNo) async {
    var desiredElement = state.where((element) => element.number == songNo).toList();
    if (desiredElement.isNotEmpty) {
      return desiredElement[0];
    }

    await storage.ready;
    List<Song> songs = [];
    if (storage.getItem('songs') != null) {
      final songsJson = json.decode(storage.getItem('songs'));
      for (var song in songsJson) {
        songs.add(Song.fromJson(song));
      }
    }
    var songParts = await ref.read(apiProvider).getSong(songNo);
    var song = Song(number: songNo, parts: songParts);
    state = [...songs, song];
    final encodedState = json.encode(state);
    storage.setItem('songs', encodedState);
    return song;
  }
}

final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>((ref) {
  LocalStorage storage = LocalStorage('songs');
  return SongsNotifier(storage, ref);
});
