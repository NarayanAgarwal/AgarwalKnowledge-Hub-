import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/media_resource.dart';

class PdfViewerScreen extends StatefulWidget {
  final MediaResource resource;

  const PdfViewerScreen({super.key, required this.resource});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  double _zoomLevel = 1.0;
  bool _isDarkReadingMode = false;
  bool _isBookmarked = false;
  final _searchController = TextEditingController();
  int _simulatedMatchCount = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String val) {
    setState(() {
      _simulatedMatchCount = val.trim().isEmpty ? 0 : 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    
    // Determine active background and text colors based on dark reading mode toggled
    final Color readerBg = _isDarkReadingMode 
        ? Colors.black 
        : (isDarkTheme ? AppColors.darkBackground : Colors.grey[200]!);
        
    final Color pageBg = _isDarkReadingMode 
        ? AppColors.darkSurface 
        : Colors.white;
        
    final Color textColor = _isDarkReadingMode 
        ? Colors.white70 
        : (isDarkTheme ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Scaffold(
      backgroundColor: readerBg,
      appBar: AppBar(
        title: Text(widget.resource.title),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: _isBookmarked ? AppColors.secondaryOrange : null),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
          ),
          IconButton(
            icon: Icon(_isDarkReadingMode ? Icons.light_mode : Icons.dark_mode_outlined),
            tooltip: 'Dark Reading Mode',
            onPressed: () {
              setState(() {
                _isDarkReadingMode = !_isDarkReadingMode;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting to cloud printer...')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Simulated Search Bar inside PDF
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDarkTheme ? AppColors.darkSurface : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search inside document...',
                      prefixIcon: Icon(Icons.search, size: 18),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                if (_simulatedMatchCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      '$_simulatedMatchCount matches found',
                      style: const TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel < 2.0) _zoomLevel += 0.2;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel > 0.6) _zoomLevel -= 0.2;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // PDF Canvas area
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Transform.scale(
                    scale: _zoomLevel,
                    child: Card(
                      color: pageBg,
                      elevation: 4,
                      child: Container(
                        width: 450,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                widget.resource.title.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: textColor,
                                  letterSpacing: 1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Subject: ${widget.resource.subject} | ${widget.resource.chapter}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(height: 32),
                            
                            // Text Paragraphs simulated
                            _buildPdfParagraph('1. Introduction to Topic', true, textColor),
                            _buildPdfParagraph(
                              'This document covers essential notes on ${widget.resource.topic}. Review key figures, formulas, and worksheets appended at the end of this chapter. Pay special attention to solved examples before solving the homework exercises.',
                              false,
                              textColor,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            _buildPdfParagraph('2. Subsections and Rules', true, textColor),
                            _buildPdfParagraph(
                              'Keep values aligned, utilize cross ratios where necessary, and verify equations are balanced. All practice worksheets should be submitted via student portal homework uploader page.',
                              false,
                              textColor,
                            ),
                            
                            const SizedBox(height: 80),
                            
                            Center(
                              child: Text(
                                'Page 1 of 5 • Agarwal Knowledge Hub',
                                style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPdfParagraph(String text, bool isHeader, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          height: 1.5,
          color: color,
        ),
      ),
    );
  }
}
