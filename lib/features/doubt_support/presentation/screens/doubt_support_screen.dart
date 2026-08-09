import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/js.dart' as js;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';

class MessageBubble {
  final String text;
  final bool isUser;
  final DateTime time;

  MessageBubble({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class DoubtSupportScreen extends StatefulWidget {
  const DoubtSupportScreen({super.key});

  @override
  State<DoubtSupportScreen> createState() => _DoubtSupportScreenState();
}

class _DoubtSupportScreenState extends State<DoubtSupportScreen> {
  final List<MessageBubble> _messages = [
    MessageBubble(
      text: "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. Ask me anything related to your homework, PDFs, or computer courses!",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  String _selectedLanguage = 'English'; // 'English' or 'Hindi'
  String? _currentlySpeakingText;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      js.context['onSpeechEnd'] = () {
        if (mounted) {
          setState(() {
            _currentlySpeakingText = null;
          });
        }
      };
    }
  }

  @override
  void dispose() {
    _stopTextSpeech();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _speakText(String text) {
    if (kIsWeb) {
      try {
        final cleanText = text.replaceAll("'", "\\'").replaceAll("\n", " ");
        final jsCode = """
          if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            
            var msg = new SpeechSynthesisUtterance();
            msg.text = '$cleanText';
            
            // Detect if text contains Hindi characters
            var isHindi = /[\\u0900-\\u097F]/.test('$cleanText');
            msg.lang = isHindi ? 'hi-IN' : 'en-US';
            
            // Setup voice parameters
            msg.rate = isHindi ? 0.78 : 0.85;
            msg.pitch = isHindi ? 1.05 : 1.15;
            msg.volume = 1.0;
            
            msg.onend = function() {
              if (window.onSpeechEnd) {
                window.onSpeechEnd();
              }
            };
            msg.onerror = function() {
              if (window.onSpeechEnd) {
                window.onSpeechEnd();
              }
            };
            
            window.speechSynthesis.speak(msg);
          }
        """;
        js.context.callMethod('eval', [jsCode]);
      } catch (e) {
        debugPrint("Speech synthesis error: $e");
      }
    }
  }

  void _stopTextSpeech() {
    if (kIsWeb) {
      try {
        js.context.callMethod('eval', ["""
          if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
          }
        """]);
      } catch (e) {
        debugPrint("Speech stop error: $e");
      }
    }
  }

  void _speak(String text) {
    setState(() {
      _currentlySpeakingText = text;
    });
    _speakText(text);
  }

  void _stopSpeech() {
    setState(() {
      _currentlySpeakingText = null;
    });
    _stopTextSpeech();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(MessageBubble(text: text, isUser: true, time: DateTime.now()));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      String aiResponse = "";
      final query = text.toLowerCase();
      final isHindi = _selectedLanguage == 'Hindi';
      
      if (query.contains("twinkle") || query.contains("rhyme") || query.contains("johny") || query.contains("humpty")) {
        if (isHindi) {
          aiResponse = "यहाँ बच्चों के लिए प्रसिद्ध बाल कविता (Rhyme) है 🎵:\n\n'ट्विंकल ट्विंकल लिटिल स्टार,\nहाउ आई वंडर व्हाट यू आर!\nअप अबव द वर्ल्ड सो हाई,\nलाइक ए डायमंड इन द स्काई।'\n\nसंगीत के साथ सुनने के लिए होम स्क्रीन पर 'Play Study' खोलें!";
        } else {
          aiResponse = "Here is a classic Baby Rhyme for children 🎵:\n\n'Twinkle, twinkle, little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky.'\n\nYou can play it like a song with voice synthesis in the 'Play Study' tab on your Home screen!";
        }
      } else if (query.contains("counting") || query.contains("number") || query.contains("counting number")) {
        if (isHindi) {
          aiResponse = "आइए मनोरंजक खेल शैली में गिनती सीखें 🔟:\n\n१ (एक) 🌟\n२ (दो) 🌟🌟\n३ (तीन) 🌟🌟🌟\n४ (चार) 🌟🌟🌟🌟\n५ (पाँच) 🌟🌟🌟🌟🌟\n\nसितारों को देखने और गिनने के लिए 'Play Study' section खोलें!";
        } else {
          aiResponse = "Let's count numbers with fun playing style 🔟:\n\n1 (One) 🌟\n2 (Two) 🌟🌟\n3 (Three) 🌟🌟🌟\n4 (Four) 🌟🌟🌟🌟\n5 (Five) 🌟🌟🌟🌟🌟\n\nOpen the 'Play Study' page on the dashboard to tap and see counting stars anims!";
        }
      } else if (query.contains("alphabet") || query.contains("abcd")) {
        if (isHindi) {
          aiResponse = "आइए अंग्रेजी वर्णमाला सीखें 🔠:\n\nA से Apple (सेब) 🍎\nB से Ball (गेंद) ⚽\nC से Cat (बिल्ली) 🐱\nD से Dog (कुत्ता) 🐶\n\nआप ऐप के 'Play Study' सेक्शन में A से Z तक के कार्ड देख सकते हैं!";
        } else {
          aiResponse = "Let's learn English Alphabets 🔠:\n\nA for Apple 🍎\nB for Ball ⚽\nC for Cat 🐱\nD for Dog 🐶\n\nYou can explore A to Z cards in the 'Play Study' section of the app!";
        }
      } else if (query.contains("swar") || query.contains("vyanjan") || query.contains("varnmala")) {
        if (isHindi) {
          aiResponse = "आइए हिंदी वर्णमाला सीखें ✍️:\n\nस्वर: अ (अनार 🍒), आ (आम 🥭), इ (इमली 🫒)...\nव्यंजन: क (कबूतर 🕊️), ख (खरगोश 🐇), ग (गमला 🪴)...\n\nबच्चों के सीखने के लिए 'Play Study' section में Varnmala tab open करें!";
        } else {
          aiResponse = "Let's learn Hindi Varnmala ✍️:\n\nVowels: अ (Anar 🍒), आ (Aam 🥭), इ (Imli 🫒)...\nConsonants: क (Kabootar 🕊️), kh (Khargosh 🐇), ग (Gamla 🪴)...\n\nOpen the 'Play Study' tab on your Home screen to hear correct pronunciations!";
        }
      } else if (query.contains("fraction")) {
        if (isHindi) {
          aiResponse = "गणित की शंका हल! 🔢 भिन्न (Fraction) एक संपूर्ण के हिस्से को दर्शाता है (अंश/हर)। उदाहरण के लिए, 3/4 का अर्थ है 4 बराबर भागों में से 3 भाग। समान हर वाले भिन्न को सीधे अंश जोड़कर जोड़ा जाता है (उदा. 1/5 + 2/5 = 3/5)।";
        } else {
          aiResponse = "Math doubt solved! 🔢 A fraction represents a part of a whole (Numerator/Denominator). For example, 3/4 means 3 parts out of 4 equal parts. To add fractions with common denominators, add their numerators directly (e.g., 1/5 + 2/5 = 3/5).";
        }
      } else if (query.contains("math") || query.contains("sum") || query.contains("add") || query.contains("multiply") || query.contains("divide") || query.contains("algebra") || query.contains("geometry")) {
        if (isHindi) {
          aiResponse = "गणित शिक्षक गाइड (कक्षा 1-10) 📐:\n1. अंकगणित: BODMAS नियम गणना का क्रम तय करता है (कोष्ठक, क्रम, भाग, गुणा, जोड़, घटाव)।\n2. ज्यामिति: आयत की परिधि = 2*(लंबाई + चौड़ाई)। वृत्त का क्षेत्रफल = π * r^2。\n3. बीजगणित: x का मान निकालने के लिए चर पदों को एक तरफ और अचर को दूसरी तरफ रखें (उदा: 2x = 10 => x = 5)।";
        } else {
          aiResponse = "Mathematics Tutor Guide (Standard 1-10) 📐:\n1. Arithmetic: BODMAS rule determines order of operations (Brackets, Order, Division, Multiplication, Addition, Subtraction).\n2. Geometry: Perimeter of rectangle = 2*(length + width). Area of circle = π * r^2.\n3. Algebra: Solve for x by keeping variable terms on one side and constants on other (e.g. 2x = 10 => x = 5).";
        }
      } else if (query.contains("physics") || query.contains("gravity") || query.contains("force") || query.contains("motion") || query.contains("light") || query.contains("electricity")) {
        if (isHindi) {
          aiResponse = "भौतिकी शिक्षक गाइड (कक्षा 1-10) ⚡:\n1. बल (Force): किसी वस्तु पर लगाया गया धक्का या खिंचाव (F = द्रव्यमान * त्वरण)।\n2. गुरुत्वाकर्षण: वह आकर्षक बल जो वस्तुओं को नीचे खींचता है (त्वरण g ≈ 9.8 m/s^2)।\n3. प्रकाश: सीधी रेखा में यात्रा करता है; परावर्तन और अपवर्तन के नियमों का पालन करता है।";
        } else {
          aiResponse = "Physics Tutor Explanation (Standard 1-10) ⚡:\n1. Force: A push or pull acting upon an object (F = mass * acceleration).\n2. Gravity: An attractive force pulling objects down (acceleration g ≈ 9.8 m/s^2).\n3. Light: Travel in straight lines; reflects off smooth surfaces and refracts when changing mediums.";
        }
      } else if (query.contains("chemistry") || query.contains("acid") || query.contains("base") || query.contains("element") || query.contains("atom") || query.contains("molecule")) {
        if (isHindi) {
          aiResponse = "रसायन विज्ञान शिक्षक गाइड (कक्षा 1-10) 🧪:\n1. परमाणु (Atom): तत्वों की मूल इकाई, जिसमें प्रोटॉन, न्यूट्रॉन और इलेक्ट्रॉन होते हैं।\n2. अणु (Molecule): एक साथ बंधे परमाणुओं के समूह (उदा: पानी H2O है)।\n3. अम्ल और क्षार: अम्ल का pH < 7 होता है (खट्टा), क्षार का pH > 7 होता है (कड़वा/चिकना)। उदासीन pH = 7 है।";
        } else {
          aiResponse = "Chemistry Tutor Explanation (Standard 1-10) 🧪:\n1. Atoms: The basic unit of chemical elements, consisting of protons, neutrons, and electrons.\n2. Molecules: Groups of atoms bonded together (e.g., Water is H2O).\n3. Acids & Bases: Acids have pH < 7 (sour, e.g. lemon juice), Bases have pH > 7 (bitter/slippery, e.g. soap). Neutral is pH = 7.";
        }
      } else if (query.contains("biology") || query.contains("cell") || query.contains("plant") || query.contains("photosynthesis") || query.contains("human body")) {
        if (isHindi) {
          aiResponse = "जीव विज्ञान शिक्षक गाइड (कक्षा 1-10) 🧬:\n1. कोशिका (Cell): जीवन की मूल संरचनात्मक इकाई। जंतु कोशिका में झिल्ली होती है, पादप कोशिका में अतिरिक्त कोशिका भित्ति होती है।\n2. प्रकाश संश्लेषण (Photosynthesis): पौधे धूप, कार्बन डाइऑक्साइड और पानी का उपयोग करके ग्लूकोज का निर्माण करते हैं और ऑक्सीजन छोड़ते हैं।\n3. परिसंचरण: हृदय फेफड़ों से ऑक्सीजन युक्त रक्त को शरीर के अंगों में पंप करता है।";
        } else {
          aiResponse = "Biology Tutor Explanation (Standard 1-10) 🧬:\n1. Cell: Basic structural and functional unit of life. Animal cells have membrane, Plant cells have extra cell wall.\n2. Photosynthesis: Plants use chlorophyll to absorb sunlight, carbon dioxide, and water to manufacture glucose and release oxygen.\n3. Circulation: Heart pumps oxygenated blood from lungs to body organs.";
        }
      } else if (query.contains("science")) {
        if (isHindi) {
          aiResponse = "विज्ञान ट्यूटर हब (कक्षा 1-10) 🔬:\nविज्ञान को विभाजित किया गया है:\n1. भौतिकी: ऊर्जा, बल, प्रकाश और गति का अध्ययन।\n2. रसायन विज्ञान: पदार्थ, तत्वों, प्रतिक्रियाओं और पीएच पैमाने का अध्ययन।\n3. जीव विज्ञान: कोशिकाओं, जीवन चक्रों और पारिस्थितिक तंत्र का अध्ययन।\nमुझे बताएं कि आप किस विषय के बारे में सीखना चाहते हैं!";
        } else {
          aiResponse = "Science Tutor Hub (Standard 1-10) 🔬:\nScience is divided into:\n1. Physics: Study of energy, force, light, and motion.\n2. Chemistry: Study of matter, elements, reactions, and pH scale.\n3. Biology: Study of cells, plant/human body life cycles, and ecosystems.\nTell me which topic you want to learn about!";
        }
      } else if (query.contains("economics") || query.contains("money") || query.contains("demand") || query.contains("supply") || query.contains("market")) {
        if (isHindi) {
          aiResponse = "अर्थशास्त्र शिक्षक गाइड (कक्षा 9-10) 📊:\n1. मांग और आपूर्ति: मांग का नियम बताता है कि उच्च मूल्य कम मांग की ओर ले जाते हैं। आपूर्ति का नियम बताता है कि उच्च मूल्य उच्च आपूर्ति की ओर ले जाते हैं।\n2. भारतीय अर्थव्यवस्था के क्षेत्र: प्राथमिक (कृषि), द्वितीयक (विनिर्माण), तृतीयक (सेवाएं/आईटी)।";
        } else {
          aiResponse = "Economics Tutor explanation (Standard 9-10) 📊:\n1. Supply and Demand: Law of Demand states that higher prices lead to lower demand. Law of Supply states that higher prices lead to higher supply.\n2. Sectors of Indian Economy: Primary (Agriculture), Secondary (Manufacturing), Tertiary (Services/IT).";
        }
      } else if (query.contains("history") || query.contains("gandhi") || query.contains("independence") || query.contains("harappa") || query.contains("revolution")) {
        if (isHindi) {
          aiResponse = "इतिहास ट्यूटर गाइड (कक्षा 1-10) 📜:\n1. हड़प्पा सभ्यता: सिंधु नदी घाटी के पास स्थित एक प्राचीन कांस्य युगीन नगरीय संस्कृति (ईंट के घर, जल निकासी व्यवस्था)।\n2. भारतीय स्वतंत्रता: महात्मा गांधी (अहिंसा) और सुभाष चंद्र बोस आदि के नेतृत्व में 15 अगस्त 1947 को भारत को स्वतंत्रता मिली।";
        } else {
          aiResponse = "History Tutor Guide (Standard 1-10) 📜:\n1. Harappan Civilization: An ancient Bronze Age urban culture located near the Indus River basin (famous for brick houses, grid planning, drainage).\n2. Indian Independence: India gained freedom from British rule on 15 August 1947, led by freedom struggles of Mahatma Gandhi (Non-Violence), Subhash Chandra Bose, etc.";
        }
      } else if (query.contains("geography") || query.contains("earth") || query.contains("map") || query.contains("continent") || query.contains("river") || query.contains("soil")) {
        if (isHindi) {
          aiResponse = "भूगोल शिक्षक गाइड (कक्षा 1-10) 🌍:\n1. पृथ्वी की संरचना: कोर (सबसे भीतरी), मेंटल (मध्यम सिलिकेट परत), क्रस्ट (बाहरी ठोस सतह जहाँ हम रहते हैं)।\n2. नदियाँ और महासागर: नदियाँ पहाड़ों से समुद्र की ओर बहती हैं। महासागर पृथ्वी की सतह के 71% भाग को कवर करते हैं।\n3. वायुमंडल: क्षोभमंडल (जहाँ मौसम की घटनाएं होती हैं), समताप मंडल (ओजोन परत होती है)।";
        } else {
          aiResponse = "Geography Tutor explanation (Standard 1-10) 🌍:\n1. Earth Structure: Core (innermost), Mantle (middle silicate layer), Crust (outer solid surface where we live).\n2. Rivers & Oceans: Rivers flow from mountains down to seas. Oceans cover 71% of Earth surface.\n3. Atmosphere: Troposphere (where weather occurs), Stratosphere (holds ozone layer), Mesosphere.";
        }
      } else if (query.contains("english") || query.contains("grammar") || query.contains("noun") || query.contains("verb") || query.contains("tense")) {
        if (isHindi) {
          aiResponse = "अंग्रेजी व्याकरण गाइड (कक्षा 1-10) 📝:\n1. संज्ञा (Noun): किसी व्यक्ति, स्थान, या वस्तु का नाम (उदा. अमन, पटना, किताब)।\n2. क्रिया (Verb): किए गए कार्य (उदा. लिखना, दौड़ना, पढ़ना)।\n3. काल (Tense): वर्तमान (I study), भूतकाल (I studied), भविष्य काल (I will study)।";
        } else {
          aiResponse = "English Grammar Guide (Standard 1-10) 📝:\n1. Noun: Name of a person, place, thing, or idea (e.g. Aman, Patna, book).\n2. Verb: Actions performed (e.g. write, run, study).\n3. Tenses: Present (I study), Past (I studied), Future (I will study).";
        }
      } else if (query.contains("hindi") || query.contains("vyakaran") || query.contains("sangya") || query.contains("kriya")) {
        aiResponse = "हिंदी व्याकरण सहायक (कक्षा 1-10) ✍️:\n1. संज्ञा (Noun): किसी व्यक्ति, स्थान, या वस्तु के नाम को संज्ञा कहते हैं (जैसे - राम, पटना, किताब)।\n2. क्रिया (Verb): जिस शब्द से किसी काम का करना या होना पाया जाए, उसे क्रिया कहते हैं (जैसे - लिखना, दौड़ना)।\n3. सर्वनाम (Pronoun): संज्ञा के स्थान पर प्रयुक्त होने वाले शब्द (जैसे - वह, तुम, मैं)।";
      } else if (query.contains("vlookup") || query.contains("xlookup") || query.contains("pivot") || query.contains("excel") || query.contains("spreadsheet") || query.contains("formula")) {
        if (isHindi) {
          aiResponse = "एक्सेल और स्प्रेडशीट गाइड (Basic to Advanced) 📊:\n"
              "1. बेसिक फॉर्मूले: `=SUM(A1:A10)` (योग), `=AVERAGE(B1:B10)` (औसत), `=COUNT(C1:C10)` (गिनती)।\n"
              "2. VLOOKUP: लंबवत डेटा खोजने के लिए: `=VLOOKUP(lookup_val, table_range, col_index, FALSE)`।\n"
              "3. XLOOKUP (Advanced): आधुनिक और सुरक्षित फॉर्मूला जो किसी भी दिशा में खोज सकता है: `=XLOOKUP(lookup_val, lookup_range, return_range)`।\n"
              "4. Pivot Tables (पिवट टेबल): बड़े डेटा सेट को तुरंत समेटने (summarize) और वर्गीकृत करने के लिए 'Insert > PivotTable' का उपयोग करें।\n"
              "5. सेल संदर्भ: \$A\$1 (Absolute reference) जो फॉर्मूला ड्रैग करने पर बदलता नहीं है।";
        } else {
          aiResponse = "MS Excel & Spreadsheet Guide (Basic to Advanced) 📊:\n"
              "1. Basic Formulas: `=SUM(A1:A10)` (adds numbers), `=AVERAGE(B1:B10)` (average), `=COUNT(C1:C10)` (counts entries).\n"
              "2. VLOOKUP: Searches vertically: `=VLOOKUP(lookup_value, table_array, col_index, FALSE)`.\n"
              "3. XLOOKUP (Advanced): Modern lookup that works in any direction: `=XLOOKUP(lookup_val, lookup_range, return_range)`.\n"
              "4. Pivot Tables: An interactive feature to instantly summarize, filter, and analyze massive volumes of raw data via 'Insert > PivotTable'.\n"
              "5. Cell Referencing: \$A\$1 represents an Absolute reference that remains locked when dragging formulas.";
        }
      } else if (query.contains("mail merge") || query.contains("macro") || query.contains("word") || query.contains("typing") || query.contains("document") || query.contains("format")) {
        if (isHindi) {
          aiResponse = "एमएस वर्ड गाइड (Basic to Advanced) 📄:\n"
              "1. शॉर्टकट: Ctrl+C (कॉपी), Ctrl+V (पेस्ट), Ctrl+B (बोल्ड), Ctrl+I (इटैलिक), Ctrl+U (अंडरलाइन), Ctrl+Z (Undo)।\n"
              "2. मेल मर्ज (Mail Merge): एक ही पत्र को डेटाबेस (जैसे एक्सेल लिस्ट) से जोड़कर सैकड़ों लोगों के लिए निजीकृत (personalized) करने की तकनीक।\n"
              "3. मैक्रोज़ (Macros): बार-बार होने वाले फ़ॉर्मेटिंग कार्यों को रिकॉर्ड करके एक सिंगल शॉर्टकट की से स्वचालित (automate) करना।\n"
              "4. पेज सेटअप: 'Layout > Breaks' से Section Break लगाकर एक ही दस्तावेज़ में पोर्ट्रेट और लैंडस्केप लेआउट मिश्रित कर सकते हैं।";
        } else {
          aiResponse = "MS Word & Typing Guide (Basic to Advanced) 📄:\n"
              "1. Shortcuts: Ctrl+C (Copy), Ctrl+V (Paste), Ctrl+B (Bold), Ctrl+I (Italic), Ctrl+U (Underline), Ctrl+Z (Undo).\n"
              "2. Mail Merge: A powerful feature to merge a template document with a data source (e.g. Excel) to print/email personalized sheets en-masse.\n"
              "3. Macros: Automated task sequences recorded in VBA that run with a single hotkey to eliminate repetitive tasks.\n"
              "4. Page Formatting: Use 'Layout > Breaks' to split sections and mix portrait/landscape orientation in the same file.";
        }
      } else if (query.contains("slide master") || query.contains("transition") || query.contains("animation") || query.contains("powerpoint") || query.contains("slide") || query.contains("presentation")) {
        if (isHindi) {
          aiResponse = "पावरपॉइंट गाइड (Basic to Advanced) 📉:\n"
              "1. स्लाइड मास्टर (Slide Master): 'View > Slide Master' से एक ही जगह से पूरी प्रेजेंटेशन के फॉन्ट, लोगो और बैकग्राउंड को डिजाइन करें।\n"
              "2. ट्रांजिशन बनाम एनिमेशन: ट्रांजिशन (Transition) स्लाइडों के बदलने पर लगता है (उदा: Morph), जबकि एनिमेशन (Animation) तत्वों (जैसे टेक्स्ट/इमेज) पर लागू होता है।\n"
              "3. स्मार्टआर्ट (SmartArt): बुलेट पॉइंट टेक्स्ट को आकर्षक फ्लोचार्ट या संगठन चार्ट में बदलने की सुविधा।\n"
              "4. शॉर्टकट: प्रेजेंटेशन शुरू करने के लिए F5 दबाएं; वर्तमान स्लाइड से शुरू करने के लिए Shift+F5 दबाएं।";
        } else {
          aiResponse = "MS PowerPoint & Slides Guide (Basic to Advanced) 📉:\n"
              "1. Slide Master: Go to 'View > Slide Master' to set a unified theme, font styles, and logo layout across all slides at once.\n"
              "2. Transitions vs Animations: Transitions are movement effects when changing slides (e.g., Morph, Fade). Animations are motion paths applied to items on a slide.\n"
              "3. SmartArt: Instantly converts plain text lists into professional diagrams and custom process flowcharts.\n"
              "4. Shortcuts: Press F5 to start slideshow from slide 1, or Shift+F5 to play from the current active slide.";
        }
      } else if (query.contains("computer") || query.contains("what is computer") || query.contains("generation")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर बेसिक्स और इतिहास 💻:\n"
              "1. परिभाषा: कंप्यूटर एक इलेक्ट्रॉनिक उपकरण है जो कच्चे डेटा को इनपुट के रूप में लेता है, उसे प्रोसेस करता है, और अर्थपूर्ण आउटपुट देता है।\n"
              "2. पीढ़ियाँ (Generations):\n"
              "   - पहली पीढ़ी: वैक्यूम ट्यूब (Vacuum Tubes) (1940-1956)\n"
              "   - दूसरी पीढ़ी: ट्रांजिस्टर (Transistors) (1956-1963)\n"
              "   - तीसरी पीढ़ी: इंटीग्रेटेड सर्किट (IC) (1963-1971)\n"
              "   - चौथी पीढ़ी: माइक्रोप्रोसेसर (Microprocessors - VLSI)\n"
              "   - पांचवीं पीढ़ी: आर्टिफिशियल इंटेलिजेंस (AI) और क्वांटम कंप्यूटिंग।\n"
              "3. वॉन न्यूमैन आर्किटेक्चर: इसमें CPU (ALU + Control Unit), मेमोरी यूनिट (RAM), इनपुट और आउटपुट डिवाइस शामिल होते हैं।";
        } else {
          aiResponse = "Computer Basics & Generations 💻:\n"
              "1. Definition: A computer is an electronic device that accepts raw data as input, processes it using programmed instructions, and produces structured output.\n"
              "2. Generations of Computers:\n"
              "   - 1st Gen: Vacuum Tubes (1940-1956) - bulky, high heat generation.\n"
              "   - 2nd Gen: Transistors (1956-1963) - smaller, faster, more energy-efficient.\n"
              "   - 3rd Gen: Integrated Circuits (ICs) (1963-1971) - semiconductor breakthrough.\n"
              "   - 4th Gen: Microprocessors (1971-Present) - CPU on a single silicon chip (VLSI).\n"
              "   - 5th Gen: Artificial Intelligence (AI), quantum computing, and parallel processing.\n"
              "3. Von Neumann Architecture: The blueprint of modern systems, linking a CPU (Control Unit + ALU), Memory (RAM), and Input/Output paths.";
        }
      } else if (query.contains("hardware") || query.contains("ram") || query.contains("rom") || query.contains("cpu") || query.contains("processor") || query.contains("storage") || query.contains("motherboard")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर हार्डवेयर और घटक (Hardware & Components) 🔌:\n"
              "1. CPU (केंद्रीय प्रसंस्करण इकाई): कंप्यूटर का मस्तिष्क। इसमें Arithmetic Logic Unit (गणितीय गणनाओं के लिए) और Control Unit (सिग्नल समन्वय के लिए) होते हैं।\n"
              "2. RAM (रैंडम एक्सेस मेमोरी): यह एक अस्थायी (volatile) प्राथमिक मेमोरी है जो वर्तमान में चल रहे ऐप्स का डेटा रखती है। बंद करने पर यह मिट जाती है।\n"
              "3. ROM (रीड ओनली मेमोरी): स्थायी (non-volatile) मेमोरी जिसमें सिस्टम को बूट करने के लिए 'BIOS' फर्मवेयर होता है।\n"
              "4. स्टोरेज: SSD (Solid State Drive) फ्लैश मेमोरी का उपयोग करती है और HDD (Hard Disk Drive) की तुलना में 10 गुना अधिक तेज़ होती है।\n"
              "5. मदरबोर्ड (Motherboard): मुख्य सर्किट बोर्ड जो CPU, मेमोरी, और अन्य सभी अंगों को आपस में जोड़ता है।";
        } else {
          aiResponse = "Computer Hardware & Internal Components 🔌:\n"
              "1. CPU (Central Processing Unit): The brain. Contains the ALU (Arithmetic Logic Unit for math) and CU (Control Unit for signaling and coordination).\n"
              "2. RAM (Random Access Memory): High-speed, volatile primary memory holding active data for the CPU. Wiped on shutdown.\n"
              "3. ROM (Read-Only Memory): Non-volatile permanent memory hosting 'BIOS' or UEFI startup firmware.\n"
              "4. SSD vs HDD: Solid State Drives (SSDs) use microchips for instant read/write, outperforming magnetic platter Hard Disk Drives (HDDs) by 10x speed.\n"
              "5. Motherboard: The central printed circuit board (PCB) that acts as the backbone, connecting CPU, RAM, GPU, and storage drives.";
        }
      } else if (query.contains("software") || query.contains("operating system") || query.contains("windows") || query.contains("linux") || query.contains("os")) {
        if (isHindi) {
          aiResponse = "सॉफ्टवेयर और ऑपरेटिंग सिस्टम 💿:\n"
              "1. प्रकार: सिस्टम सॉफ्टवेयर (हार्डवेयर को चलाने के लिए, जैसे OS, कंपाइलर) और एप्लीकेशन सॉफ्टवेयर (विशिष्ट कार्य के लिए, जैसे MS Office, Chrome)।\n"
              "2. ऑपरेटिंग सिस्टम (OS): यूजर और हार्डवेयर के बीच की मुख्य कड़ी। मुख्य काम: प्रोसेस शेड्यूलिंग, मेमोरी एलोकेशन, फाइल सिस्टम प्रबंधन और सुरक्षा।\n"
              "3. प्रमुख OS:\n"
              "   - Windows: उपयोगकर्ता-अनुकूल GUI (ग्राफिकल यूजर इंटरफेस)।\n"
              "   - Linux: ओपन-सोर्स, अत्यधिक सुरक्षित और सर्वरों के लिए सबसे पसंदीदा।\n"
              "   - macOS: एप्पल उपकरणों के लिए मालिकाना सुरक्षित ऑपरेटिंग सिस्टम।";
        } else {
          aiResponse = "Software & Operating Systems (OS) 💿:\n"
              "1. Classification: System Software (drives hardware, e.g. OS, device drivers) and Application Software (performs end-user tasks, e.g. MS Office, browser).\n"
              "2. Operating System: The primary interface bridging hardware and the user. Core tasks include memory management, process scheduling, I/O handling, and file systems.\n"
              "3. Key OS Platforms:\n"
              "   - Windows: Proprietary, massive software compatibility, user-friendly GUI.\n"
              "   - Linux: Open-source, highly secure, command-line powerful, powers most global web servers.\n"
              "   - macOS: Apple Unix-based operating system known for tight integration and security.";
        }
      } else if (query.contains("network") || query.contains("internet") || query.contains("ip address") || query.contains("dns") || query.contains("protocol") || query.contains("wifi") || query.contains("router")) {
        if (isHindi) {
          aiResponse = "नेटवर्किंग और इंटरनेट (Basic to Advanced) 🌐:\n"
              "1. IP Address: नेटवर्क पर डिवाइस की पहचान। IPv4 (32-बिट, उदा: 192.168.0.1) और IPv6 (128-बिट, असीमित पतों के लिए)।\n"
              "2. DNS (Domain Name System): इंटरनेट की डायरेक्टरी। यह नाम (google.com) को संख्यात्मक IP पते (142.250.190.46) में बदलता है।\n"
              "3. प्रोटोकॉल: HTTP/HTTPS (वेब डेटा), TCP (सुरक्षित डेटा ट्रांसफर), IP (राउटिंग), SMTP (ईमेल ट्रांसफर)।\n"
              "4. नेटवर्क प्रकार: LAN (स्थानीय क्षेत्र), WAN (वैश्विक इंटरनेट), VPN (सुरक्षित एन्क्रिप्टेड टनल)।";
        } else {
          aiResponse = "Computer Networking & The Internet 🌐:\n"
              "1. IP Address: Unique device address. IPv4 (32-bit decimal notation, e.g., 192.168.0.1) and IPv6 (128-bit hexadecimal, resolving IP exhaustion).\n"
              "2. DNS (Domain Name System): The phonebook of the web. Resolves human domains (e.g. google.com) into server IP addresses.\n"
              "3. Core Protocols: HTTP/HTTPS (hypertext requests), TCP (connection-oriented reliable packet delivery), IP (packet addressing), SMTP (mail exchange).\n"
              "4. Layouts: LAN (Local Area Network), WAN (Wide Area Network), VPN (Virtual Private Network encrypting network packets).";
        }
      } else if (query.contains("database") || query.contains("sql") || query.contains("dbms") || query.contains("nosql")) {
        if (isHindi) {
          aiResponse = "डेटाबेस मैनेजमेंट सिस्टम (DBMS) 🗄️:\n"
              "1. RDBMS: डेटा को परस्पर संबंधित पंक्तियों और स्तंभों की तालिकाओं में रखता है (उदा: MySQL, PostgreSQL, SQLite)।\n"
              "2. SQL (Structured Query Language): डेटाबेस से पूछताछ करने की भाषा। उदा: `SELECT name FROM students WHERE marks > 90;`।\n"
              "3. NoSQL: बिना तालिका वाली लचीली डेटाबेस संरचना (उदा: MongoDB, Firebase Firestore जो JSON दस्तावेज़ों का उपयोग करती है)।\n"
              "4. कुंजी (Keys): Primary Key (तालिका में हर रिकॉर्ड को विशिष्ट पहचान देती है) और Foreign Key (दो तालिकाओं को जोड़ती है)।";
        } else {
          aiResponse = "Database Management Systems (DBMS) 🗄️:\n"
              "1. Relational Database (RDBMS): Stores data in structured tables linked by relationships (e.g., PostgreSQL, MySQL, SQLite).\n"
              "2. SQL: Structured Query Language. Syntax example: `SELECT name FROM students WHERE marks > 90;`.\n"
              "3. NoSQL: Non-relational databases storing data in documents or key-value pairs (e.g., MongoDB, or Firebase Firestore using hierarchical JSON collections).\n"
              "4. DB Keys: Primary Key (uniquely identifies a row) and Foreign Key (links rows across tables).";
        }
      } else if (query.contains("coding") || query.contains("programming") || query.contains("python") || query.contains("java") || query.contains("c++") || query.contains("javascript") || query.contains("compiler") || query.contains("loop") || query.contains("algorithm")) {
        if (isHindi) {
          aiResponse = "प्रोग्रामिंग, कोडिंग और एल्गोरिदम 💻:\n"
              "1. भाषाएँ:\n"
              "   - Python: पढ़ने में आसान, AI, मशीन लर्निंग और डेटा साइंस के लिए नंबर 1 भाषा।\n"
              "   - Java: ऑब्जेक्ट-ओरिएंटेड, प्लेटफार्म इंडिपेंडेंट (JVM पर चलती है), बड़ी कंपनियों और एंड्रॉइड में लोकप्रिय।\n"
              "   - C++: सुपर-फास्ट, गेम डेवलपमेंट और ऑपरेटिंग सिस्टम लिखने के लिए उपयुक्त।\n"
              "   - JavaScript: वेब ब्राउज़र में इंटरैक्टिव यूआई बनाने वाली मुख्य भाषा।\n"
              "2. कंपाइलर बनाम इंटरप्रेटर: कंपाइलर पूरे कोड को पहले मशीन कोड में बदलता है (उदा: C++), जबकि इंटरप्रेटर लाइन-बाय-लाइन चलाता है (उदा: Python)।\n"
              "3. एल्गोरिदम (Algorithm): किसी समस्या को हल करने के लिए क्रमबद्ध लॉजिकल स्टेप्स (जैसे Sorting, Searching)।";
        } else {
          aiResponse = "Programming, Coding & Software Logic 💻:\n"
              "1. Core Languages:\n"
              "   - Python: High readability, standard for AI, machine learning, and automation scripting.\n"
              "   - Java: Strictly object-oriented, compiles to bytecode running on any JVM (Platform Independent).\n"
              "   - C++: Compiled language offering low-level memory access, popular for speed in game engines and OS core layers.\n"
              "   - JavaScript: The script language of the web, powering frontend UI animations and backend runtime (Node.js).\n"
              "2. Compilation vs Interpretation: Compilers translate source code to binaries beforehand (e.g., C++), whereas Interpreters translate and execute lines dynamically during run (e.g., Python).\n"
              "3. Concepts: Variables (storage), Loops (for/while loops), Functions (modular blocks), and Algorithms (logical step-by-step problem-solving).";
        }
      } else if (query.contains("office") || query.contains("ms office") || query.contains("computer science")) {
        if (isHindi) {
          aiResponse = "एमएस ऑफिस और कंप्यूटर शिक्षा 💻:\n"
              "1. एमएस वर्ड (MS Word): पत्र, दस्तावेज, और रिपोर्ट तैयार करने का वर्ड प्रोसेसर।\n"
              "2. एमएस एक्सेल (MS Excel): स्प्रेडशीट जिसमें उन्नत फॉर्मूले, चार्ट, और पिवट टेबल होते हैं।\n"
              "3. एमएस पावरपॉइंट (MS PowerPoint): आकर्षक स्लाइड्स और स्लाइड मास्टर प्रस्तुतियाँ बनाने का टूल।\n"
              "4. एमएस आउटलुक (MS Outlook): ईमेल, कैलेंडर, और टास्क मैनेजर टूल।\n"
              "आपको वर्ड, एक्सेल या पावरपॉइंट में से किसके बारे में गहरी जानकारी चाहिए? उसका नाम लिखें!";
        } else {
          aiResponse = "Microsoft Office Suite & Computer Science 💻:\n"
              "1. MS Word: Advanced word processing for documents, reports, and templates.\n"
              "2. MS Excel: Grid spreadsheets with formulas, data pivot tables, and lookup functions.\n"
              "3. MS PowerPoint: Visual slide decks incorporating Slide Masters, Transitions, and Morph templates.\n"
              "4. MS Outlook: Professional email management, calendar, and task planner.\n"
              "Tell me which program (Word, Excel, PowerPoint) you want to learn in depth!";
        }
      } else if (query.contains("admission") || query.contains("join") || query.contains("fee") || query.contains("class") || query.contains("register")) {
        if (isHindi) {
          aiResponse = "स्वागत है! अग्रवाल नॉलेज हब (पटना शाखाओं) में प्रवेश खुले हैं। हम संकल्पनात्मक शिक्षा पर ध्यान केंद्रित करते हैं। पंजीकरण फॉर्म और मासिक शुल्क संबंधी प्रश्नों के लिए कार्यालय में डायरेक्टर अग्रवाल या सुश्री अंजलि वर्मा से संपर्क करें!";
        } else {
          aiResponse = "Welcome! Admissions are open at Agarwal Knowledge Hub (Patna branches) for Nursery to Class 7 and specialized Computer courses. We focus on conceptual learning and digital tools. For registration forms and monthly fee queries, please consult Director Agarwal or Ms. Anjali Verma at the admin cabin!";
        }
      } else if (query.contains("homework") || query.contains("assignment") || query.contains("due")) {
        if (isHindi) {
          aiResponse = "आप अपने पोर्टल में 'Homework' टैब के तहत सभी दिए गए होमवर्क शीट देख सकते हैं। आप पीडीएफ वर्कशीट डाउनलोड कर सकते हैं, उन्हें हल कर सकते हैं और सीधे 'Submit' स्क्रीन से स्नैपशॉट सबमिट कर सकते हैं। यदि आपके पास कोई विशिष्ट प्रश्न है, तो उसे यहाँ टाइप करें!";
        } else {
          aiResponse = "You can access all assigned homework sheets under the 'Homework' tab in your portal. You can download the PDF worksheets, solve them, and submit snapshots directly from the 'Submit' screen. If you have any specific query from a worksheet, type it here!";
        }
      } else if (query.contains("hi") || query.contains("hello") || query.contains("hey") || query.contains("helo")) {
        if (isHindi) {
          aiResponse = "नमस्ते! मैं अग्रवाल नॉलेज हब में आपका एआई डाउट असिस्टेंट हूँ। मैं गणित, कंप्यूटर विज्ञान और सामान्य होमवर्क से जुड़े संदेहों को हल करने में आपकी मदद कर सकता हूँ। आज आप कौन सा विषय पढ़ रहे हैं?";
        } else {
          aiResponse = "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. I can help you solve doubts on Mathematics, Computer Science, and general classroom homework. What subject are you studying today?";
        }
      } else if (query.contains("thank") || query.contains("thanks")) {
        if (isHindi) {
          aiResponse = "आपका बहुत-बहुत स्वागत है! सीखना एक यात्रा है, और हमें आपकी सहायता करने में खुशी है। मुझे बताएं कि क्या आपके पास कोई अन्य प्रश्न हैं!";
        } else {
          aiResponse = "You're very welcome! Learning is a journey, and we are happy to support you. Let me know if you have any other questions!";
        }
      } else {
        if (isHindi) {
          aiResponse = "यह '${text}' के बारे में एक दिलचस्प सवाल है! आपके एआई ट्यूटर के रूप में, आइए इस विषय को देखें:\n\n1. आपके पाठ्यक्रम के अनुसार, '${text}' एक महत्वपूर्ण शैक्षणिक विषय है।\n2. मैं 'Library' टैब में जाकर अपनी कक्षा के नोट्स या पीडीएफ पुस्तकों की जांच करने की सलाह देता हूँ।\n3. अगले लाइव डाउट क्लियरिंग सेशन में सुश्री अंजलि वर्मा से सीधा मार्गदर्शन प्राप्त करें!";
        } else {
          aiResponse = "That's an interesting question about '${text}'! As your AI Doubt Tutor, let's look at this concept:\n\n1. In your Agarwal Knowledge Hub reference curriculum, '${text}' is a key academic topic covered under your course syllabus.\n2. I recommend checking your class details notes or textbook pdf resources in the 'Library' tab.\n3. Write down a practical example or seek direct step-by-step guidance from Ms. Anjali Verma in the next live doubt clearing session!";
        }
      }

      setState(() {
        _messages.add(MessageBubble(text: aiResponse, isUser: false, time: DateTime.now()));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Doubt Support', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Bilingual Language Selector
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: AppColors.primaryBlue,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white, size: 16),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('Lang: English 🇬🇧')),
                DropdownMenuItem(value: 'Hindi', child: Text('Lang: Hindi 🇮🇳')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedLanguage = val;
                    final isHindi = val == 'Hindi';
                    _messages.add(
                      MessageBubble(
                        text: isHindi 
                          ? "भाषा बदलकर हिंदी कर दी गई है। अब आप हिंदी में सवाल पूछ सकते हैं! 🇮🇳"
                          : "Language changed to English. You can ask doubts in English now! 🇬🇧",
                        isUser: false,
                        time: DateTime.now(),
                      ),
                    );
                  });
                  _scrollToBottom();
                }
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Banner with Bilingual Explanation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.secondaryOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedLanguage == 'Hindi'
                        ? 'अपनी पसंदीदा भाषा चुनें। अगर आप English में भी पूछेंगे, तो भी AI हिंदी में जवाब देगा! 🇮🇳'
                        : 'Choose your preferred language. AI will reply in your chosen language even if you type in English! 🇬🇧',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Messages thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSpeakingThis = _currentlySpeakingText == message.text;

                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!message.isUser) ...[
                        // Speaker Icon Button
                        IconButton(
                          icon: Icon(
                            isSpeakingThis ? Icons.volume_up : Icons.volume_up_outlined,
                            color: isSpeakingThis 
                              ? AppColors.secondaryOrange 
                              : (isDark ? Colors.white70 : Colors.black54),
                            size: 20,
                          ),
                          tooltip: isSpeakingThis ? 'Stop speaking' : 'Read answer aloud',
                          onPressed: () {
                            if (isSpeakingThis) {
                              _stopSpeech();
                            } else {
                              _speak(message.text);
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                      ],
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? AppColors.primaryBlue
                              : (isDark ? AppColors.darkSurface : Colors.grey[200]),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                            bottomRight: Radius.circular(message.isUser ? 0 : 16),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(color: AppColors.primaryBlue),
                ),
              ),
            ),
            
          // Input bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type your doubt here...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primaryBlue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
