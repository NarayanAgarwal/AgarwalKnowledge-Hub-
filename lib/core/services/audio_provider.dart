import 'dart:async';
import 'package:flutter/material.dart';

class AudioProvider with ChangeNotifier {
  String? _currentAudioUrl;
  String _title = '';
  bool _isPlaying = false;
  double _positionSeconds = 0.0;
  double _durationSeconds = 300.0; // Mock 5 mins
  double _playbackSpeed = 1.0;
  Timer? _timer;

  String? get currentAudioUrl => _currentAudioUrl;
  String get title => _title;
  bool get isPlaying => _isPlaying;
  double get positionSeconds => _positionSeconds;
  double get durationSeconds => _durationSeconds;
  double get playbackSpeed => _playbackSpeed;

  void playAudio(String url, String titleText, {double duration = 300.0}) {
    if (_currentAudioUrl == url) {
      resumeAudio();
      return;
    }

    _currentAudioUrl = url;
    _title = titleText;
    _durationSeconds = duration;
    _positionSeconds = 0.0;
    _isPlaying = true;
    notifyListeners();

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!_isPlaying) return;
      _positionSeconds += 0.5 * _playbackSpeed;
      if (_positionSeconds >= _durationSeconds) {
        _positionSeconds = 0.0;
        _isPlaying = false;
        t.cancel();
      }
      notifyListeners();
    });
  }

  void pauseAudio() {
    _isPlaying = false;
    notifyListeners();
  }

  void resumeAudio() {
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }

  void seek(double position) {
    _positionSeconds = position;
    notifyListeners();
  }

  void stopAudio() {
    _isPlaying = false;
    _timer?.cancel();
    _currentAudioUrl = null;
    _positionSeconds = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
