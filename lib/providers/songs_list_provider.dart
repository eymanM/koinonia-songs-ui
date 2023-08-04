import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/models/song_basics.dart';
import 'package:localstorage/localstorage.dart';
import 'ApiService.dart';

class ListOfAllSongsNotifier extends StateNotifier<List<SongBasics>> {
  LocalStorage storage;
  Ref ref;

  ListOfAllSongsNotifier(this.storage, this.ref) : super([]);

  Future<List<SongBasics>> getAllSongs() async {
    if (state.isNotEmpty) return state;
    if (storage.getItem('songsList') == null) {
      var songsList =  await ref.read(apiProvider).getSongs();
      final encodedState = json.encode(songsList);
      storage.setItem('songsList', encodedState);
    }

    List<SongBasics> allSongsList = [];
    final songsList = json.decode(storage.getItem('songsList'));


    for (var song in songsList) {
      allSongsList.add(SongBasics.fromJson(song));
    }

    state = allSongsList;
    return state;
  }


  Future<List<SongBasics>> getFilteredSongs(String searchStr) async {
    if (state.isEmpty) {
      state = await getAllSongs();
    }

    List<SongBasics> filtered = [];
    for (SongBasics song in state) {
      if (song.title.toLowerCase().contains(searchStr)) {
        filtered.add(song);
      }
    }
    return filtered;
  }
}

final songsListProvider = FutureProvider<List<SongBasics>>((ref) async {
  LocalStorage storage = LocalStorage('songsList');
  await storage.ready;
  return await ListOfAllSongsNotifier(storage, ref).getAllSongs();
});
