import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

class GripEnabledNotifier extends StateNotifier<List<String>> {
  LocalStorage storage;

  GripEnabledNotifier(this.storage) : super([]) {
    loadEnabledGroups(storage);
  }

  Future<void> loadEnabledGroups(LocalStorage storage) async {
    List<String> grips = [];
    await storage.ready;
    if (storage.getItem('enabledGrips') != null) {
      final gripsTitles = json.decode(storage.getItem('enabledGrips'));
      for (var title in gripsTitles) {
        grips.add(title);
      }
    }
    state = grips;
  }

  bool toogleGripStatus(String songTitle) {
    final gripIsEnabled = state.contains(songTitle);

    if (gripIsEnabled) {
      state = state.where((s) => s != songTitle).toList();
      final encodedState = json.encode(state);
      storage.setItem('enabledGrips', encodedState);
      return false;
    } else {
      state = [...state, songTitle];
      final encodedState = json.encode(state);
      storage.setItem('enabledGrips', encodedState);
      return true;
    }
  }
}

final gripEnabledProvider = StateNotifierProvider<GripEnabledNotifier, List<String>>((ref) {
  LocalStorage storage = LocalStorage('enabledGrips');

  return GripEnabledNotifier(storage);
});
