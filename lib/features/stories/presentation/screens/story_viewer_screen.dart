import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/story.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryViewerScreen({super.key, required this.stories});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin {
  int _currentStoryIndex = 0;
  late AnimationController _animController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    
    // Validate list is not empty
    if (widget.stories.isNotEmpty) {
      _showStory(widget.stories[_currentStoryIndex]);
    }
  }

  void _showStory(Story story) {
    _animController.stop();
    _animController.reset();
    
    // Story auto expire check: if story createdDate is > 24 hours ago, skip
    final bool isExpired = DateTime.now().difference(story.createdDate).inHours >= 24;
    if (isExpired) {
      _onStoryCompleted();
      return;
    }

    _animController.duration = Duration(seconds: story.durationSeconds);
    _animController.forward();

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onStoryCompleted();
      }
    });
  }

  void _onStoryCompleted() {
    if (_currentStoryIndex + 1 < widget.stories.length) {
      setState(() {
        _currentStoryIndex++;
      });
      _showStory(widget.stories[_currentStoryIndex]);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return const Scaffold(body: Center(child: Text('No active stories.')));
    }

    final story = widget.stories[_currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story Media image background
          Positioned.fill(
            child: Image.network(
              story.mediaUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white, size: 48),
                  ),
                );
              },
            ),
          ),
          
          // Gradients
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          // Tap zones
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStoryIndex > 0) {
                        setState(() {
                          _currentStoryIndex--;
                        });
                        _showStory(widget.stories[_currentStoryIndex]);
                      }
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _onStoryCompleted();
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          
          // Progress bars and header info
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                children: [
                  // Animating bars
                  Row(
                    children: List.generate(widget.stories.length, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: index == _currentStoryIndex
                              ? AnimatedBuilder(
                                  animation: _animController,
                                  builder: (context, child) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _animController.value,
                                      child: Container(
                                        color: AppColors.secondaryOrange,
                                      ),
                                    );
                                  },
                                )
                              : index < _currentStoryIndex
                                  ? Container(color: AppColors.secondaryOrange)
                                  : const SizedBox.shrink(),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Uploader info
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.uploaderName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              'Active Story',
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          
          // Story Text description at bottom
          Positioned(
            bottom: 48,
            left: 20,
            right: 20,
            child: Text(
              story.text,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
