import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:koinonia_songs/models/song.dart';
import 'package:koinonia_songs/models/song_ent.dart';

class ApiService {
  String endpoint = 'https://owoydanihd.execute-api.eu-west-1.amazonaws.com/dev';

  Future<List<Song>> getSongs() async {
    Response response = await get(Uri.parse('$endpoint/songsList?startIndex=1&endIndex=382'));

    final List result = jsonDecode(response.body);
    return result.map(((e) => Song.fromJson(e))).toList();
  }

  Future<List<SongEnt>> getSong(int songNumber) async {
    Response response = await get(Uri.parse('$endpoint/song?songNo=$songNumber'));

    final List result = jsonDecode(response.body);
    return result.map(((e) => SongEnt.fromJson(e))).toList();
  }
}

final apiProvider = Provider<ApiService>((ref) => ApiService());
