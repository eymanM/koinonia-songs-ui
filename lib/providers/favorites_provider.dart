import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import '../models/song.dart';


class FavoriteSongNotifier extends StateNotifier<List<Song>> {
  LocalStorage storage;

  FavoriteSongNotifier(this.storage) : super([]) {
    getFavSongs(storage);
  }

  Future<void> getFavSongs(LocalStorage storage) async {
    List<Song> favorites = [];
    await storage.ready;
    if (storage.getItem('favorites') != null) {
      final favoriteJson = json.decode(storage.getItem('favorites'));
      for (var age in favoriteJson) {
        favorites.add(Song.fromJson(age));
      }
    }
    state = favorites;
  }

  bool toggleSongFavoriteStatus(Song song) {
    final songIsFavorite = state.contains(song);

    if (songIsFavorite) {
      state = state.where((s) => s.number != song.number).toList();
      final encodedState = json.encode(state);
      storage.setItem('favorites', encodedState);
      return false;
    } else {
      state = [...state, song];
      final encodedState = json.encode(state);
      storage.setItem('favorites', encodedState);
      return true;
    }
  }
}

final favoriteSongProvider = StateNotifierProvider<FavoriteSongNotifier, List<Song>>((ref) {
  LocalStorage storage = LocalStorage('favorites');

  return FavoriteSongNotifier(storage);
});
