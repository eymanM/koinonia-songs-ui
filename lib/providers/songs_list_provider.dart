import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/models/song.dart';
import 'ApiService.dart';

class Ala extends StateNotifier<List<Song>> {
  Ref ref;

  Ala(this.ref) : super([]) {
    loadSongs();
  }

  Future<void> loadSongs() async {
    state = (await ref.read(apiProvider).getSongs());
  }

  Future<List<Song>> getSongs() async {
    return state;
  }

  Future<List<Song>> getFilteredSongs(String searchStr) async {
    List<Song> filtered = [];
    for (Song song in state) {
      if (song.title.toLowerCase().contains(searchStr)) {
        filtered.add(song);
      }
    }
    return filtered;
  }
}

final songsListProvider = FutureProvider<List<Song>>((ref) async {

  return ref.watch(apiProvider).getSongs();
});
