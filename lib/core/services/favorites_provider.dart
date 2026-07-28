import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _favNotesKey = "fav_notes";
  static const String _favPdfsKey = "fav_pdfs";
  static const String _favVideosKey = "fav_videos";
  static const String _favHomeworkKey = "fav_homework";

  List<String> _favoriteNotes = [];
  List<String> _favoritePdfs = [];
  List<String> _favoriteVideos = [];
  List<String> _favoriteHomeworks = [];

  List<String> get favoriteNotes => _favoriteNotes;
  List<String> get favoritePdfs => _favoritePdfs;
  List<String> get favoriteVideos => _favoriteVideos;
  List<String> get favoriteHomeworks => _favoriteHomeworks;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteNotes = prefs.getStringList(_favNotesKey) ?? [];
    _favoritePdfs = prefs.getStringList(_favPdfsKey) ?? [];
    _favoriteVideos = prefs.getStringList(_favVideosKey) ?? [];
    _favoriteHomeworks = prefs.getStringList(_favHomeworkKey) ?? [];
    notifyListeners();
  }

  bool isFavorite(String id, String mediaType) {
    switch (mediaType) {
      case 'note':
        return _favoriteNotes.contains(id);
      case 'pdf':
        return _favoritePdfs.contains(id);
      case 'video':
        return _favoriteVideos.contains(id);
      case 'homework':
        return _favoriteHomeworks.contains(id);
      default:
        return false;
    }
  }

  Future<void> toggleFavorite(String id, String mediaType) async {
    final prefs = await SharedPreferences.getInstance();
    switch (mediaType) {
      case 'note':
        if (_favoriteNotes.contains(id)) {
          _favoriteNotes.remove(id);
        } else {
          _favoriteNotes.add(id);
        }
        await prefs.setStringList(_favNotesKey, _favoriteNotes);
        break;
      case 'pdf':
        if (_favoritePdfs.contains(id)) {
          _favoritePdfs.remove(id);
        } else {
          _favoritePdfs.add(id);
        }
        await prefs.setStringList(_favPdfsKey, _favoritePdfs);
        break;
      case 'video':
        if (_favoriteVideos.contains(id)) {
          _favoriteVideos.remove(id);
        } else {
          _favoriteVideos.add(id);
        }
        await prefs.setStringList(_favVideosKey, _favoriteVideos);
        break;
      case 'homework':
        if (_favoriteHomeworks.contains(id)) {
          _favoriteHomeworks.remove(id);
        } else {
          _favoriteHomeworks.add(id);
        }
        await prefs.setStringList(_favHomeworkKey, _favoriteHomeworks);
        break;
    }
    notifyListeners();
  }
}
