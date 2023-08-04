import 'package:flutter/material.dart';
import 'package:koinonia_songs/screens/song_details_screen.dart';
import '../models/song_basics.dart';
import '../providers/ApiService.dart';

class FavoriteSongsScreen extends StatelessWidget {
  FavoriteSongsScreen({
    super.key,
    required this.songsList,
  });

  final apiservice = ApiService();
  final List<SongBasics> songsList;

  void _selectSong(BuildContext context, SongBasics song) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SongDetailsScreen(
          song: song,
          songData: apiservice.getSong(song.number),
        ),
      ),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...songsList.map((song) => ListView(shrinkWrap: true, children: [
                ListTile(
                  onTap: () => _selectSong(context, song),
                  title: Text(
                    '${song.number}.  ${song.title}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
