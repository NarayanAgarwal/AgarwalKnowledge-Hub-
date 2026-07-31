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
    {"letter": "X", "word": "Box", "emoji": "📦", "color": "0xFFFBE9E7"},
    {"letter": "Y", "word": "Yacht", "emoji": "⛵", "color": "0xFFFFF1F1"},
    {"letter": "Z", "word": "Zebra", "emoji": "🦓", "color": "0xFFE3F2FD"},
  ];
  // 100% dictionary words in English fallbacks to prevent David/Zira spelling out letters!
  final List<Map<String, String>> _swar = [
    {"letter": "अ", "word": "अनार", "emoji": "🍒", "english": "uh. uh say ana are"},
    {"letter": "आ", "word": "आम", "emoji": "🥭", "english": "ah. ah say alms"},
    {"letter": "इ", "word": "इमली", "emoji": "🫒", "english": "ye. ye say him lee"},
    {"letter": "ई", "word": "ईख", "emoji": "🎋", "english": "ye. ye say eke"},
    {"letter": "उ", "word": "उल्लू", "emoji": "🦉", "english": "ooh. ooh say ooh loo"},
    {"letter": "ऊ", "word": "ऊन", "emoji": "🧶", "english": "ooh. ooh say loon"},
    {"letter": "ऋ", "word": "ऋषि", "emoji": "🧘", "english": "reef. reef say reach she"},
    {"letter": "ए", "word": "एड़ी", "emoji": "🦶", "english": "ay. ay say ay dee"},
    {"letter": "ऐ", "word": "ऐनक", "emoji": "👓", "english": "ay. ay say ay neck"},
    {"letter": "ओ", "word": "ओखली", "emoji": "🥣", "english": "oh. oh say oh clay"},
    {"letter": "औ", "word": "औरत", "emoji": "👩", "english": "ow. ow say ow rut"},
    {"letter": "अं", "word": "अंगूर", "emoji": "🍇", "english": "uh. uh say on gore"},
    {"letter": "अः", "word": "खाली", "emoji": "🗣️", "english": "aha. aha say car lee"},
  ];
  final List<Map<String, String>> _vyanjan = [
    {"letter": "क", "word": "कबूतर", "emoji": "🕊️", "english": "kuh. kuh say kuh-boo-tar"},
    {"letter": "ख", "word": "खरगोश", "emoji": "🐇", "english": "khuh. khuh say khar-gosh"},
    {"letter": "ग", "word": "गमला", "emoji": "🪴", "english": "guh. guh say gum-la"},
    {"letter": "घ", "word": "घर", "emoji": "🏠", "english": "ghuh. ghuh say ghar"},
    {"letter": "ङ", "word": "खाली", "emoji": "🔘", "english": "nga. nga say khaali"},
    {"letter": "च", "word": "चम्मच", "emoji": "🥄", "english": "chuh. chuh say chum-much"},
    {"letter": "छ", "word": "छाता", "emoji": "⛱️", "english": "chhuh. chhuh say chhaa-ta"},
    {"letter": "ज", "word": "जहाज", "emoji": "🚢", "english": "juh. juh say juh-haaj"},
    {"letter": "झ", "word": "झंडा", "emoji": "🇮🇳", "english": "jhuh. jhuh say jhun-da"},
    {"letter": "ञ", "word": "खाली", "emoji": "🔘", "english": "nya. nya say khaali"},
    {"letter": "ट", "word": "टमाटर", "emoji": "🍅", "english": "tuh. tuh say tuh-maa-tar"},
    {"letter": "ठ", "word": "ठठेरा", "emoji": "🔨", "english": "thuh. thuh say thuh-they-ra"},
    {"letter": "ड", "word": "डमरू", "emoji": "🥁", "english": "duh. duh say dum-roo"},
    {"letter": "ढ", "word": "ढक्कन", "emoji": "🪘", "english": "dhuh. dhuh say dhuk-kun"},
    {"letter": "ण", "word": "खाली", "emoji": "🔘", "english": "na. na say khaali"},
    {"letter": "त", "word": "तरबूज", "emoji": "🍉", "english": "tuh. tuh say tar-booj"},
    {"letter": "थ", "word": "थर्मस", "emoji": "🍼", "english": "thuh. thuh say ther-mus"},
    {"letter": "द", "word": "दवात", "emoji": "🖋️", "english": "duh. duh say duh-vaat"},
    {"letter": "ध", "word": "धनुष", "emoji": "🏹", "english": "dhuh. dhuh say dhuh-nush"},
    {"letter": "न", "word": "नल", "emoji": "🚰", "english": "nuh. nuh say nul"},
    {"letter": "प", "word": "पतंग", "emoji": "🪁", "english": "puh. puh say puh-tung"},
    {"letter": "फ", "word": "फल", "emoji": "🍎", "english": "fuh. fuh say ful"},
    {"letter": "ब", "word": "बत्तख", "emoji": "🦆", "english": "buh. buh say but-tukh"},
    {"letter": "भ", "word": "भालू", "emoji": "🐻", "english": "bhuh. bhuh say bhaa-loo"},
    {"letter": "म", "word": "मछली", "emoji": "🐟", "english": "muh. muh say muchh-lee"},
    {"letter": "य", "word": "यज्ञ", "emoji": "🔥", "english": "yuh. yuh say yug-ya"},
    {"letter": "र", "word": "रथ", "emoji": "🎠", "english": "ruh. ruh say ruth"},
    {"letter": "ल", "word": "लट्टू", "emoji": "🪀", "english": "luh. luh say lut-too"},
    {"letter": "व", "word": "वन", "emoji": "🌳", "english": "wuh. wuh say wun"},
    {"letter": "श", "word": "शलगम", "emoji": "🧅", "english": "shuh. shuh say shul-gum"},
    {"letter": "ष", "word": "षट्कोण", "emoji": "💠", "english": "shuh. shuh say shut-kone"},
    {"letter": "स", "word": "सपेरा", "emoji": "🐍", "english": "suh. suh say suh-pay-ra"},
    {"letter": "ह", "word": "हवाई जहाज", "emoji": "✈️", "english": "huh. huh say huh-wye juh-haaj"},
    {"letter": "क्ष", "word": "क्षत्रिय", "emoji": "⚔️", "english": "kshuh. kshuh say kshut-ree-ya"},
    {"letter": "त्र", "word": "त्रिशूल", "emoji": "🔱", "english": "truh. truh say tree-shool"},
    {"letter": "ज्ञ", "word": "ज्ञानी", "emoji": "👨‍🏫", "english": "gyuh. gyuh say gya-nee"},
  ];
  static const Map<String, String> _emoji3dPaths = {
    "🍎": "Red apple/red_apple",
    "⚽": "Soccer ball/soccer_ball",
    "🐱": "Cat face/cat_face",
    "🐶": "Dog face/dog_face",
    "🐘": "Elephant/elephant",
    "🐟": "Fish/fish",
    "🍇": "Grapes/grapes",
    "🐴": "Horse face/horse_face",
    "🍦": "Soft ice cream/soft_ice_cream",
    "🪁": "Kite/kite",
    "🦁": "Lion/lion",
    "🐒": "Monkey/monkey",
    "🍊": "Tangerine/tangerine",
    "🦜": "Parrot/parrot",
    "👑": "Crown/crown",
    "🐇": "Rabbit face/rabbit_face",
    "☀️": "Sun/sun",
    "🐯": "Tiger face/tiger_face",
    "☂️": "Umbrella/umbrella",
    "🚐": "Minibus/minibus",
    "⌚": "Watch/watch",
    "🎼": "Musical score/musical_score",
    "⛵": "Sailboat/sailboat",
    "🦓": "Zebra/zebra",
    
    // Easy Words
    "🐜": "Ant/ant",
    "🪓": "Axe/axe",
    "🏏": "Cricket game/cricket_game",
    "👦": "Boy/boy",
    "🚗": "Automobile/automobile",
    "🐄": "Cow/cow",
    "🪆": "Nestling dolls/nestling_dolls",
    "🥛": "Glass of milk/glass_of_milk",
    "🌙": "New moon/new_moon",
    "🪺": "Nest with eggs/nest_with_eggs",
    "🕸️": "Spider web/spider_web",
    "🥜": "Peanuts/peanuts",
    "🧲": "Magnet/magnet",
    "🛏️": "Bed/bed",
    "❓": "Red question mark/red_question_mark",
    "🌹": "Rose/rose",
    "💍": "Ring/ring",
    "⭐": "Star/star",
    "🧸": "Teddy bear/teddy_bear",
    "🎽": "Running shirt/running_shirt",
    "🩻": "X-ray/x_ray",
    "🎄": "Christmas tree/christmas_tree",
    "🤐": "Zipper-mouth face/zipper_mouth_face",
    "📦": "Package/package",
    
    // Rhymes
    "🌟": "Glowing star/glowing_star",
    "👶": "Baby/baby",
    "🥚": "Egg/egg"
  };
  // Real photos and illustration URLs for all Varnmala cards to prevent cartoon icons!
  static const Map<String, String> _realVarnmalaImages = {
    "अ": "assets/images/anar.jpg",
    "आ": "https://upload.wikimedia.org/wikipedia/commons/9/90/HA_Mango.png",
    "इ": "assets/images/imli.jpg",
    "ई": "https://upload.wikimedia.org/wikipedia/commons/4/45/Sugarcane_stalk.png",
    "उ": "https://upload.wikimedia.org/wikipedia/commons/a/ae/Great_Horned_Owl_transparent.png",
    "ऊ": "https://upload.wikimedia.org/wikipedia/commons/7/77/Yarn_ball.png",
    "ऋ": "assets/images/rishi.jpg",
    "ए": "https://upload.wikimedia.org/wikipedia/commons/6/6c/Human_heel.png",
    "ऐ": "https://upload.wikimedia.org/wikipedia/commons/a/a2/Spectacles_transparent.png",
    "ओ": "https://upload.wikimedia.org/wikipedia/commons/e/ef/Mortar_and_pestle.png",
    "औ": "https://upload.wikimedia.org/wikipedia/commons/f/fb/Woman_sitting.png",
    "अं": "https://upload.wikimedia.org/wikipedia/commons/b/bb/Table_grapes_on_white.active.png",
    "अः": "https://upload.wikimedia.org/wikipedia/commons/d/df/Speaking_silhouette.png",
    
    "क": "https://upload.wikimedia.org/wikipedia/commons/4/40/Columba_livia_pigeon_transparent.png",
    "ख": "https://upload.wikimedia.org/wikipedia/commons/d/df/Rabbit_eating.png",
    "ग": "https://upload.wikimedia.org/wikipedia/commons/3/30/Potted_plant.png",
    "घ": "https://upload.wikimedia.org/wikipedia/commons/a/ac/House_with_garden.png",
    "ङ": "https://upload.wikimedia.org/wikipedia/commons/b/b3/Empty_circle.png",
    "च": "https://upload.wikimedia.org/wikipedia/commons/9/9c/Spoon_transparent.png",
    "छ": "https://upload.wikimedia.org/wikipedia/commons/5/5a/Umbrella_isolated.png",
    "ज": "https://upload.wikimedia.org/wikipedia/commons/a/ae/Cruise_ship_isolated.png",
    "झ": "https://upload.wikimedia.org/wikipedia/commons/4/41/Flag_of_India.png",
    "ञ": "https://upload.wikimedia.org/wikipedia/commons/b/b3/Empty_circle.png",
    "ट": "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg",
    "ठ": "assets/images/thathera.jpg",
    "ड": "assets/images/damru.jpg",
    "ढ": "assets/images/dhakkan.jpg",
    "ण": "https://upload.wikimedia.org/wikipedia/commons/b/b3/Empty_circle.png",
    "त": "https://upload.wikimedia.org/wikipedia/commons/4/47/Watermelon_isolated.png",
    "थ": "https://upload.wikimedia.org/wikipedia/commons/b/b3/Thermos_flask.png",
    "द": "assets/images/dawat.jpg",
    "ध": "https://upload.wikimedia.org/wikipedia/commons/a/a4/Wooden_bow_and_arrow.png",
    "न": "https://upload.wikimedia.org/wikipedia/commons/e/e2/Water_tap.png",
    "प": "https://upload.wikimedia.org/wikipedia/commons/b/b7/Kite_isolated.png",
    "फ": "assets/images/fal.jpg",
    "ब": "https://upload.wikimedia.org/wikipedia/commons/a/a1/Mallard2.jpg",
    "भ": "https://upload.wikimedia.org/wikipedia/commons/a/a9/Brown_bear_standing.png",
    "म": "assets/images/machhli.jpg",
    "य": "assets/images/yajna.jpg",
    "र": "https://upload.wikimedia.org/wikipedia/commons/a/ae/Chariot_drawing.png",
    "ल": "assets/images/lattu.jpg",
    "व": "assets/images/van.jpg",
    "श": "assets/images/shalgam.jpg",
    "ष": "assets/images/shatkon.png",
    "स": "assets/images/sapera.jpg",
    "ह": "https://upload.wikimedia.org/wikipedia/commons/7/75/Boeing_747_isolated.png",
    "क्ष": "assets/images/kshatriya.jpg",
    "त्र": "https://upload.wikimedia.org/wikipedia/commons/8/8a/Trident.png",
    "ज्ञ": "assets/images/gyani.jpg"
  };
  final Map<String, List<Map<String, String>>> _easyWordsGrouped = {
    "A": [
      {"word": "ANT", "emoji": "🐜", "meaning": "चींटी", "meaningRoman": "cheeti", "sentence": "Ants work together in a team."},
      {"word": "AXE", "emoji": "🪓", "meaning": "कुल्हाड़ी", "meaningRoman": "kulhaadi", "sentence": "An axe is used to cut wood."},
      {"word": "APPLE", "emoji": "🍎", "meaning": "सेब", "meaningRoman": "seb", "sentence": "An apple a day keeps the doctor away."}
    ],
    "B": [
      {"word": "BALL", "emoji": "⚽", "meaning": "गेँद", "meaningRoman": "gend", "sentence": "Throw the colorful ball."},
      {"word": "BAT", "emoji": "🏏", "meaning": "बल्ला", "meaningRoman": "balla", "sentence": "Hit the ball with the bat."},
      {"word": "BOY", "emoji": "👦", "meaning": "लड़का", "meaningRoman": "ladka", "sentence": "The boy is reading a book."}
    ],
    "C": [
      {"word": "CAT", "emoji": "🐱", "meaning": "बिल्ली", "meaningRoman": "billee", "sentence": "The cat drinks milk."},
      {"word": "CAR", "emoji": "🚗", "meaning": "गाड़ी", "meaningRoman": "gaadi", "sentence": "Drive the red car safely."},
      {"word": "COW", "emoji": "🐄", "meaning": "गाय", "meaningRoman": "gaay", "sentence": "The cow gives fresh milk."}
    ],
    "D": [
      {"word": "DOG", "emoji": "🐶", "meaning": "कुत्ता", "meaningRoman": "kutta", "sentence": "The dog is wagging its tail."},
      {"word": "DOLL", "emoji": "🪆", "meaning": "गुड़िया", "meaningRoman": "gudiya", "sentence": "I have a cute barbie doll."},
      {"word": "DUCK", "emoji": "🦆", "meaning": "बतख", "meaningRoman": "battakh", "sentence": "Ducks are swimming in the pond."}
    ],
    "E": [
      {"word": "EGG", "emoji": "🥚", "meaning": "अंडा", "meaningRoman": "anda", "sentence": "Eat a healthy egg daily."},
      {"word": "EYE", "emoji": "👁️", "meaning": "आँख", "meaningRoman": "aankh", "sentence": "Look at the stars with your eyes."},
      {"word": "EAR", "emoji": "👂", "meaning": "कान", "meaningRoman": "kaan", "sentence": "Listen to the birds with your ears."}
    ],
    "F": [
      {"word": "FISH", "emoji": "🐟", "meaning": "मछली", "meaningRoman": "machhli", "sentence": "Fish live under water."},
      {"word": "FOX", "emoji": "🦊", "meaning": "लोमड़ी", "meaningRoman": "lomdi", "sentence": "The fox is a clever animal."},
      {"word": "FAN", "emoji": "🪭", "meaning": "पंखा", "meaningRoman": "pankha", "sentence": "Switch on the fan to feel cool."}
    ],
    "G": [
      {"word": "GRAPES", "emoji": "🍇", "meaning": "अंगूर", "meaningRoman": "angoor", "sentence": "Grapes grow in bunches."},
      {"word": "GIRL", "emoji": "👧", "meaning": "लड़की", "meaningRoman": "ladkee", "sentence": "She is a very smart child."},
      {"word": "GOAT", "emoji": "🐐", "meaning": "बकरी", "meaningRoman": "bakree", "sentence": "Goats eat fresh green leaves."}
    ],
    "H": [
      {"word": "HOUSE", "emoji": "🏠", "meaning": "घर", "meaningRoman": "ghar", "sentence": "This is our beautiful house."},
      {"word": "HAT", "emoji": "🎩", "meaning": "टोपी", "meaningRoman": "topee", "sentence": "Wear a sun hat on hot days."},
      {"word": "HEN", "emoji": "🐔", "meaning": "मुर्गी", "meaningRoman": "murgee", "sentence": "The hen laid an egg."}
    ],
    "I": [
      {"word": "ICE", "emoji": "🧊", "meaning": "बर्फ", "meaningRoman": "barf", "sentence": "Ice is very cold and solid."},
      {"word": "INK", "emoji": "✒️", "meaning": "स्याही", "meaningRoman": "syaahi", "sentence": "Fill ink in the fountain pen."},
      {"word": "IRON", "emoji": "🧲", "meaning": "लोहा", "meaningRoman": "loha", "sentence": "Magnets attract iron nails."}
    ],
    "J": [
      {"word": "JUG", "emoji": "🏺", "meaning": "जग", "meaningRoman": "jag", "sentence": "Pour water from the jug."},
      {"word": "JEEP", "emoji": "🚙", "meaning": "जीप", "meaningRoman": "jeep", "sentence": "We went for a ride in the jeep."},
      {"word": "JAM", "emoji": "🍓", "meaning": "जैम", "meaningRoman": "jam", "sentence": "Spread sweet jam on bread."}
    ],
    "K": [
      {"word": "KITE", "emoji": "🪁", "meaning": "पतंग", "meaningRoman": "patang", "sentence": "Kites fly high in the air."},
      {"word": "KEY", "emoji": "🔑", "meaning": "चाबी", "meaningRoman": "chaabee", "sentence": "Use the key to open the lock."},
      {"word": "KING", "emoji": "👑", "meaning": "राजा", "meaningRoman": "raaja", "sentence": "The king lives in a castle."}
    ],
    "L": [
      {"word": "LION", "emoji": "🦁", "meaning": "शेर", "meaningRoman": "sher", "sentence": "The lion is the king of jungle."},
      {"word": "LAMP", "emoji": "💡", "meaning": "दीपक", "meaningRoman": "deepak", "sentence": "Turn on the lamp at night."},
      {"word": "LEAF", "emoji": "🍃", "meaning": "पत्ता", "meaningRoman": "patta", "sentence": "The green leaf fell from tree."}
    ],
    "M": [
      {"word": "MONKEY", "emoji": "🐒", "meaning": "बन्दर", "meaningRoman": "bandar", "sentence": "Monkey is swinging on branches."},
      {"word": "MILK", "emoji": "🥛", "meaning": "दूध", "meaningRoman": "doodh", "sentence": "Drink warm milk for strong bones."},
      {"word": "MOON", "emoji": "🌙", "meaning": "चाँद", "meaningRoman": "chaand", "sentence": "The moon shines bright at night."}
    ],
    "N": [
      {"word": "NEST", "emoji": "🪺", "meaning": "घोंसला", "meaningRoman": "ghonsla", "sentence": "Birds built a nest on tree."},
      {"word": "NET", "emoji": "🕸️", "meaning": "जाल", "meaningRoman": "jaal", "sentence": "Use a net to catch butterflies."},
      {"word": "NUT", "emoji": "🥜", "meaning": "अखरोट", "meaningRoman": "akhrot", "sentence": "Peanuts are a healthy type of nut."}
    ],
    "O": [
      {"word": "ORANGE", "emoji": "🍊", "meaning": "संतरा", "meaningRoman": "santra", "sentence": "Orange is a sweet juicy fruit."},
      {"word": "OWL", "emoji": "🦉", "meaning": "उल्लू", "meaningRoman": "ullu", "sentence": "The owl stays awake all night."},
      {"word": "OX", "emoji": "🐂", "meaning": "बैल", "meaningRoman": "bail", "sentence": "The strong ox plows the field."}
    ],
    "P": [
      {"word": "PENCIL", "emoji": "✏️", "meaning": "पेंसिल", "meaningRoman": "pencil", "sentence": "Sharpen your pencil before writing."},
      {"word": "PEN", "emoji": "🖊️", "meaning": "पेन", "meaningRoman": "pen", "sentence": "The teacher writes with a blue pen."},
      {"word": "PIG", "emoji": "🐷", "meaning": "सुअर", "meaningRoman": "suar", "sentence": "The little pig plays in the mud."}
    ],
    "Q": [
      {"word": "QUEEN", "emoji": "👑", "meaning": "रानी", "meaningRoman": "raanee", "sentence": "The queen wears a shiny crown."},
      {"word": "QUILT", "emoji": "🛏️", "meaning": "रजाई", "meaningRoman": "rajaee", "sentence": "Use a warm quilt in winter."},
      {"word": "QUIZ", "emoji": "❓", "meaning": "प्रश्नोत्तरी", "meaningRoman": "prashnottari", "sentence": "Answer the fun quiz questions."}
    ],
    "R": [
      {"word": "RABBIT", "emoji": "🐇", "meaning": "खरगोश", "meaningRoman": "khargosh", "sentence": "The white rabbit eats carrots."},
      {"word": "ROSE", "emoji": "🌹", "meaning": "गुलाब", "meaningRoman": "gulaab", "sentence": "Rose is a beautiful red flower."},
      {"word": "RING", "emoji": "💍", "meaning": "अंगूठी", "meaningRoman": "angeothee", "sentence": "She wears a gold ring on her finger."}
    ],
    "S": [
      {"word": "SUN", "emoji": "☀️", "meaning": "सूरज", "meaningRoman": "sooraj", "sentence": "The sun rises in the east."},
      {"word": "STAR", "emoji": "⭐", "meaning": "तारा", "meaningRoman": "taara", "sentence": "A tiny star shines in the sky."},
      {"word": "SHIP", "emoji": "🚢", "meaning": "जहाज", "meaningRoman": "jahaaj", "sentence": "The big ship sails on sea."}
    ],
    "T": [
      {"word": "TIGER", "emoji": "🐯", "meaning": "बाघ", "meaningRoman": "baagh", "sentence": "The tiger has black stripes."},
      {"word": "TOY", "emoji": "🧸", "meaning": "खिलौना", "meaningRoman": "khilona", "sentence": "I share my toys with friends."},
      {"word": "TREE", "emoji": "🌳", "meaning": "पेड़", "meaningRoman": "ped", "sentence": "Trees give us cool shade."}
    ],
    "U": [
      {"word": "UMBRELLA", "emoji": "☂️", "meaning": "छाता", "meaningRoman": "chhaata", "sentence": "Open your umbrella in the rain."},
      {"word": "UNCLE", "emoji": "👨", "meaning": "चाचा", "meaningRoman": "chaacha", "sentence": "My uncle bought me a new toy."},
      {"word": "UP", "emoji": "⬆️", "meaning": "ऊपर", "meaningRoman": "oopar", "sentence": "Look up at the blue sky."}
    ],
    "V": [
      {"word": "VAN", "emoji": "🚐", "meaning": "गाड़ी", "meaningRoman": "gaadi", "sentence": "The school van has arrived."},
      {"word": "VIOLIN", "emoji": "🎻", "meaning": "वायलिन", "meaningRoman": "violin", "sentence": "Play sweet music on the violin."},
      {"word": "VASE", "emoji": "🏺", "meaning": "फूलदान", "meaningRoman": "phooladaan", "sentence": "Place fresh flowers in the vase."}
    ],
    "W": [
      {"word": "WATCH", "emoji": "⌚", "meaning": "घड़ी", "meaningRoman": "ghadee", "sentence": "Check the time on your watch."},
      {"word": "WATER", "emoji": "💧", "meaning": "पानी", "meaningRoman": "paanee", "sentence": "Water is essential for life."},
      {"word": "WEB", "emoji": "🕸️", "meaning": "जाल", "meaningRoman": "jaal", "sentence": "The spider spun a sticky web."}
    ],
    "X": [
      {"word": "BOX", "emoji": "📦", "meaning": "डिब्बा", "meaningRoman": "dibba", "sentence": "Put toys inside the cardboard box."},
      {"word": "FOX", "emoji": "🦊", "meaning": "लोमड़ी", "meaningRoman": "lomdi", "sentence": "The red fox has a bushy tail."},
      {"word": "X-RAY", "emoji": "🩻", "meaning": "एक्स-रे", "meaningRoman": "x-ray", "sentence": "The doctor took an X-ray of my hand."}
    ],
    "Y": [
      {"word": "YAK", "emoji": "🐂", "meaning": "याक", "meaningRoman": "yak", "sentence": "The yak lives in snowy mountains."},
      {"word": "YACHT", "emoji": "⛵", "meaning": "नाव", "meaningRoman": "naav", "sentence": "The white yacht sails smoothly."},
      {"word": "YOYO", "emoji": "🪀", "meaning": "योयो", "meaningRoman": "yoyo", "sentence": "Spin the yoyo up and down."}
    ],
    "Z": [
      {"word": "ZEBRA", "emoji": "🦓", "meaning": "जेब्रा", "meaningRoman": "zebra", "sentence": "The zebra crossed the road."},
      {"word": "ZIP", "emoji": "🤐", "meaning": "चैन", "meaningRoman": "chain", "sentence": "Close the zip of your bag."},
      {"word": "ZOO", "emoji": "🦁", "meaning": "चिड़ियाघर", "meaningRoman": "chidiyaaghar", "sentence": "We saw many wild animals at the zoo."}
    ]
  };
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
  void _speakText(String text, {String phonetic = ""}) {
    if (kIsWeb) {
      try {
        final cleanText = text.replaceAll("'", "\\'").replaceAll("\n", " ");
        final cleanPhonetic = phonetic.replaceAll("'", "\\'").replaceAll("\n", " ");
        final jsCode = """
          if ('speechSynthesis' in window) {
            
            function setVoiceAndSpeak() {
              var voicesList = window.speechSynthesis.getVoices();
              
              var textParts = '$cleanText'.split('|');
              var phoneticParts = '$cleanPhonetic'.split('|');
              
              // Queue each part in sequence
              for (var idx = 0; idx < textParts.length; idx++) {
                var pText = textParts[idx].trim();
                var pPhonetic = phoneticParts[idx] ? phoneticParts[idx].trim() : '';
                if (!pText) continue;
                
                var isPartHindi = /[\\u0900-\\u097F]/.test(pText);
                var langFilter = isPartHindi ? 'hi' : 'en';
                
                var matchingLangVoices = voicesList.filter(function(v) {
                  return v.lang.toLowerCase().indexOf('hi') !== -1;
                });
                
                var msg = new SpeechSynthesisUtterance();
                
                if (isPartHindi && matchingLangVoices.length === 0 && pPhonetic !== '') {
                  msg.text = pPhonetic.toLowerCase();
                  msg.lang = 'en-US';
                  langFilter = 'en';
                } else {
                  msg.text = pText;
                  msg.lang = isPartHindi ? 'hi-IN' : 'en-US';
                }
                
                var gender = '$_selectedVoiceGender';
                var voice = null;
                
                function getVoiceGender(v) {
                  var name = v.name.toLowerCase();
                  if (name.indexOf('male') !== -1 || 
                      name.indexOf('david') !== -1 || 
                      name.indexOf('ravi') !== -1 || 
                      name.indexOf('-hic') !== -1 || 
                      name.indexOf('-hif') !== -1 || 
                      name.indexOf('-hia') !== -1 || 
                      name.indexOf('-iom') !== -1 || 
                      name.indexOf('-iog') !== -1 || 
                      name.indexOf('-iol') !== -1 || 
                      name.indexOf('-iob') !== -1 || 
                      name.indexOf('guy') !== -1 || 
                      name.indexOf('boy') !== -1 || 
                      name.indexOf('man') !== -1) {
                    return 'male';
                  }
                  return 'female';
                }
                
                var candidateLangVoices = voicesList.filter(function(v) {
                  return v.lang.toLowerCase().indexOf(langFilter) !== -1;
                });
                
                var nonGoogleVoices = candidateLangVoices.filter(function(v) {
                  return v.name.toLowerCase().indexOf('google') === -1;
                });
                var candidateVoices = nonGoogleVoices.length > 0 ? nonGoogleVoices : candidateLangVoices;
                
                var localVoices = candidateVoices.filter(function(v) {
                  return v.localService === true;
                });
                
                var searchSet = localVoices.length > 0 ? localVoices : candidateVoices;
                
                for (var i = 0; i < searchSet.length; i++) {
                  if (getVoiceGender(searchSet[i]) === gender) {
                    voice = searchSet[i];
                    break;
                  }
                }
                
                if (!voice) {
                  for (var i = 0; i < voicesList.length; i++) {
                    if (getVoiceGender(voicesList[i]) === gender && voicesList[i].lang.toLowerCase().indexOf(langFilter) !== -1) {
                      voice = voicesList[i];
                      break;
                    }
                  }
                }
                
                if (!voice && searchSet.length > 0) {
                  voice = searchSet[0];
                }
                
                if (voice) {
                  var voiceGender = getVoiceGender(voice);
                  if (isPartHindi || voiceGender === gender) {
                    msg.voice = voice;
                  }
                }
                
                if (gender === 'female') {
                  var isVoiceMale = voice ? (getVoiceGender(voice) === 'male') : false;
                  msg.pitch = isVoiceMale ? 1.55 : 1.35;
                } else {
                  var isVoiceFemale = voice ? (getVoiceGender(voice) === 'female') : true;
                  msg.pitch = isVoiceFemale ? 0.45 : 0.72;
                }
                
                msg.rate = isPartHindi ? 0.72 : 0.8;
                msg.volume = 1.0;
                
                window.speechSynthesis.speak(msg);
              }
            }
            
            function triggerSpeech() {
              if (window.speechSynthesis.getVoices().length > 0) {
                setVoiceAndSpeak();
              } else {
                window.speechSynthesis.onvoiceschanged = setVoiceAndSpeak;
              }
            }
            
            if (window.speechSynthesis.speaking) {
              window.speechSynthesis.cancel();
              setTimeout(triggerSpeech, 50);
            } else {
              triggerSpeech();
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
        final cleanText = lyrics.replaceAll("'", "\\'").replaceAll("\r", "").replaceAll("\n", "\\n");
        final jsCode = """
          if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            
            // Wait 50ms to allow cleanly canceling channels
            setTimeout(function() {
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
                
                // Add natural musical comma commas to force expressive pitch shifts and pauses!
                var musicalLine = line
                  .replace(/twinkle/gi, 'twinkle,')
                  .replace(/star/gi, 'star!')
                  .replace(/johny/gi, 'johny,')
                  .replace(/papa/gi, 'papa?')
                  .replace(/humpty/gi, 'humpty,')
                  .replace(/dumpty/gi, 'dumpty!')
                  .replace(/wall/gi, 'wall,')
                  .replace(/fall/gi, 'fall!');
                  
                var msg = new SpeechSynthesisUtterance(musicalLine);
                window.activeUtterance = msg;
                msg.lang = 'en-US';
                
                function setSongVoiceAndSpeak() {
                  var voices = window.speechSynthesis.getVoices();
                  var voice = null;
                  
                  function getVoiceGender(v) {
                    var name = v.name.toLowerCase();
                    if (name.indexOf('male') !== -1 || name.indexOf('david') !== -1 || name.indexOf('ravi') !== -1 || name.indexOf('-iom') !== -1 || name.indexOf('-iog') !== -1 || name.indexOf('-iol') !== -1) {
                      return 'male';
                    }
                    return 'female';
                  }
                  
                  var langVoices = voices.filter(function(v) {
                    return v.lang.toLowerCase().indexOf('en') !== -1;
                  });
                  
                  var localVoices = langVoices.filter(function(v) {
                    return v.localService === true;
                  });
                  
                  var searchSet = localVoices.length > 0 ? localVoices : langVoices;
                  
                  for (var i = 0; i < searchSet.length; i++) {
                    if (getVoiceGender(searchSet[i]) === gender) {
                      voice = searchSet[i];
                      break;
                    }
                  }
                  
                  if (voice) {
                    var voiceGender = getVoiceGender(voice);
                    if (voiceGender !== gender) {
                      // Drop binding to force pitch shift fallback
                    } else {
                      msg.voice = voice;
                    }
                  }
                  
                  // Rhythmic, highly-modulated rising and falling singing pitch variations!
                  if (gender === 'female') {
                    var isVoiceMale = voice ? (getVoiceGender(voice) === 'male') : false;
                    var basePitch = isVoiceMale ? 1.55 : 1.35;
                    var modulation = [0.12, 0.38, -0.22, 0.28];
                    msg.pitch = basePitch + (modulation[idx % 4]);
                  } else {
                    var isVoiceFemale = voice ? (getVoiceGender(voice) === 'female') : true;
                    var basePitch = isVoiceFemale ? 0.45 : 0.72;
                    var modulation = [0.08, 0.28, -0.16, 0.22];
                    msg.pitch = basePitch + (modulation[idx % 4]);
                  }
                  
                  msg.rate = 0.88; // Perfect lively nursery rhythm speed!
                  msg.volume = 1.0;
                  
                  msg.onend = function() {
                    idx++;
                    setTimeout(speakLine, 350); // Pause between lines
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
            }, 50);
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
  String getEmojiUrl(String emoji, {String word = "", String letter = ""}) {
    if (emoji.isEmpty) return "";
    
    // Hindi Varnmala static mapping to real photos and local assets
    if (letter.isNotEmpty && _realVarnmalaImages.containsKey(letter)) {
      return _realVarnmalaImages[letter]!;
    }
    
    // Hardcoded fallback checks for custom words
    if (emoji == "🍒" || emoji.contains("🍒") || word == "अनार" || word == "ANAR" || word.toLowerCase() == "anar") {
      return "assets/images/anar.jpg";
    }
    if (emoji == "🏺" || word == "Jug" || word == "JUG" || emoji.contains("🏺")) {
      return "https://upload.wikimedia.org/wikipedia/commons/2/23/Pitcher_Jug_%28PSF%29.png";
    }
    
    // Find mapped Fluent 3D Emoji
    final path = _emoji3dPaths[emoji];
    if (path != null) {
      final parts = path.split("/");
      final folder = parts[0];
      final file = parts[1];
      final encodedFolder = Uri.encodeComponent(folder);
      final encodedFile = Uri.encodeComponent(file);
      return "https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/$encodedFolder/3D/${encodedFile}_3d.png";
    }
    
    // Fallback to Google Noto Emoji
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
  Widget _buildEmojiImage(String emoji, {double size = 48, String word = "", String letter = "", FilterQuality filterQuality = FilterQuality.medium}) {
    final url = getEmojiUrl(emoji, word: word, letter: letter);
    if (url.isEmpty) {
      return Text(emoji, style: TextStyle(fontSize: size));
    }
    if (url.startsWith("assets/")) {
      return Image.asset(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: filterQuality,
        errorBuilder: (c, o, s) => Text(emoji, style: TextStyle(fontSize: size)),
      );
    }
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: filterQuality,
      errorBuilder: (c, o, s) => Text(emoji, style: TextStyle(fontSize: size)),
    );
  }
  Widget _buildTabBlock(int index, String title, Color baseColor, Color shadowColor, Color textColor) {
    final bool isSelected = _tabController.index == index;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : textColor)
              : (isDark ? AppColors.darkSurface : baseColor),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : textColor)
                : (isDark ? Colors.white10 : baseColor.withOpacity(0.5)),
            width: 1.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: isSelected
                        ? textColor.withOpacity(0.3)
                        : shadowColor,
                    offset: isSelected ? const Offset(0, 2) : const Offset(0, 5),
                    blurRadius: isSelected ? 2 : 0,
                  ),
                ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white70 : textColor),
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
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
  // Show detailed popup card with tap zoomable full screen image option
  void _showCardDialog(String title, String subtitle, String emoji, {String word = "", String letter = "", String english = ""}) {
    _speakText("$title. $subtitle", phonetic: english);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // Interactive pinch zoomable full screen dialog
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.black,
                    insetPadding: const EdgeInsets.all(0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Center(
                            child: _buildEmojiImage(emoji, size: MediaQuery.of(context).size.width * 0.95, word: word, letter: letter, filterQuality: FilterQuality.high),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildEmojiImage(emoji, size: 140, word: word, letter: letter, filterQuality: FilterQuality.high),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.zoom_in, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            const Text(
              "(Tap image to view full screen 🔍)",
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
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
    final playroomBgColor = isDark ? Colors.grey[900] : const Color(0xFFFFFBEF); // More colorful warm playroom background
    final blockBaseColor = isDark ? AppColors.darkSurface : Colors.white;
    final blockShadowColor = isDark ? Colors.black54 : const Color(0xFFDDD7C8);
    return Scaffold(
      backgroundColor: playroomBgColor,
      appBar: AppBar(
        title: const Text('Study with Play 🎈', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedVoiceGender = _selectedVoiceGender == 'female' ? 'male' : 'female';
              });
              _speakText("Voice changed!");
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: _selectedVoiceGender == 'female'
                    ? const LinearGradient(colors: [Color(0xFFEC407A), Color(0xFFD81B60)])
                    : const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (_selectedVoiceGender == 'female' ? const Color(0xFFD81B60) : const Color(0xFF1E88E5)).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _selectedVoiceGender == 'female' ? Icons.woman : Icons.man,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _selectedVoiceGender == 'female' ? 'Female 👩' : 'Male 👨',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Styled 3D Playroom Tab Shelf (Wrap layout for 100% visibility on all screens)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildTabBlock(0, 'Rhymes 🎵', const Color(0xFFFFECEF), const Color(0xFFFFB3C1), const Color(0xFFC71585)),
                _buildTabBlock(1, 'Numbers 🔟', const Color(0xFFE8F0FE), const Color(0xFF90CAF9), const Color(0xFF0D47A1)),
                _buildTabBlock(2, 'ABCD 🔠', const Color(0xFFFFFDE7), const Color(0xFFFFF59D), const Color(0xFFF57F17)),
                _buildTabBlock(3, 'Varnmala ✍️', const Color(0xFFE8F5E9), const Color(0xFFA5D6A7), const Color(0xFF1B5E20)),
                _buildTabBlock(4, 'Easy Words 🐱', const Color(0xFFF3E5F5), const Color(0xFFCE93D8), const Color(0xFF4A148C)),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // RHYMES TAB (Song singing rhythm mode)
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                            _buildEmojiImage(_rhymes[_activeRhymeIndex]["emoji"]!, size: 90, filterQuality: FilterQuality.high),
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
                // NUMBERS 1-100 TAB (5 columns in a row, large text size, 3D embossed look)
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                          crossAxisCount: 5, // Exactly 5 columns in a row for large cell size on phones!
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          final num = index + 1;
                          final isSelected = _countingStars == num;
                          
                          final baseColor = isSelected ? Colors.deepOrange : blockBaseColor;
                          final shadowColor = isSelected ? Colors.red[900]! : blockShadowColor;
                          final textColor = isSelected ? Colors.white : AppColors.primaryBlue;
                          return _build3DBlock(
                            index: index,
                            section: "numbers",
                            baseColor: baseColor,
                            shadowColor: shadowColor,
                            shadowDepth: 6.0,
                            onTap: () {
                              setState(() {
                                _countingStars = num;
                              });
                              _speakText(num.toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '$num',
                                  style: TextStyle(
                                    fontSize: 26, // Large bold numbers
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
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
                  physics: const BouncingScrollPhysics(),
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
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildEmojiImage(item["emoji"]!, size: 54, word: item["word"]!, filterQuality: FilterQuality.high),
                        ],
                      ),
                    );
                  },
                ),
                // HINDI VARNMALA TAB (Varnmala using real photos only, tall cards, scaling prevent overlaps!)
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                          childAspectRatio: 0.7, // Taller cards to prevent vertical layout overlaps!
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
                              letter: item["letter"]!,
                              english: item["english"]!,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown, // Auto scales text + image together to fit card
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item["letter"]!,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildEmojiImage(item["emoji"]!, size: 40, word: item["word"]!, letter: item["letter"]!, filterQuality: FilterQuality.high),
                                  ],
                                ),
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
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7, // Taller cards to prevent vertical layout overlaps!
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
                              letter: item["letter"]!,
                              english: item["english"]!,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown, // Auto scales text + image together to fit card
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item["letter"]!,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildEmojiImage(item["emoji"]!, size: 40, word: item["word"]!, letter: item["letter"]!, filterQuality: FilterQuality.high),
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
                // EASY WORDS TAB (A-Z with Hindi translation pronunciation matlabs)
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
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
                                      onTap: () {
                                        final cleanWord = item["word"]!.toLowerCase();
                                        final cleanMeaning = item["meaning"]!.toLowerCase();
                                        _speakText("$letter. $cleanWord. | ${item["word"]} का मतलब ${item["meaning"]} है। | ${item["sentence"]}",phonetic: "${letter.toLowerCase()}. ${letter.toLowerCase()} for $cleanWord. | ${item["word"]} ka matlab ${item["meaningRoman"]} hai. | ${item["sentence"]!.toLowerCase()}");
                                        );
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                        child: Column(
                                          children: [
                                            _buildEmojiImage(item["emoji"]!, size: 40, word: item["word"]!, filterQuality: FilterQuality.high),
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