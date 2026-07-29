import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
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
    {"letter": "M", "word": "Monkey", "emoji": "🐒", "color": "0xFFE57373"},
    {"letter": "N", "word": "Nest", "emoji": "🪺", "color": "0xFF64B5F6"},
    {"letter": "O", "word": "Orange", "emoji": "🍊", "color": "0xFFFFB74D"},
    {"letter": "P", "word": "Parrot", "emoji": "🦜", "color": "0xFF81C784"},
    {"letter": "Q", "word": "Queen", "emoji": "👑", "color": "0xFFBA68C8"},
    {"letter": "R", "word": "Rabbit", "emoji": "🐇", "color": "0xFF4DD0E1"},
    {"letter": "S", "word": "Sun", "emoji": "☀️", "color": "0xFFD4E157"},
    {"letter": "T", "word": "Tiger", "emoji": "🐯", "color": "0xFFA1887F"},
    {"letter": "U", "word": "Umbrella", "emoji": "☂️", "color": "0xFFF06292"},
    {"letter": "V", "word": "Violin", "emoji": "🎻", "color": "0xFFFFD54F"},
    {"letter": "W", "word": "Watch", "emoji": "⌚", "color": "0xFF4DB6AC"},
    {"letter": "X", "word": "Xylophone", "emoji": "🎼", "color": "0xFFFF8A65"},
    {"letter": "Y", "word": "Yacht", "emoji": "⛵", "color": "0xFFE57373"},
    {"letter": "Z", "word": "Zebra", "emoji": "🦓", "color": "0xFF64B5F6"},
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
    {"letter": "अः", "word": "खाली", "emoji": "🗣️"},
  ];

  final List<Map<String, String>> _vyanjan = [
    {"letter": "क", "word": "कबूतर", "emoji": "🕊️"},
    {"letter": "ख", "word": "खरगोश", "emoji": "🐇"},
    {"letter": "ग", "word": "गमला", "emoji": "🪴"},
    {"letter": "घ", "word": "घर", "emoji": "🏠"},
    {"letter": "ङ", "word": "खाली", "emoji": "🔘"},
    {"letter": "च", "word": "चम्मच", "emoji": "🥄"},
    {"letter": "छ", "word": "छाता", "emoji": "⛱️"},
    {"letter": "ज", "word": "जहाज", "emoji": "🚢"},
    {"letter": "झ", "word": "झंडा", "emoji": "🇮🇳"},
    {"letter": "ञ", "word": "खाली", "emoji": "🔘"},
    {"letter": "ट", "word": "टमाटर", "emoji": "🍅"},
    {"letter": "ठ", "word": "ठठेरा", "emoji": "🔨"},
    {"letter": "ड", "word": "डमरू", "emoji": "🥁"},
    {"letter": "ढ", "word": "ढक्कन", "emoji": "🪘"},
    {"letter": "ण", "word": "खाली", "emoji": "🔘"},
    {"letter": "त", "word": "तरबूज", "emoji": "🍉"},
    {"letter": "थ", "word": "थर्मस", "emoji": "🍼"},
    {"letter": "द", "word": "दवात", "emoji": "🖋️"},
    {"letter": "ध", "word": "धनुष", "emoji": "🏹"},
    {"letter": "न", "word": "नल", "emoji": "🚰"},
    {"letter": "प", "word": "पतंग", "emoji": "🪁"},
    {"letter": "फ", "word": "फल", "emoji": "🍎"},
    {"letter": "ब", "word": "बत्तख", "emoji": "🦆"},
    {"letter": "भ", "word": "भालू", "emoji": "🐻"},
    {"letter": "म", "word": "मछली", "emoji": "🐟"},
    {"letter": "य", "word": "यज्ञ", "emoji": "🔥"},
    {"letter": "र", "word": "रथ", "emoji": "🏹"},
    {"letter": "ल", "word": "लट्टू", "emoji": "🪀"},
    {"letter": "व", "word": "वन", "emoji": "🌳"},
    {"letter": "श", "word": "शलगम", "emoji": "🧅"},
    {"letter": "ष", "word": "षट्कोण", "emoji": "💠"},
    {"letter": "स", "word": "सपेरा", "emoji": "🐍"},
    {"letter": "ह", "word": "हवाई जहाज", "emoji": "✈️"},
    {"letter": "क्ष", "word": "क्षत्रिय", "emoji": "🛡️"},
    {"letter": "त्र", "word": "त्रिशूल", "emoji": "🔱"},
    {"letter": "ज्ञ", "word": "ज्ञानी", "emoji": "👨‍🏫"},
  ];

  final List<Map<String, String>> _easyWords = [
    {"word": "APPLE", "emoji": "🍎", "sentence": "An apple a day keeps the doctor away."},
    {"word": "BALL", "emoji": "⚽", "sentence": "Play with the football."},
    {"word": "CAT", "emoji": "🐱", "sentence": "The cat is sleeping on the mat."},
    {"word": "DOG", "emoji": "🐶", "sentence": "The dog barks loud."},
    {"word": "ELEPHANT", "emoji": "🐘", "sentence": "Elephants are very big animals."},
    {"word": "FISH", "emoji": "🐟", "sentence": "Fish swim in the water."},
    {"word": "GRAPES", "emoji": "🍇", "sentence": "Grapes are sweet and green."},
    {"word": "HOUSE", "emoji": "🏠", "sentence": "This is my sweet home."},
    {"word": "ICE CREAM", "emoji": "🍦", "sentence": "I love cold ice cream."},
    {"word": "JUG", "emoji": "🫙", "sentence": "Fill the water in the jug."},
    {"word": "KITE", "emoji": "🪁", "sentence": "Kite flies high in the sky."},
    {"word": "LION", "emoji": "🦁", "sentence": "The lion is the king of the forest."},
    {"word": "MONKEY", "emoji": "🐒", "sentence": "Monkeys love to eat bananas."},
    {"word": "NEST", "emoji": "🪺", "sentence": "Birds live in a nest."},
    {"word": "ORANGE", "emoji": "🍊", "sentence": "Oranges are orange in color."},
    {"word": "PENCIL", "emoji": "✏️", "sentence": "I write with my pencil."},
    {"word": "QUEEN", "emoji": "👑", "sentence": "The queen wears a gold crown."},
    {"word": "ROSE", "emoji": "🌹", "sentence": "Rose is a beautiful flower."},
    {"word": "SUN", "emoji": "☀️", "sentence": "The sun is very hot and bright."},
    {"word": "TOY", "emoji": "🧸", "sentence": "I play with my teddy bear."},
    {"word": "UMBRELLA", "emoji": "☂️", "sentence": "Umbrella protects us from rain."},
    {"word": "VAN", "emoji": "🚐", "sentence": "We go to school in a van."},
    {"word": "WATER", "emoji": "💧", "sentence": "Drink clean water everyday."},
    {"word": "XYLOPHONE", "emoji": "🎼", "sentence": "Xylophone plays sweet music."},
    {"word": "YAK", "emoji": "🐂", "sentence": "Yak lives in cold snowy hills."},
    {"word": "ZEBRA", "emoji": "🦓", "sentence": "Zebra has black and white stripes."},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _stopTextSpeech();
    super.dispose();
  }

  void _stopTextSpeech() {
    if (kIsWeb) {
      try {
        js.context.callMethod('eval', ["if ('speechSynthesis' in window) { window.speechSynthesis.cancel(); }"]);
      } catch (_) {}
    }
  }

  void _speakText(String text) {
    if (kIsWeb) {
      try {
        final cleanText = text.replaceAll("'", "\\'").replaceAll("\n", " ");
        final jsCode = """
          if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            var msg = new SpeechSynthesisUtterance('$cleanText');
            var isHindi = /[\\u0900-\\u097F]/.test('$cleanText');
            msg.lang = isHindi ? 'hi-IN' : 'en-US';
            msg.rate = 0.8;
            window.speechSynthesis.speak(msg);
          }
        """;
        js.context.callMethod('eval', [jsCode]);
      } catch (e) {
        debugPrint("Speech synthesis error: $e");
      }
    } else {
      debugPrint("TTS voice simulation: $text");
    }
  }

  void _showCardDialog(String title, String subtitle, String emoji) {
    _speakText("$title. $subtitle");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                _stopTextSpeech();
                Navigator.pop(context);
              },
              child: const Text('Nice!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Tab(text: 'Numbers 1-100 🔟', icon: Icon(Icons.pin)),
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
                          _stopTextSpeech();
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
                        style: const TextStyle(fontSize: 18, height: 1.6, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPlayingRhyme ? Colors.red : AppColors.accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: Icon(_isPlayingRhyme ? Icons.stop : Icons.play_arrow, size: 24),
                            label: Text(_isPlayingRhyme ? "Stop Song" : "Play Voice Song", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              setState(() {
                                _isPlayingRhyme = !_isPlayingRhyme;
                              });
                              if (_isPlayingRhyme) {
                                _speakText(_rhymes[_activeRhymeIndex]["lyrics"]!);
                              } else {
                                _stopTextSpeech();
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

          // NUMBERS 1-100 TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Tap any number from 1 to 100 to hear and count stars! ⭐',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    final num = index + 1;
                    final isSelected = _countingStars == num;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _countingStars = num;
                        });
                        _speakText(num.toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.secondaryOrange : AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.secondaryOrange : AppColors.primaryBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$num',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (_countingStars > 0) ...[
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Let\'s count: $_countingStars stars! 🌟',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: List.generate(_countingStars, (index) {
                            return const Icon(
                              Icons.star,
                              color: AppColors.secondaryOrange,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ALPHABET A-Z TAB
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
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
                        Text(item["letter"]!, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(item["emoji"]!, style: const TextStyle(fontSize: 32)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // HINDI VARNMALA TAB
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('स्वर (Vowels)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _swar.length,
                  itemBuilder: (context, index) {
                    final item = _swar[index];
                    return Card(
                      elevation: 2,
                      color: isDark ? AppColors.darkSurface : Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => _showCardDialog(item["letter"]!, "${item["letter"]} से ${item["word"]}", item["emoji"]!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item["letter"]!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(item["emoji"]!, style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                const Text('व्यंजन (Consonants)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _vyanjan.length,
                  itemBuilder: (context, index) {
                    final item = _vyanjan[index];
                    return Card(
                      elevation: 2,
                      color: isDark ? AppColors.darkSurface : Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => _showCardDialog(item["letter"]!, "${item["letter"]} से ${item["word"]}", item["emoji"]!),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item["letter"]!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(item["emoji"]!, style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // EASY WORDS A-Z TAB
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _easyWords.length,
            itemBuilder: (context, index) {
              final item = _easyWords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        icon: const Icon(Icons.volume_up, color: AppColors.secondaryOrange, size: 28),
                        onPressed: () {
                          _speakText("${item["word"]}. ${item["sentence"]}");
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
