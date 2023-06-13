import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/models/song.dart';
import 'package:koinonia_songs/models/song_ent.dart';
import '../providers/favorites_provider.dart';
import '../providers/grip_is_enabled_provider.dart';

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
    final gripsEnables = ref.watch(gripEnabledProvider);
    final isEnableIOnThisSong = gripsEnables.contains(song.title);
    var switchState = isEnableIOnThisSong;
    var showGrips = false;

    return Scaffold(
        appBar: AppBar(title: Text(song.title), actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<Function>(
                  onTap: () {
                    final wasAdded = ref.watch(favoriteSongProvider.notifier).toggleSongFavoriteStatus(song);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(wasAdded ? 'Dodano do ulubionych' : 'Usunięto z ulubionych'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: const Text('Ulubione'),
                        ),
                      ),
                      Icon(isFavorite ? Icons.star : Icons.star_border),
                    ],
                  ),
                ),
                PopupMenuItem<Function>(child: StatefulBuilder(builder: (BuildContext context2, StateSetter setState) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: const Text('Chwyty gitarowe'),
                        ),
                      ),
                      Switch(
                        value: switchState,
                        onChanged: (val) {
                          var status = ref.watch(gripEnabledProvider.notifier).toogleGripStatus(song.title);
                          setState(() { switchState = status; });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }))
              ];
            },
          ),
        ]),
        body: FutureBuilder<List<SongEnt>>(
          future: songData,
          builder: (BuildContext context, AsyncSnapshot<List<SongEnt>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              final data = snapshot.data as List<SongEnt>;
              children = [
                ...data.map((e) {
                  showGrips = e.grip != null && isEnableIOnThisSong;
                  return ListView(shrinkWrap: true, physics: const ClampingScrollPhysics(), children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 5),
                      subtitle: RichText(
                        text: TextSpan(
                          text: e.text,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground, fontSize: e.copyr != null ? 16 : 21),
                          children: [
                            if (showGrips) ...[
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                ),
                              ),
                              TextSpan(
                                text: e.grip,
                                style: const TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(100, 120, 0, 0),
                                    ),
                                  ],
                                  wordSpacing: 4,
                                  color: Colors.black,
                                  fontSize: 23,
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    )
                  ]);
                }),
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
