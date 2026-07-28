import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/note.dart';
import '../../../../core/services/favorites_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Note note;

  const VideoPlayerScreen({super.key, required this.note});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  double _playbackSpeed = 1.0;
  double _currentPositionSeconds = 0.0;
  final double _totalDurationSeconds = 120.0;
  bool _isPlaying = true;
  Timer? _timer;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!_isPlaying) return;
      setState(() {
        _currentPositionSeconds += 0.5 * _playbackSpeed;
        if (_currentPositionSeconds >= _totalDurationSeconds) {
          _currentPositionSeconds = 0.0;
          _isPlaying = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(double seconds) {
    final int min = (seconds / 60).floor();
    final int sec = (seconds % 60).floor();
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(widget.note.id, 'video');

    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                _buildPlayerArea(),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() => _isFullscreen = false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
            onPressed: () {
              favProvider.toggleFavorite(widget.note.id, 'video');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player screen simulated
            _buildPlayerArea(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subject: ${widget.note.subject} | Class: ${widget.note.userClass}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  
                  // Playback settings card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Playback Speed', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [0.5, 1.0, 1.5, 2.0].map((speed) {
                              final bool isSelected = _playbackSpeed == speed;
                              return ChoiceChip(
                                label: Text('${speed}x'),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      _playbackSpeed = speed;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  const Text('Video Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text(
                    widget.note.description.isNotEmpty
                        ? widget.note.description
                        : 'No description available for this classroom video.',
                    style: const TextStyle(height: 1.4, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Graphic simulated background
          Opacity(
            opacity: 0.3,
            child: Icon(Icons.play_circle_fill, size: 80, color: Colors.grey[400]),
          ),
          
          // Controls overlays
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black.withOpacity(0.6),
              child: Column(
                children: [
                  // Progress Bar slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      activeColor: AppColors.secondaryOrange,
                      inactiveColor: Colors.grey,
                      value: _currentPositionSeconds,
                      min: 0.0,
                      max: _totalDurationSeconds,
                      onChanged: (val) {
                        setState(() {
                          _currentPositionSeconds = val;
                        });
                      },
                    ),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                            onPressed: () {
                              setState(() => _isPlaying = !_isPlaying);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_formatDuration(_currentPositionSeconds)} / ${_formatDuration(_totalDurationSeconds)}",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isFullscreen = !_isFullscreen;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
