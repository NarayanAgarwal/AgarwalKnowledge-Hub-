import 'dart:async';
import 'package:flutter/material.dart';

class DownloadItem {
  final String id;
  final String title;
  final String fileUrl;
  final String mediaType; // 'pdf' | 'video' | 'homework' | 'note'
  double progress; // 0.0 to 1.0
  String status; // 'downloading' | 'paused' | 'completed'
  String localPath;

  DownloadItem({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.mediaType,
    this.progress = 0.0,
    this.status = 'downloading',
    this.localPath = '',
  });
}

class DownloadProvider with ChangeNotifier {
  final List<DownloadItem> _items = [];
  final Map<String, Timer> _timers = {};

  List<DownloadItem> get items => _items;
  List<DownloadItem> get completedItems => _items.where((i) => i.status == 'completed').toList();
  List<DownloadItem> get activeItems => _items.where((i) => i.status == 'downloading').toList();

  bool isDownloaded(String fileUrl) {
    return _items.any((i) => i.fileUrl == fileUrl && i.status == 'completed');
  }

  void startDownload(String id, String title, String url, String mediaType) {
    // Check if already downloading or completed
    if (_items.any((i) => i.fileUrl == url)) return;

    final newItem = DownloadItem(
      id: id,
      title: title,
      fileUrl: url,
      mediaType: mediaType,
      progress: 0.0,
      status: 'downloading',
    );

    _items.add(newItem);
    notifyListeners();
    _simulateProgress(newItem);
  }

  void pauseDownload(String url) {
    final index = _items.indexWhere((i) => i.fileUrl == url);
    if (index != -1 && _items[index].status == 'downloading') {
      _items[index].status = 'paused';
      _timers[url]?.cancel();
      _timers.remove(url);
      notifyListeners();
    }
  }

  void resumeDownload(String url) {
    final index = _items.indexWhere((i) => i.fileUrl == url);
    if (index != -1 && _items[index].status == 'paused') {
      _items[index].status = 'downloading';
      notifyListeners();
      _simulateProgress(_items[index]);
    }
  }

  void deleteDownload(String url) {
    _timers[url]?.cancel();
    _timers.remove(url);
    _items.removeWhere((i) => i.fileUrl == url);
    notifyListeners();
  }

  void _simulateProgress(DownloadItem item) {
    _timers[item.fileUrl]?.cancel();
    
    final timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (item.status != 'downloading') {
        t.cancel();
        return;
      }

      item.progress += 0.1;
      if (item.progress >= 1.0) {
        item.progress = 1.0;
        item.status = 'completed';
        item.localPath = 'mock_local_path/${item.title}';
        t.cancel();
        _timers.remove(item.fileUrl);
      }
      notifyListeners();
    });

    _timers[item.fileUrl] = timer;
  }

  @override
  void dispose() {
    for (var t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
