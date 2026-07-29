import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';

class StudyPlayScreen extends StatefulWidget {
  const StudyPlayScreen({super.key});

  @override
  State<StudyPlayScreen> createState() => _StudyPlayScreenState();
}

class _StudyPlayScreenState extends State<StudyPlayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeRhymeIndex = 0;
  bool _isPlayingRhyme = false;
  int _countingStars = 0;

  final List<Map<String, String>> _rhymes = [
    {
      "title": "Twinkle Twinkle Little Star",
      "lyrics": "Twinkle, twinkle, little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky.",
      "emoji": "🌟"
    },
    {
      "title": "Johny Johny Yes Papa",
      "lyrics": "Johny, Johny, Yes, Papa?\nEating sugar? No, Papa.\nTelling lies? No, Papa.\nOpen your mouth, Ha! Ha! Ha!",
      "emoji": "👶"
    },
    {
      "title": "Humpty Dumpty",
      "lyrics": "Humpty Dumpty sat on a wall,\nHumpty Dumpty had a great fall;\nAll the king's horses and all the king's men\nCouldn't put Humpty together again.",
      "emoji": "🥚"
    }
  ];

  final List<Map<String, String>> _alphabets = [
    {"letter": "A", "word": "Apple", "emoji": "🍎", "color": "0xFFE57373"},
    {"letter": "B", "word": "Ball", "emoji": "⚽", "color": "0xFF64B5F6"},
    {"letter": "C", "word": "Cat", "emoji": "🐱", "color": "0xFFFFB74D"},
    {"letter": "D", "word": "Dog", "emoji": "🐶", "color": "0xFF81C784"},
    {"letter": "E", "word": "Elephant", "emoji": "🐘", "color": "0xFFBA68C8"},
    {"letter": "F", "word": "Fish", "emoji": "🐟", "color": "0xFF4DD0E1"},
    {"letter": "G", "word": "Grapes", "emoji": "🍇", "color": "0xFFD4E157"},
    {"letter": "H", "word": "Horse", "emoji": "🐴", "color": "0xFFA1887F"},
    {"letter": "I", "word": "Ice Cream", "emoji": "🍦", "color": "0xFFF06292"},
    {"letter": "J", "word": "Joker", "emoji": "🤡", "color": "0xFFFFD54F"},
    {"letter": "K", "word": "Kite", "emoji": "🪁", "color": "0xFF4DB6AC"},
    {"letter": "L", "word": "Lion", "emoji": "🦁", "color": "0xFFFF8A65"},
  ];

  final List<Map<String, String>> _swar = [
    {"letter": "अ", "word": "अनार", "emoji": "🍎"},
    {"letter": "आ", "word": "आम", "emoji": "🥭"},
    {"letter": "इ", "word": "इमली", "emoji": "🫒"},
    {"letter": "ई", "word": "ईख", "emoji": "🎋"},
    {"letter": "उ", "word": "उल्लू", "emoji": "🦉"},
    {"letter": "ऊ", "word": "ऊन", "emoji": "🧶"},
    {"letter": "ऋ", "word": "ऋषि", "emoji": "🧘"},
    {"letter": "ए", "word": "एड़ी", "emoji": "🦶"},
    {"letter": "ऐ", "word": "ऐनक", "emoji": "👓"},
    {"letter": "ओ", "word": "ओखली", "emoji": "🥣"},
    {"letter": "औ", "word": "औरत", "emoji": "👩"},
    {"letter": "अं", "word": "अंगूर", "emoji": "🍇"},
  ];

  final List<Map<String, String>> _vyanjan = [
    {"letter": "क", "word": "कबूतर", "emoji": "🕊️"},
    {"letter": "ख", "word": "खरगोश", "emoji": "🐇"},
    {"letter": "ग", "word": "गमला", "emoji": "🪴"},
    {"letter": "घ", "word": "घर", "emoji": "🏠"},
    {"letter": "च", "word": "चम्मच", "emoji": "🥄"},
    {"letter": "छ", "word": "छाता", "emoji": "⛱️"},
    {"letter": "ज", "word": "जहाज", "emoji": "🚢"},
    {"letter": "झ", "word": "झंडा", "emoji": "🇮🇳"},
    {"letter": "ट", "word": "टमाटर", "emoji": "🍅"},
    {"letter": "ठ", "word": "ठठेरा", "emoji": "🔨"},
    {"letter": "ड", "word": "डमरू", "emoji": "🥁"},
    {"letter": "ढ", "word": "ढक्कन", "emoji": "🪘"},
  ];

  final List<Map<String, String>> _easyWords = [
    {"word": "CAT", "emoji": "🐱", "sentence": "The cat is sleeping."},
    {"word": "DOG", "emoji": "🐶", "sentence": "The dog barks loud."},
    {"word": "SUN", "emoji": "☀️", "sentence": "The sun is hot."},
    {"word": "TOY", "emoji": "🧸", "sentence": "I love my teddy bear."},
    {"word": "BOY", "emoji": "👦", "sentence": "He is a good boy."},
    {"word": "GIRL", "emoji": "👧", "sentence": "She is a sweet girl."},
    {"word": "BOOK", "emoji": "📖", "sentence": "Read your school book."},
    {"word": "TREE", "emoji": "🌳", "sentence": "Trees give us clean air."},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCardDialog(String title, String subtitle, String emoji) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Great!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study with Play 🎈', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Rhymes 🎵', icon: Icon(Icons.music_note)),
            Tab(text: 'Numbers 🔟', icon: Icon(Icons.pin)),
            Tab(text: 'A B C D 🔠', icon: Icon(Icons.abc)),
            Tab(text: 'Varnmala ✍️', icon: Icon(Icons.font_download_outlined)),
            Tab(text: 'Easy Words 🐱', icon: Icon(Icons.child_care)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // RHYMES TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_rhymes.length, (index) {
                    return ChoiceChip(
                      label: Text(_rhymes[index]["title"]!.split(" ")[0]),
                      selected: _activeRhymeIndex == index,
                      onSelected: (val) {
                        setState(() {
                          _activeRhymeIndex = index;
                          _isPlayingRhyme = false;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                GlassContainer(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Text(
                        _rhymes[_activeRhymeIndex]["emoji"]!,
                        style: const TextStyle(fontSize: 60),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _rhymes[_activeRhymeIndex]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _rhymes[_activeRhymeIndex]["lyrics"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPlayingRhyme ? Colors.red : AppColors.accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            icon: Icon(_isPlayingRhyme ? Icons.stop : Icons.play_arrow),
                            label: Text(_isPlayingRhyme ? "Stop" : "Play Rhyme"),
                            onPressed: () {
                              setState(() {
                                _isPlayingRhyme = !_isPlayingRhyme;
                              });
                              if (_isPlayingRhyme) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Playing simulated tune for: ${_rhymes[_activeRhymeIndex]["title"]}!'),
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // NUMBERS TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Click numbers to tap and spawn stars!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final num = index + 1;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _countingStars = num;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Counted: $num!', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            duration: const Duration(milliseconds: 800),
                            backgroundColor: AppColors.primaryBlue,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _countingStars == num ? AppColors.secondaryOrange : AppColors.primaryBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryBlue, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$num',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _countingStars == num ? Colors.white : AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                if (_countingStars > 0) ...[
                  Text(
                    'Let\'s count: $_countingStars!',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(_countingStars, (index) {
                      return const Icon(
                        Icons.star,
                        color: AppColors.secondaryOrange,
                        size: 40,
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),

          // ALPHABET TAB
          GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _alphabets.length,
            itemBuilder: (context, index) {
              final item = _alphabets[index];
              final colVal = int.parse(item["color"]!);
              return Card(
                color: Color(colVal),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _showCardDialog(item["letter"]!, "${item["letter"]} for ${item["word"]}", item["emoji"]!),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item["letter"]!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(item["emoji"]!, style: const TextStyle(fontSize: 28)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // HINDI VARNMALA TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('स्वर (Vowels)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _swar.length,
                  itemBuilder: (context, index) {
                    final item = _swar[index];
                    return Card(
                      color: isDark ? AppColors.darkSurface : Colors.grey[100],
                      child: InkWell(
                        onTap: () => _showCardDialog(item["letter"]!, "${item["letter"]} से ${item["word"]}", item["emoji"]!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item["letter"]!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(item["emoji"]!, style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text('व्यंजन (Consonants)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _vyanjan.length,
                  itemBuilder: (context, index) {
                    final item = _vyanjan[index];
                    return Card(
                      color: isDark ? AppColors.darkSurface : Colors.grey[100],
                      child: InkWell(
                        onTap: () => _showCardDialog(item["letter"]!, "${item["letter"]} से ${item["word"]}", item["emoji"]!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item["letter"]!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(item["emoji"]!, style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // EASY WORDS TAB
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _easyWords.length,
            itemBuilder: (context, index) {
              final item = _easyWords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(item["emoji"]!, style: const TextStyle(fontSize: 48)),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["word"]!,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["sentence"]!,
                              style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: AppColors.secondaryOrange),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pronouncing: ${item["word"]}!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
