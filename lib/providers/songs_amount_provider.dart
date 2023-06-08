import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
//
// final songsAmountProvider = Provider((ref) async {
//   final response = await http.get(Uri.parse('https://owoydanihd.execute-api.eu-west-1.amazonaws.com/dev/songsAmount'));
//   return jsonDecode(response.body)['max'];
// });
