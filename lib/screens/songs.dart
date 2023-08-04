import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koinonia_songs/providers/songs_list_provider.dart';
import 'package:koinonia_songs/providers/songs_provider.dart';
import 'package:koinonia_songs/screens/song_details_screen.dart';
import '../models/song_basics.dart';
import '../providers/ApiService.dart';
import '../widgets/GradientText.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({
    super.key,
  });

  @override
  SongScreenStateState createState() => SongScreenStateState();
}

class SongScreenStateState extends ConsumerState<SongsScreen> {
  TextEditingController editingController = TextEditingController();
  var items = <SongBasics>[];
  var allData = <SongBasics>[];
  var searchPhrase = '';
  final apiservice = ApiService();

  void filterSearchResults(String phrase) {
    var parsedNumberOrNull = int.tryParse(phrase);

    if (parsedNumberOrNull != null && parsedNumberOrNull > 0 && parsedNumberOrNull <= allData.length) {
      setState(() {
        items = [allData.elementAt(parsedNumberOrNull - 1)];
      });
      return;
    }

    if (phrase.characters.length < 3) {
      setState(() {
        items = allData;
      });
      return;
    }
    setState(() {
      searchPhrase = phrase;
      items = allData.where((item) => item.title.toLowerCase().contains(phrase.toLowerCase())).toList();
    });
  }

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
    final data = ref.watch(songsListProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return data.when(
          data: (data) {
            if (items.isEmpty) items = data;
            allData = data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: const InputDecoration(
                        labelText: "Szukaj",
                        hintText: "Szukaj po numerze lub tytule",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                SizedBox(
                  height: constraints.biggest.height - 80,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    itemCount: items.length,
                    prototypeItem: const ListTile(
                      title: Text('Ładowanie...'),
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: const EdgeInsets.all(3),
                          onTap: () => _selectSong(context, items[index]),
                          title: items[index].toSpirit != true
                              ? Text(
                                  '${items[index].number}. ${items[index].title}',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )
                              : Row(
                                  children: [
                                    Text(
                                      '${items[index].number}.',
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                    const ImageIcon(
                                      AssetImage("assets/dove2.png"),
                                      size: 32,
                                    ),
                                    Flexible(
                                      child: Text(
                                        items[index].title,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ));
                      // GradientText(
                      //         '${items[index].number}. ${items[index].title}',
                      //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      //         gradient: LinearGradient(colors: [
                      //           Colors.blueAccent.withOpacity(0.9),
                      //           Colors.blue.withOpacity(0.1),
                      //         ]),
                      //       ));
                    },
                  ),
                ),
              ],
            );
          },
          error: (err, s) => Text(err.toString()),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
