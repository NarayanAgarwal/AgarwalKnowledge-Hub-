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
  String _selectedVoiceGender = 'female'; // 'female' or 'male'
  int? _pressedGridIndex; // For 3D press animation on grids
  String? _pressedSection; // Track active tab section for grid presses

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
    {"letter": "A", "word": "Apple", "emoji": "🍎", "color": "0xFFFFF1F1"},
    {"letter": "B", "word": "Ball", "emoji": "⚽", "color": "0xFFE3F2FD"},
    {"letter": "C", "word": "Cat", "emoji": "🐱", "color": "0xFFFFF8E1"},
    {"letter": "D", "word": "Dog", "emoji": "🐶", "color": "0xFFE8F5E9"},
    {"letter": "E", "word": "Elephant", "emoji": "🐘", "color": "0xFFF3E5F5"},
    {"letter": "F", "word": "Fish", "emoji": "🐟", "color": "0xFFE0F7FA"},
    {"letter": "G", "word": "Grapes", "emoji": "🍇", "color": "0xFFF1F8E9"},
    {"letter": "H", "word": "Horse", "emoji": "🐴", "color": "0xFFEFEBE9"},
    {"letter": "I", "word": "Ice Cream", "emoji": "🍦", "color": "0xFFFCE4EC"},
    {"letter": "J", "word": "Jug", "emoji": "🏺", "color": "0xFFFFFDE7"},
    {"letter": "K", "word": "Kite", "emoji": "🪁", "color": "0xFFE0F2F1"},
    {"letter": "L", "word": "Lion", "emoji": "🦁", "color": "0xFFFBE9E7"},
    {"letter": "M", "word": "Monkey", "emoji": "🐒", "color": "0xFFFFF1F1"},
    {"letter": "N", "word": "Nest", "emoji": "🪺", "color": "0xFFE3F2FD"},
    {"letter": "O", "word": "Orange", "emoji": "🍊", "color": "0xFFFFF8E1"},
    {"letter": "P", "word": "Parrot", "emoji": "🦜", "color": "0xFFE8F5E9"},
    {"letter": "Q", "word": "Queen", "emoji": "👑", "color": "0xFFF3E5F5"},
    {"letter": "R", "word": "Rabbit", "emoji": "🐇", "color": "0xFFE0F7FA"},
    {"letter": "S", "word": "Sun", "emoji": "☀️", "color": "0xFFF1F8E9"},
    {"letter": "T", "word": "Tiger", "emoji": "🐯", "color": "0xFFEFEBE9"},
    {"letter": "U", "word": "Umbrella", "emoji": "☂️", "color": "0xFFFCE4EC"},
    {"letter": "V", "word": "Van", "emoji": "🚐", "color": "0xFFFFFDE7"},
    {"letter": "W", "word": "Watch", "emoji": "⌚", "color": "0xFFE0F2F1"},
    {"letter": "X", "word": "Xylophone", "emoji": "🎼", "color": "0xFFFBE9E7"},
    {"letter": "Y", "word": "Yacht", "emoji": "⛵", "color": "0xFFFFF1F1"},
    {"letter": "Z", "word": "Zebra", "emoji": "🦓", "color": "0xFFE3F2FD"},
  ];

  final List<Map<String, String>> _swar = [
    {"letter": "अ", "word": "अनार", "emoji": "🍒"},
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
    {"letter": "र", "word": "रथ", "emoji": "🎠"},
    {"letter": "ल", "word": "लट्टू", "emoji": "🪀"},
    {"letter": "व", "word": "वन", "emoji": "🌳"},
    {"letter": "श", "word": "शलगम", "emoji": "🧅"},
    {"letter": "ष", "word": "षट्कोण", "emoji": "💠"},
    {"letter": "स", "word": "सपेरा", "emoji": "🐍"},
    {"letter": "ह", "word": "हवाई जहाज", "emoji": "✈️"},
    {"letter": "क्ष", "word": "क्षत्रिय", "emoji": "⚔️"},
    {"letter": "त्र", "word": "त्रिशूल", "emoji": "🔱"},
    {"letter": "ज्ञ", "word": "ज्ञानी", "emoji": "👨‍🏫"},
  ];

  final Map<String, List<Map<String, String>>> _easyWordsGrouped = {
    "A": [
      {"word": "ANT", "emoji": "🐜", "sentence": "Ants work together in a team."},
      {"word": "AXE", "emoji": "🪓", "sentence": "An axe is used to cut wood."},
      {"word": "APPLE", "emoji": "🍎", "sentence": "An apple a day keeps the doctor away."}
    ],
    "B": [
      {"word": "BALL", "emoji": "⚽", "sentence": "Throw the colorful ball."},
      {"word": "BAT", "emoji": "🏏", "sentence": "Hit the ball with the bat."},
      {"word": "BOY", "emoji": "👦", "sentence": "The boy is reading a book."}
    ],
    "C": [
      {"word": "CAT", "emoji": "🐱", "sentence": "The cat drinks milk."},
      {"word": "CAR", "emoji": "🚗", "sentence": "Drive the red car safely."},
      {"word": "COW", "emoji": "🐄", "sentence": "The cow gives fresh milk."}
    ],
    "D": [
      {"word": "DOG", "emoji": "🐶", "sentence": "The dog is wagging its tail."},
      {"word": "DOLL", "emoji": "🪆", "sentence": "I have a cute barbie doll."},
      {"word": "DUCK", "emoji": "🦆", "sentence": "Ducks are swimming in the pond."}
    ],
    "E": [
      {"word": "EGG", "emoji": "🥚", "sentence": "Eat a healthy egg daily."},
      {"word": "EYE", "emoji": "👁️", "sentence": "Look at the stars with your eyes."},
      {"word": "EAR", "emoji": "👂", "sentence": "Listen to the birds with your ears."}
    ],
    "F": [
      {"word": "FISH", "emoji": "🐟", "sentence": "Fish live under water."},
      {"word": "FOX", "emoji": "🦊", "sentence": "The fox is a clever animal."},
      {"word": "FAN", "emoji": "🪭", "sentence": "Switch on the fan to feel cool."}
    ],
    "G": [
      {"word": "GRAPES", "emoji": "🍇", "sentence": "Grapes grow in bunches."},
      {"word": "GIRL", "emoji": "👧", "sentence": "She is a very smart child."},
      {"word": "GOAT", "emoji": "🐐", "sentence": "Goats eat fresh green leaves."}
    ],
    "H": [
      {"word": "HOUSE", "emoji": "🏠", "sentence": "This is our beautiful house."},
      {"word": "HAT", "emoji": "🎩", "sentence": "Wear a sun hat on hot days."},
      {"word": "HEN", "emoji": "🐔", "sentence": "The hen laid an egg."}
    ],
    "I": [
      {"word": "ICE", "emoji": "🧊", "sentence": "Ice is very cold and solid."},
      {"word": "INK", "emoji": "✒️", "sentence": "Fill ink in the fountain pen."},
      {"word": "IRON", "emoji": "🧲", "sentence": "Magnets attract iron nails."}
    ],
    "J": [
      {"word": "JUG", "emoji": "🏺", "sentence": "Pour water from the jug."},
      {"word": "JEEP", "emoji": "🚙", "sentence": "We went for a ride in the jeep."},
      {"word": "JAM", "emoji": "🍓", "sentence": "Spread sweet jam on bread."}
    ],
    "K": [
      {"word": "KITE", "emoji": "🪁", "sentence": "Kites fly high in the air."},
      {"word": "KEY", "emoji": "🔑", "sentence": "Use the key to open the lock."},
      {"word": "KING", "emoji": "👑", "sentence": "The king lives in a castle."}
    ],
    "L": [
      {"word": "LION", "emoji": "🦁", "sentence": "The lion is the king of jungle."},
      {"word": "LAMP", "emoji": "💡", "sentence": "Turn on the lamp at night."},
      {"word": "LEAF", "emoji": "🍃", "sentence": "The green leaf fell from tree."}
    ],
    "M": [
      {"word": "MONKEY", "emoji": "🐒", "sentence": "Monkey is swinging on branches."},
      {"word": "MILK", "emoji": "🥛", "sentence": "Drink warm milk for strong bones."},
      {"word": "MOON", "emoji": "🌙", "sentence": "The moon shines bright at night."}
    ],
    "N": [
      {"word": "NEST", "emoji": "🪺", "sentence": "Birds built a nest on tree."},
      {"word": "NET", "emoji": "🕸️", "sentence": "Use a net to catch butterflies."},
      {"word": "NUT", "emoji": "🥜", "sentence": "Peanuts are a healthy type of nut."}
    ],
    "O": [
      {"word": "ORANGE", "emoji": "🍊", "sentence": "Orange is a sweet juicy fruit."},
      {"word": "OWL", "emoji": "🦉", "sentence": "The owl stays awake all night."},
      {"word": "OX", "emoji": "🐂", "sentence": "The strong ox plows the field."}
    ],
    "P": [
      {"word": "PENCIL", "emoji": "✏️", "sentence": "Sharpen your pencil before writing."},
      {"word": "PEN", "emoji": "🖊️", "sentence": "The teacher writes with a blue pen."},
      {"word": "PIG", "emoji": "🐷", "sentence": "The little pig plays in the mud."}
    ],
    "Q": [
      {"word": "QUEEN", "emoji": "👑", "sentence": "The queen wears a shiny crown."},
      {"word": "QUILT", "emoji": "🛏️", "sentence": "Use a warm quilt in winter."},
      {"word": "QUIZ", "emoji": "❓", "sentence": "Answer the fun quiz questions."}
    ],
    "R": [
      {"word": "RABBIT", "emoji": "🐇", "sentence": "The white rabbit eats carrots."},
      {"word": "ROSE", "emoji": "🌹", "sentence": "Rose is a beautiful red flower."},
      {"word": "RING", "emoji": "💍", "sentence": "She wears a gold ring on her finger."}
    ],
    "S": [
      {"word": "SUN", "emoji": "☀️", "sentence": "The sun rises in the east."},
      {"word": "STAR", "emoji": "⭐", "sentence": "A tiny star shines in the sky."},
      {"word": "SHIP", "emoji": "🚢", "sentence": "The big ship sails on sea."}
    ],
    "T": [
      {"word": "TIGER", "emoji": "🐯", "sentence": "The tiger has black stripes."},
      {"word": "TOY", "emoji": "🧸", "sentence": "I share my toys with friends."},
      {"word": "TREE", "emoji": "🌳", "sentence": "Trees give us cool shade."}
    ],
    "U": [
      {"word": "UMBRELLA", "emoji": "☂️", "sentence": "Open your umbrella in the rain."},
      {"word": "UNCLE", "emoji": "👨", "sentence": "My uncle bought me a new toy."},
      {"word": "UP", "emoji": "⬆️", "sentence": "Look up at the blue sky."}
    ],
    "V": [
      {"word": "VAN", "emoji": "🚐", "sentence": "The school van has arrived."},
      {"word": "VIOLIN", "emoji": "🎻", "sentence": "Play sweet music on the violin."},
      {"word": "VASE", "emoji": "🏺", "sentence": "Place fresh flowers in the vase."}
    ],
    "W": [
      {"word": "WATCH", "emoji": "⌚", "sentence": "Check the time on your watch."},
      {"word": "WATER", "emoji": "💧", "sentence": "Water is essential for life."},
      {"word": "WEB", "emoji": "🕸️", "sentence": "The spider spun a sticky web."}
    ],
    "X": [
      {"word": "XYLOPHONE", "emoji": "🎼", "sentence": "Tap the keys of the xylophone."},
      {"word": "XMAS TREE", "emoji": "🎄", "sentence": "Decorate the Xmas tree with lights."},
      {"word": "X-RAY", "emoji": "🩻", "sentence": "The doctor took an X-ray of my hand."}
    ],
    "Y": [
      {"word": "YAK", "emoji": "🐂", "sentence": "The yak lives in snowy mountains."},
      {"word": "YACHT", "emoji": "⛵", "sentence": "The white yacht sails smoothly."},
      {"word": "YOYO", "emoji": "🪀", "sentence": "Spin the yoyo up and down."}
    ],
    "Z": [
      {"word": "ZEBRA", "emoji": "🦓", "sentence": "The zebra crossed the road."},
      {"word": "ZIP", "emoji": "🤐", "sentence": "Close the zip of your bag."},
      {"word": "ZOO", "emoji": "🦁", "sentence": "We saw many wild animals at the zoo."}
    ]
  };

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
            
            function setVoiceAndSpeak() {
              var voices = window.speechSynthesis.getVoices();
              var langFilter = isHindi ? 'hi' : 'en';
              var gender = '$_selectedVoiceGender';
              var voice = null;
              
              for (var i = 0; i < voices.length; i++) {
                var v = voices[i];
                var vLang = v.lang.toLowerCase();
                var vName = v.name.toLowerCase();
                if (vLang.indexOf(langFilter) !== -1) {
                  if (gender === 'female' && (vName.indexOf('zira') !== -1 || vName.indexOf('female') !== -1 || vName.indexOf('google') !== -1 || vName.indexOf('siri') !== -1 || vName.indexOf('hazel') !== -1 || vName.indexOf('kalpana') !== -1)) {
                    voice = v;
                    break;
                  }
                  if (gender === 'male' && (vName.indexOf('david') !== -1 || vName.indexOf('male') !== -1 || vName.indexOf('ravi') !== -1 || vName.indexOf('microsoft') !== -1 || vName.indexOf('heera') !== -1)) {
                    voice = v;
                    break;
                  }
                }
              }
              
              if (!voice) {
                for (var i = 0; i < voices.length; i++) {
                  if (voices[i].lang.toLowerCase().indexOf(langFilter) !== -1) {
                    voice = voices[i];
                    break;
                  }
                }
              }
              
              if (voice) {
                msg.voice = voice;
              }
              msg.pitch = (gender === 'female') ? 1.35 : 0.85;
              msg.rate = isHindi ? 0.72 : 0.8; // Crystal-clear slow rate
              msg.volume = 1.0;
              window.speechSynthesis.speak(msg);
            }
            
            if (window.speechSynthesis.getVoices().length > 0) {
              setVoiceAndSpeak();
            } else {
              window.speechSynthesis.onvoiceschanged = setVoiceAndSpeak;
            }
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

  void _playRhymeAsSong(String lyrics) {
    if (kIsWeb) {
      try {
        // String newlines must be strictly escaped to avoid breaking Javascript template literals!
        final cleanText = lyrics.replaceAll("'", "\\'").replaceAll("\r", "").replaceAll("\n", "\\n");
        final jsCode = """
          if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            var lines = '$cleanText'.split('\\n');
            var idx = 0;
            var gender = '$_selectedVoiceGender';
            
            function speakLine() {
              if (idx >= lines.length) return;
              var line = lines[idx].trim();
              if (line.length === 0) {
                idx++;
                speakLine();
                return;
              }
              
              var msg = new SpeechSynthesisUtterance(line);
              msg.lang = 'en-US';
              
              function setSongVoiceAndSpeak() {
                var voices = window.speechSynthesis.getVoices();
                var voice = null;
                for (var i = 0; i < voices.length; i++) {
                  var v = voices[i];
                  var vName = v.name.toLowerCase();
                  if (v.lang.toLowerCase().indexOf('en') !== -1) {
                    if (gender === 'female' && (vName.indexOf('zira') !== -1 || vName.indexOf('female') !== -1 || vName.indexOf('google') !== -1 || vName.indexOf('siri') !== -1)) {
                      voice = v;
                      break;
                    }
                    if (gender === 'male' && (vName.indexOf('david') !== -1 || vName.indexOf('male') !== -1 || vName.indexOf('microsoft') !== -1)) {
                      voice = v;
                      break;
                    }
                  }
                }
                
                if (voice) {
                  msg.voice = voice;
                }
                
                var basePitch = (gender === 'female') ? 1.35 : 0.85;
                var modulation = [0, 0.18, -0.12, 0.08];
                msg.pitch = basePitch + (modulation[idx % 4]);
                msg.rate = 0.72 + (idx % 2 * 0.05); 
                msg.volume = 1.0;
                
                msg.onend = function() {
                  idx++;
                  setTimeout(speakLine, 450); // clear melodic gap
                };
                window.speechSynthesis.speak(msg);
              }
              
              if (window.speechSynthesis.getVoices().length > 0) {
                setSongVoiceAndSpeak();
              } else {
                window.speechSynthesis.onvoiceschanged = setSongVoiceAndSpeak;
              }
            }
            speakLine();
          }
        """;
        js.context.callMethod('eval', [jsCode]);
      } catch (e) {
        debugPrint("Song synthesis error: $e");
      }
    } else {
      debugPrint("Song simulation: $lyrics");
    }
  }

  String getEmojiUrl(String emoji, {String word = ""}) {
    if (emoji.isEmpty) return "";
    // Transparent Pomegranate
    if (emoji == "🍒" || emoji.contains("🍒") || word == "अनार") {
      return "https://upload.wikimedia.org/wikipedia/commons/e/ea/Pomegranate_drawing_with_transparent_background.png";
    }
    // Transparent Jug Pitcher
    if (emoji == "🏺" || word == "Jug" || word == "JUG" || emoji.contains("🏺")) {
      return "https://upload.wikimedia.org/wikipedia/commons/2/23/Pitcher_Jug_%28PSF%29.png";
    }
    try {
      final runes = emoji.runes.toList();
      if (runes.isEmpty) return "";
      final hexParts = runes.map((rune) => rune.toRadixString(16).toLowerCase()).toList();
      final hexString = hexParts.join("_");
      return "https://fonts.gstatic.com/s/e/notoemoji/latest/$hexString/512.png";
    } catch (e) {
      return "";
    }
  }

  Widget _buildEmojiImage(String emoji, {double size = 48, String word = ""}) {
    final url = getEmojiUrl(emoji, word: word);
    if (url.isNotEmpty) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (c, o, s) => Text(emoji, style: TextStyle(fontSize: size)),
      );
    }
    return Text(emoji, style: TextStyle(fontSize: size));
  }

  // 3D Embossed toy-blocks button layout (Duolingo 3D style)
  Widget _build3DBlock({
    required Widget child,
    required Color baseColor,
    required Color shadowColor,
    required VoidCallback onTap,
    required int index,
    required String section,
    double borderRadius = 16,
    double shadowDepth = 6.0,
  }) {
    final bool isPressed = _pressedGridIndex == index && _pressedSection == section;
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedGridIndex = index;
          _pressedSection = section;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressedGridIndex = null;
          _pressedSection = null;
        });
        onTap();
      },
      onTapCancel: () {
        setState(() {
          _pressedGridIndex = null;
          _pressedSection = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        margin: EdgeInsets.only(
          top: isPressed ? shadowDepth : 0,
          bottom: isPressed ? 0 : shadowDepth,
        ),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.5),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: shadowColor,
                    offset: Offset(0, shadowDepth),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: child,
      ),
    );
  }

  void _showCardDialog(String title, String subtitle, String emoji, {String word = ""}) {
    _speakText("$title. $subtitle");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmojiImage(emoji, size: 100, word: word),
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
    final playroomBgColor = isDark ? Colors.grey[900] : const Color(0xFFFFFDF5); // Warm cream playroom background
    final blockBaseColor = isDark ? AppColors.darkSurface : Colors.white;
    final blockShadowColor = isDark ? Colors.black54 : const Color(0xFFDDD7C8);

    return Scaffold(
      backgroundColor: playroomBgColor,
      appBar: AppBar(
        title: const Text('Study with Play 🎈', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: DropdownButton<String>(
              value: _selectedVoiceGender,
              dropdownColor: AppColors.primaryBlue,
              underline: const SizedBox(),
              icon: const Icon(Icons.volume_up, color: Colors.white, size: 18),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'female', child: Text('Voice: Female 👩')),
                DropdownMenuItem(value: 'male', child: Text('Voice: Male 👨')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedVoiceGender = val;
                  });
                  _speakText("Voice changed!");
                }
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Styled 3D Blue Shelf TabBar (matches 3rd screenshot shelf design)
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFB3E5FC), // light-blue shelf
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              tabs: const [
                Tab(text: 'Rhymes 🎵', icon: Icon(Icons.music_note)),
                Tab(text: 'Numbers 1-100 🔟', icon: Icon(Icons.pin)),
                Tab(text: 'A B C D 🔠', icon: Icon(Icons.abc)),
                Tab(text: 'Varnmala ✍️', icon: Icon(Icons.font_download_outlined)),
                Tab(text: 'Easy Words 🐱', icon: Icon(Icons.child_care)),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
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
                            _buildEmojiImage(_rhymes[_activeRhymeIndex]["emoji"]!, size: 90),
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
                                  label: Text(_isPlayingRhyme ? "Stop Song" : "Play Voice Song 🎵", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    setState(() {
                                      _isPlayingRhyme = !_isPlayingRhyme;
                                    });
                                    if (_isPlayingRhyme) {
                                      _playRhymeAsSong(_rhymes[_activeRhymeIndex]["lyrics"]!);
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

                // NUMBERS 1-100 TAB (Pixel-perfect 3D toy block shelf from 3rd screenshot)
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
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          final num = index + 1;
                          final isSelected = _countingStars == num;
                          
                          // Match orange-tinted active select cell from 3rd screenshot
                          final baseColor = isSelected ? Colors.deepOrange : blockBaseColor;
                          final shadowColor = isSelected ? Colors.red[900]! : blockShadowColor;
                          final textColor = isSelected ? Colors.white : AppColors.primaryBlue;

                          return _build3DBlock(
                            index: index,
                            section: "numbers",
                            baseColor: baseColor,
                            shadowColor: shadowColor,
                            onTap: () {
                              setState(() {
                                _countingStars = num;
                              });
                              _speakText(num.toString());
                            },
                            child: Text(
                              '$num',
                              style: TextStyle(
                                fontSize: 22, // Large readable font
                                fontWeight: FontWeight.w900,
                                color: textColor,
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
                                    size: 22,
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
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.76,
                  ),
                  itemCount: _alphabets.length,
                  itemBuilder: (context, index) {
                    final item = _alphabets[index];
                    final colVal = Color(int.parse(item["color"]!));
                    final shadowVal = Color(int.parse(item["color"]!)).withBlue(100).withRed(150);
                    return _build3DBlock(
                      index: index,
                      section: "alphabets",
                      baseColor: isDark ? AppColors.darkSurface : colVal,
                      shadowColor: isDark ? Colors.black54 : shadowVal,
                      onTap: () => _showCardDialog(
                        item["letter"]!,
                        "${item["letter"]} for ${item["word"]}",
                        item["emoji"]!,
                        word: item["word"]!,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item["letter"]!,
                            style: const TextStyle(
                              fontSize: 44, // Huge readable font
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildEmojiImage(item["emoji"]!, size: 54, word: item["word"]!),
                        ],
                      ),
                    );
                  },
                ),

                // HINDI VARNMALA TAB (Fully 3D with correct Pomegranate image)
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
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: _swar.length,
                        itemBuilder: (context, index) {
                          final item = _swar[index];
                          return _build3DBlock(
                            index: index,
                            section: "swar",
                            baseColor: blockBaseColor,
                            shadowColor: blockShadowColor,
                            onTap: () => _showCardDialog(
                              item["letter"]!,
                              "${item["letter"]} से ${item["word"]}",
                              item["emoji"]!,
                              word: item["word"]!,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item["letter"]!, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                _buildEmojiImage(item["emoji"]!, size: 36, word: item["word"]!),
                              ],
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
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: _vyanjan.length,
                        itemBuilder: (context, index) {
                          final item = _vyanjan[index];
                          return _build3DBlock(
                            index: index,
                            section: "vyanjan",
                            baseColor: blockBaseColor,
                            shadowColor: blockShadowColor,
                            onTap: () => _showCardDialog(
                              item["letter"]!,
                              "${item["letter"]} से ${item["word"]}",
                              item["emoji"]!,
                              word: item["word"]!,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item["letter"]!, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                _buildEmojiImage(item["emoji"]!, size: 36, word: item["word"]!),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // EASY WORDS TAB
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _alphabets.length,
                  itemBuilder: (context, index) {
                    final letter = _alphabets[index]["letter"]!;
                    final color = Color(int.parse(_alphabets[index]["color"]!));
                    final wordsList = _easyWordsGrouped[letter] ?? [];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Card(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isDark ? AppColors.primaryBlue : color,
                                    child: Text(letter, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w900, fontSize: 18)),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('Words starting with $letter', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(wordsList.length, (wIdx) {
                                  final item = wordsList[wIdx];
                                  return Expanded(
                                    child: _build3DBlock(
                                      index: wIdx,
                                      section: "easy-$letter",
                                      baseColor: isDark ? AppColors.darkSurface : Colors.grey[50]!,
                                      shadowColor: blockShadowColor,
                                      onTap: () => _speakText("${item["word"]}. ${item["sentence"]}"),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                        child: Column(
                                          children: [
                                            _buildEmojiImage(item["emoji"]!, size: 40, word: item["word"]!),
                                            const SizedBox(height: 6),
                                            Text(item["word"]!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
