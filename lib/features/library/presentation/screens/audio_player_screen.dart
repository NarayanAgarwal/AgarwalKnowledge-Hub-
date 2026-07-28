import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/media_resource.dart';
import '../../../../core/services/audio_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  final MediaResource resource;

  const AudioPlayerScreen({super.key, required this.resource});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _diskController;

  @override
  void initState() {
    super.initState();
    _diskController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    // Start playing audio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.playAudio(widget.resource.fileUrl, widget.resource.title);
      _diskController.repeat();
    });
  }

  @override
  void dispose() {
    _diskController.dispose();
    super.dispose();
  }

  String _formatDuration(double seconds) {
    final int min = (seconds / 60).floor();
    final int sec = (seconds % 60).floor();
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Control disk rotation animation based on playing state
    if (audioProvider.isPlaying) {
      if (!_diskController.isAnimating) _diskController.repeat();
    } else {
      if (_diskController.isAnimating) _diskController.stop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Lesson Player'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinning Disk Visualizer
              RotationTransition(
                turns: _diskController,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white, size: 60),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              Text(
                widget.resource.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Class: ${widget.resource.userClass} | Subject: ${widget.resource.subject}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              
              const SizedBox(height: 40),

              // Position Progress Slider
              Slider(
                value: audioProvider.positionSeconds,
                min: 0.0,
                max: audioProvider.durationSeconds,
                activeColor: AppColors.secondaryOrange,
                inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                onChanged: (val) {
                  audioProvider.seek(val);
                },
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(audioProvider.positionSeconds), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(_formatDuration(audioProvider.durationSeconds), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Playback controls row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.replay_10, color: AppColors.primaryBlue),
                    onPressed: () {
                      final target = audioProvider.positionSeconds - 10.0;
                      audioProvider.seek(target < 0 ? 0.0 : target);
                    },
                  ),
                  const SizedBox(width: 24),
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryBlue,
                    child: IconButton(
                      iconSize: 36,
                      color: Colors.white,
                      icon: Icon(audioProvider.isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (audioProvider.isPlaying) {
                          audioProvider.pauseAudio();
                        } else {
                          audioProvider.resumeAudio();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.forward_10, color: AppColors.primaryBlue),
                    onPressed: () {
                      final target = audioProvider.positionSeconds + 10.0;
                      audioProvider.seek(target > audioProvider.durationSeconds ? audioProvider.durationSeconds : target);
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 48),

              // Speed Chips
              const Text('Playback Speed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0.5, 1.0, 1.5, 2.0].map((speed) {
                  final isSelected = audioProvider.playbackSpeed == speed;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ChoiceChip(
                      label: Text('${speed}x'),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          audioProvider.setPlaybackSpeed(speed);
                        }
                      },
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
