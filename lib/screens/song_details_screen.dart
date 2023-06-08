import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/models/song.dart';
import 'package:koinonia_songs/models/song_ent.dart';
import '../providers/ApiService.dart';
import '../providers/favorites_provider.dart';

class SongDetailsScreen extends ConsumerWidget {
  const SongDetailsScreen({
    super.key,
    required this.song,
    required this.songData,
  });

  final Future<List<SongEnt>> songData;

  final Song song;

  @override
  Widget build(BuildContext context, ref) {
    final favoriteSong = ref.watch(favoriteSongProvider);

    final isFavorite = favoriteSong.contains(song);

    return Scaffold(
        appBar: AppBar(title: Text(song.title), actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref.watch(favoriteSongProvider.notifier).toggleSongFavoriteStatus(song);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(wasAdded ? 'Dodano do ulubionych' : 'Usunięto z ulubionych'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          )
        ]),
        body: FutureBuilder<List<SongEnt>>(
          future: songData,
          builder: (BuildContext context, AsyncSnapshot<List<SongEnt>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              final data = snapshot.data as List<SongEnt>;
              children = [
                ...data.map((e) => ListView(shrinkWrap: true, physics: const ClampingScrollPhysics(), children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(3),
                        title: Text(
                          e.text,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 21
                              ),
                        ),
                      ), const SizedBox(height: 1,)
                    ])),
              ];
            } else {
              children = const <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ];
            }
            return SingleChildScrollView(
              child: Column(
                children: children,
              ),
            );
          },
        ));
  }
}
