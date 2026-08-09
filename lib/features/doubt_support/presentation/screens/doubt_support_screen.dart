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
      text: "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. Ask me anything related to your homework, PDFs, computer science, software, hardware, programming, databases, or MS Office (Word, Excel, PowerPoint)!",
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
          aiResponse = "यहाँ बच्चों के लिए प्रसिद्ध बाल कविताओं (Nursery Rhymes) का संपूर्ण विवरण और उदाहरण है 🎵:\n\n"
              "1️⃣ **ट्विंकल ट्विंकल लिटिल स्टार (Twinkle Twinkle)**:\n"
              "   'ट्विंकल ट्विंकल लिटिल स्टार, हाउ आई वंडर व्हाट यू आर!\n"
              "   अप अबव द वर्ल्ड सो हाई, लाइक ए डायमंड इन द स्काई।'\n\n"
              "2️⃣ **जॉनी जॉनी यस पापा (Johny Johny)**:\n"
              "   'जॉनी जॉनी, यस पापा? ईटिंग शुगर, नो पापा!\n"
              "   टेलिंग लाइज़, नो पापा! ओपन योर माउथ, हा हा हा!'\n\n"
              "💡 **उदाहरण और महत्व**: बाल कविताएँ बच्चों के स्वर-विज्ञान (phonics) और याद रखने की क्षमता को बढ़ाती हैं। संगीतमय आवाज में इसे सुनने के लिए कृपया होम स्क्रीन पर 'Play Study' खोलें!";
        } else {
          aiResponse = "Here is a complete compilation of classic Nursery Rhymes with explanation 🎵:\n\n"
              "1️⃣ **Twinkle Twinkle Little Star**:\n"
              "   'Twinkle, twinkle, little star, How I wonder what you are!\n"
              "   Up above the world so high, Like a diamond in the sky.'\n\n"
              "2️⃣ **Johny Johny Yes Papa**:\n"
              "   'Johny, Johny, Yes, Papa? Eating sugar, No, Papa?\n"
              "   Telling lies, No, Papa? Open your mouth, Ha! Ha! Ha!'\n\n"
              "💡 **Educational Value**: Rhymes aid phonological awareness, speech patterns, and rhythmic coordination in early childhood education. Play these rhymes directly with voice synthesis inside the 'Play Study' tab on the Home screen!";
        }
      } else if (query.contains("counting") || query.contains("number") || query.contains("counting number")) {
        if (isHindi) {
          aiResponse = "आइए संख्या गिनती (Counting Numbers) को व्यावहारिक उदाहरणों के साथ समझें 🔟:\n\n"
              "1️⃣ **संख्या १ (One)**: 🌟 (एक तारा) - 'एक सूर्य चमकता है।'\n"
              "2️⃣ **संख्या २ (Two)**: 🌟🌟 (दो तारे) - $1 + 1 = 2$\n"
              "3️⃣ **संख्या ३ (Three)**: 🌟🌟🌟 (तीन तारे) - $2 + 1 = 3$\n"
              "4️⃣ **संख्या ४ (Four)**: 🌟🌟🌟🌟 (चार तारे) - $3 + 1 = 4$\n"
              "5️⃣ **संख्या ५ (Five)**: 🌟🌟🌟🌟🌟 (पाँच तारे) - $4 + 1 = 5$\n\n"
              "💡 **व्यावहारिक उदाहरण**: यदि आपके पास 3 सेब हैं और अंजली मैम आपको 2 सेब और देती हैं, तो कुल जोड़ $3 + 2 = 5$ होगा। इन्हें क्रमिक रूप से गिनें: 4, 5।\n"
              "ऐप के 'Play Study' सेक्शन में गिनती सीखने के लिए विशेष टूल्स उपलब्ध हैं!";
        } else {
          aiResponse = "Let's study numerical counting structures with practical examples 🔟:\n\n"
              "1️⃣ **Number 1 (One)**: 🌟 (One star) - e.g., 'One bright sun.'\n"
              "2️⃣ **Number 2 (Two)**: 🌟🌟 (Two stars) - Formed by adding $1 + 1 = 2$.\n"
              "3️⃣ **Number 3 (Three)**: 🌟🌟🌟 (Three stars) - Formed by adding $2 + 1 = 3$.\n"
              "4️⃣ **Number 4 (Four)**: 🌟🌟🌟🌟 (Four stars) - Formed by adding $3 + 1 = 4$.\n"
              "5️⃣ **Number 5 (Five)**: 🌟🌟🌟🌟🌟 (Five stars) - Formed by adding $4 + 1 = 5$.\n\n"
              "💡 **Practical Example**: If you possess 4 marbles, and buy 1 more, you aggregate them as $4 + 1 = 5$ marbles. Head over to the 'Play Study' page on the dashboard to interact with animated counting objects!";
        }
      } else if (query.contains("alphabet") || query.contains("abcd")) {
        if (isHindi) {
          aiResponse = "आइए अंग्रेजी वर्णमाला (English Alphabets) को उदाहरण और नियमों के साथ सीखें 🔠:\n\n"
              "🍎 **A for Apple (सेब)**: सेब एक अत्यंत स्वास्थ्यवर्धक फल है।\n"
              "⚽ **B for Ball (गेंद)**: गेंद एक गोल खिलौना है जिसका उपयोग खेल में होता है।\n"
              "🐱 **C for Cat (बिल्ली)**: बिल्ली एक छोटा पालतू स्तनधारी जीव है।\n"
              "🐶 **D for Dog (कुत्ता)**: कुत्ता एक वफादार और रक्षक पालतू पशु है।\n\n"
              "💡 **व्याकरण नियम**: अंग्रेजी में 26 अक्षर होते हैं। इनमें 5 स्वर (Vowels: A, E, I, O, U) और 21 व्यंजन (Consonants) होते हैं। स्वर ध्वनियों से शुरू होने वाले शब्दों के पहले 'an' का प्रयोग होता है (उदा: an apple), जबकि व्यंजन से पहले 'a' (उदा: a ball)।\n"
              "आप 'Play Study' सेक्शन में जाकर A से Z तक के कार्ड चित्रों के साथ देख सकते हैं!";
        } else {
          aiResponse = "Let's study the English Alphabet structure with phonetics and usage rules 🔠:\n\n"
              "🍎 **A for Apple**: A crisp, round fruit. Example: 'She sliced a fresh Apple.'\n"
              "⚽ **B for Ball**: A spherical object. Example: 'The boy bounced the rubber Ball.'\n"
              "🐱 **C for Cat**: A small domesticated feline. Example: 'The white Cat napped on the rug.'\n"
              "🐶 **D for Dog**: A domestic canine animal. Example: 'My loyal Dog barked excitedly.'\n\n"
              "💡 **Grammar Foundation**: The alphabet contains 26 letters: 5 Vowels (A, E, I, O, U) and 21 Consonants. Words beginning with vowel sounds take the article 'an' (e.g. 'an apple'), while those beginning with consonant sounds take 'a' (e.g. 'a dog').\n"
              "Browse interactive A-Z flashcards inside the 'Play Study' tab on your Home screen!";
        }
      } else if (query.contains("swar") || query.contains("vyanjan") || query.contains("varnmala")) {
        if (isHindi) {
          aiResponse = "आइए हिंदी वर्णमाला (Varnmala) को उदाहरण सहित गहराई से समझें ✍️:\n\n"
              "1️⃣ **स्वर (Vowels)**: ये स्वतंत्र ध्वनियाँ होती हैं (कुल 11 स्वर):\n"
              "   - अ (अनार 🍒) ➔ 'अनार सेहत के लिए फायदेमंद है।'\n"
              "   - आ (आम 🥭) ➔ 'आम फलों का राजा है।'\n"
              "   - इ (इमली 🫒) ➔ 'इमली खट्टी-मीठी होती है।'\n\n"
              "2️⃣ **व्यंजन (Consonants)**: इन्हें बोलने के लिए स्वरों की सहायता ली जाती है (कुल 33 व्यंजन):\n"
              "   - क (कबूतर 🕊️) ➔ 'कबूतर शांति फैलाता है।' (क् + अ = क)\n"
              "   - ख (खरगोश 🐇) ➔ 'खरगोश गाजर खाता है।' (ख् + अ = ख)\n"
              "   - ग (गमला 🪴) ➔ 'गमले में पानी डालें।' (ग् + अ = ग)\n\n"
              "💡 **महत्वपूर्ण नियम**: स्वर बिना किसी बाधा के बोले जाते हैं, जबकि व्यंजनों के उच्चारण के लिए जीभ, दाँत या होंठों का तालमेल आवश्यक है।\n"
              "बच्चों के सीखने के लिए 'Play Study' में Varnmala टैब खोलें!";
        } else {
          aiResponse = "Let's study the Hindi Varnmala (Alphabet) structure in detail with phonetics ✍️:\n\n"
              "1️⃣ **Swar (Vowels)**: 11 independent phonemes requiring no other letter for articulation:\n"
              "   - अ (Anar 🍒) ➔ Pomegranate. Example sentence: 'Anar has red seeds.'\n"
              "   - आ (Aam 🥭) ➔ Mango. Example sentence: 'Aam is very sweet.'\n"
              "   - इ (Imli 🫒) ➔ Tamarind. Example sentence: 'Imli is sour.'\n\n"
              "2️⃣ **Vyanjan (Consonants)**: 33 phonemes pronounced by combining with Swar sounds:\n"
              "   - क (Kabootar 🕊️) ➔ Pigeon. Formed mathematically as: क् + अ = क.\n"
              "   - ख (Khargosh 🐇) ➔ Rabbit. Formed mathematically as: ख् + अ = ख.\n"
              "   - ग (Gamla 🪴) ➔ Flowerpot. Formed mathematically as: ग् + अ = ग.\n\n"
              "💡 **Phonetic Rule**: Unlike vowels, consonants block or restrict airflow inside the vocal tract during pronunciation. Open the 'Play Study' section on the Home screen to explore these vocal sounds!";
        }
      } else if (query.contains("fraction")) {
        if (isHindi) {
          aiResponse = "गणित की शंका हल! भिन्न (Fraction) को गहराई और उदाहरणों से समझें 🔢:\n\n"
              "**परिभाषा**: भिन्न एक ऐसी संख्या है जो किसी संपूर्ण वस्तु (Whole Object) के किसी निश्चित हिस्से को दर्शाती है। इसे $\\frac{\\text{अंश (Numerator)}}{\\text{हर (Denominator)}}$ के रूप में लिखा जाता है।\n\n"
              "💡 **व्यावहारिक उदाहरण**: यदि आपके पास 1 रोटी है और आप उसे 4 बराबर भागों में काटकर 1 भाग अपने मित्र को देते हैं, तो मित्र को रोटी का $\\frac{1}{4}$ हिस्सा मिला और आपके पास $\\frac{3}{4}$ हिस्सा बचा।\n\n"
              "**भिन्नों का जोड़ (Addition of Fractions)**:\n"
              "1. **समान हर (Like Denominators)**: हर को वही रखते हुए अंशों को सीधे जोड़ें।\n"
              "   $$\\text{उदाहरण: } \\frac{2}{7} + \\frac{3}{7} = \\frac{2+3}{7} = \\frac{5}{7}$$\n"
              "2. **असमान हर (Unlike Denominators)**: पहले हर का LCM लें, फिर जोड़ें।\n"
              "   $$\\text{उदाहरण: } \\frac{1}{2} + \\frac{1}{3} \\implies \\text{LCM of 2 and 3 is 6} \\implies \\frac{3}{6} + \\frac{2}{6} = \\frac{5}{6}$$";
        } else {
          aiResponse = "Mathematics Doubt Solved! Detailed breakdown of Fractions 🔢:\n\n"
              "**Definition**: A fraction represents a numerical division of a whole entity. It is structured as $\\frac{\\text{Numerator}}{\\text{Denominator}}$, where the Numerator counts the parts taken and the Denominator represents the total partition slices.\n\n"
              "💡 **Practical Example**: Imagine a pizza divided into 8 equal slices. If you consume 3 slices, you have eaten $\\frac{3}{8}$ of the pizza, leaving $\\frac{5}{8}$ of it untouched.\n\n"
              "**Addition Rules (Step-by-Step)**:\n"
              "1. **Like Denominators**: Add numerators directly over the shared denominator:\n"
              "   $$\\text{Example: } \\frac{4}{9} + \\frac{2}{9} = \\frac{4 + 2}{9} = \\frac{6}{9} = \\frac{2}{3}$$\n"
              "2. **Unlike Denominators**: Find the Least Common Multiple (LCM) of denominators first, convert to equivalent fractions, then sum them:\n"
              "   $$\\text{Example: } \\frac{2}{5} + \\frac{1}{4} \\implies \\text{LCM of 5 and 4 is 20} \\implies \\frac{8}{20} + \\frac{5}{20} = \\frac{13}{20}$$";
        }
      } else if (query.contains("math") || query.contains("sum") || query.contains("add") || query.contains("multiply") || query.contains("divide") || query.contains("algebra") || query.contains("geometry")) {
        if (isHindi) {
          aiResponse = "गणित शिक्षक गाइड (कक्षा 1-10) - विस्तृत नियम और सूत्र 📐:\n\n"
              "1️⃣ **अंकगणित (BODMAS नियम)**:\n"
              "   - गणना का क्रम: Brackets (कोष्ठक) ➔ Orders (घातांक) ➔ Division (भाग) ➔ Multiplication (गुणा) ➔ Addition (जोड़) ➔ Subtraction (घटाव)।\n"
              "   - **उदाहरण**: $24 - 4 \\times 5 + (6 \\div 2)$ को हल करें:\n"
              "     1. कोष्ठक हल करें: $(6 \\div 2) = 3$\n"
              "     2. गुणा करें: $4 \\times 5 = 20$\n"
              "     3. जोड़ और घटाव: $24 - 20 + 3 = 4 + 3 = 7$\n\n"
              "2️⃣ **ज्यामिति (Geometry Area & Perimeter)**:\n"
              "   - आयत (Rectangle) का परिमाप = $2 \\times (\\text{लंबाई} + \\text{चौड़ाई})$।\n"
              "   - वृत्त (Circle) का क्षेत्रफल = $\\pi r^2$ (त्रिज्या $r = 7\\text{ cm} \\implies \\text{क्षेत्रफल} = \\frac{22}{7} \\times 7 \\times 7 = 154\\text{ cm}^2$)।\n\n"
              "3️⃣ **बीजगणित (Algebra Solving)**:\n"
              "   - **उदाहरण**: $4x + 8 = 20$ में $x$ का मान ज्ञात करें:\n"
              "     $4x = 20 - 8 \\implies 4x = 12 \\implies x = 3$।";
        } else {
          aiResponse = "Comprehensive Mathematics Academic Guide (Grades 1-10) 📐:\n\n"
              "1️⃣ **Arithmetic (BODMAS Rule for Equation Solving)**:\n"
              "   - Evaluation sequence: Brackets ➔ Orders (powers) ➔ Division ➔ Multiplication ➔ Addition ➔ Subtraction.\n"
              "   - **Step-by-Step Example**: Evaluate $30 - 5 \\times (8 - 6) \\div 2$\n"
              "     1. Solve Brackets: $(8 - 6) = 2$\n"
              "     2. Multiply & Divide (left-to-right): $5 \\times 2 \\div 2 = 10 \\div 2 = 5$\n"
              "     3. Final Subtract: $30 - 5 = 25$\n\n"
              "2️⃣ **Geometry (Perimeter & Area Formulas)**:\n"
              "   - Rectangle Perimeter = $2 \\cdot (\\text{Length} + \\text{Width})$.\n"
              "   - Circle Area = $\\pi r^2$. Example: For radius $r = 14\\text{ cm}$, $\\text{Area} = \\frac{22}{7} \\cdot 14 \\cdot 14 = 616\\text{ cm}^2$.\n\n"
              "3️⃣ **Algebra (Solving Linear Equations)**:\n"
              "   - **Example**: Find $x$ for $7x - 9 = 26 \\implies 7x = 35 \\implies x = 5$.";
        }
      } else if (query.contains("physics") || query.contains("gravity") || query.contains("force") || query.contains("motion") || query.contains("light") || query.contains("electricity")) {
        if (isHindi) {
          aiResponse = "भौतिकी गाइड (Physics In-Depth) ⚡:\n\n"
              "1️⃣ **बल और न्यूटन के नियम (Force & Motion)**:\n"
              "   - सूत्र: $F = m \\times a$ (बल = द्रव्यमान $\\times$ त्वरण)। बल का मात्रक न्यूटन ($N$) है।\n"
              "   - **उदाहरण**: $10\\text{ kg}$ की गेंद पर $5\\text{ m/s}^2$ का त्वरण उत्पन्न करने के लिए बल = $10 \\times 5 = 50\\text{ N}$।\n\n"
              "2️⃣ **गुरुत्वाकर्षण (Gravity)**:\n"
              "   - वह बल जिससे पृथ्वी सभी वस्तुओं को अपने केंद्र की ओर आकर्षित करती है। इसका त्वरण ($g$) $\\approx 9.8\\text{ m/s}^2$ होता है।\n"
              "   - **उदाहरण**: पृथ्वी पर $10\\text{ kg}$ की वस्तु का भार = $m \\times g = 10 \\times 9.8 = 98\\text{ N}$।\n\n"
              "3️⃣ **प्रकाश का अपवर्तन (Refraction of Light)**:\n"
              "   - जब प्रकाश किरण हवा (विरल) से पानी (सघन) में जाती है, तो वह अभिलंब (normal) की ओर झुक जाती है। इसी कारण पानी में डूबी पेंसिल टेढ़ी दिखाई देती है।";
        } else {
          aiResponse = "Physics Theoretical Core Guide & Real-life Applications ⚡:\n\n"
              "1️⃣ **Newton's Laws of Motion & Force**:\n"
              "   - Core Formula: $F = m \\cdot a$ (Force = mass $\\times$ acceleration). Unit is Newton ($N$).\n"
              "   - **Example**: Calculate force required to accelerate a $15\\text{ kg}$ object at $4\\text{ m/s}^2$.\n"
              "     $$F = 15 \\cdot 4 = 60\\text{ Newtons } (N)$$\n\n"
              "2️⃣ **Gravitational Force & Weight**:\n"
              "   - Gravity ($g \\approx 9.8\\text{ m/s}^2$) pulls objects towards Earth's core.\n"
              "   - **Example**: Weight of a $5\\text{ kg}$ object is $W = m \\cdot g = 5 \\cdot 9.8 = 49\\text{ Newtons}$. On the Moon, gravity is only $\\frac{1}{6}$th of Earth, so the same object weighs just $8.1\\text{ N}$!\n\n"
              "3️⃣ **Snell's Law & Light Refraction**:\n"
              "   - Refraction is the bending of light when passing from one medium to another. Example: A straw placed in a glass of water looks broken or bent due to speed changes of light in air vs. water.";
        }
      } else if (query.contains("chemistry") || query.contains("acid") || query.contains("base") || query.contains("element") || query.contains("atom") || query.contains("molecule")) {
        if (isHindi) {
          aiResponse = "रसायन विज्ञान (Chemistry Complete Study) 🧪:\n\n"
              "1️⃣ **परमाणु की संरचना (Atomic Structure)**:\n"
              "   - परमाणु पदार्थ की मूल इकाई है। इसके केंद्रक (nucleus) में प्रोटॉन (+) और न्यूट्रॉन होते हैं, और इलेक्ट्रॉन (-) बाहरी कक्षाओं में चक्कर लगाते हैं।\n"
              "   - **उदाहरण**: कार्बन ($C$) के परमाणु में 6 प्रोटॉन, 6 न्यूट्रॉन और 6 इलेक्ट्रॉन होते हैं।\n\n"
              "2️⃣ **pH स्केल और अम्ल-क्षार (pH Scale & Acids/Bases)**:\n"
              "   - pH 0 से 6.9: अम्ल (Acids) - स्वाद में खट्टे, नीले लिटमस को लाल करते हैं (उदा: नींबू का रस - साइट्रिक एसिड)।\n"
              "   - pH 7.1 से 14: क्षार (Bases) - स्वाद में कड़वे, लाल लिटमस को नीला करते हैं (उदा: साबुन का पानी)।\n"
              "   - pH 7.0: उदासीन (Neutral) (उदा: शुद्ध डिस्टिल्ड पानी)।\n\n"
              "3️⃣ **रासायनिक प्रतिक्रिया (Chemical Equation Example)**:\n"
              "   - मैग्नीशियम को हवा में जलाने पर मैग्नीशियम ऑक्साइड बनता है: $2Mg + O_2 \\rightarrow 2MgO$।";
        } else {
          aiResponse = "Chemistry Theoretical Core Guide & Formulas 🧪:\n\n"
              "1️⃣ **Atoms, Elements & Molecular Compounds**:\n"
              "   - An Atom is the smallest unit of matter, containing a nucleus of Protons ($+$) and Neutrons (neutral), surrounded by orbiting Electrons ($-$).\n"
              "   - **Example**: Water ($H_2O$) is a compound formed by two Hydrogen atoms covalent-bonded with one Oxygen atom.\n\n"
              "2️⃣ **pH Scale Mechanics**:\n"
              "   - pH < 7: Acidic (sour, turns blue litmus paper red, e.g., citric acid in lemons, stomach $HCl$).\n"
              "   - pH > 7: Basic/Alkaline (bitter, slippery feel, turns red litmus paper blue, e.g., sodium bicarbonate, soap).\n"
              "   - pH = 7: Neutral (e.g., pure distilled water).\n\n"
              "3️⃣ **Chemical Balancing Example**:\n"
              "   - Methane combustion: $CH_4 + 2O_2 \\rightarrow CO_2 + 2H_2O$ (shows conservation of mass).";
        }
      } else if (query.contains("biology") || query.contains("cell") || query.contains("plant") || query.contains("photosynthesis") || query.contains("human body")) {
        if (isHindi) {
          aiResponse = "जीव विज्ञान गाइड (Biology In-Depth with Diagrams) 🧬:\n\n"
              "1️⃣ **कोशिका: जीवन की इकाई (Cell Biology)**:\n"
              "   - कोशिका सभी सजीवों की मूलभूत संरचनात्मक इकाई है। जंतु कोशिका में कोशिका भित्ति नहीं होती, जबकि पादप कोशिका में सेल्युलोज से बनी कठोर कोशिका भित्ति (Cell Wall) और क्लोरोप्लास्ट (हरित लवक) होते हैं।\n\n"
              "2️⃣ **प्रकाश संश्लेषण (Photosynthesis)**:\n"
              "   - हरी पत्तियाँ सूर्य के प्रकाश में क्लोरोफिल की सहायता से कार्बन डाइऑक्साइड ($CO_2$) और पानी ($H_2O$) का उपयोग करके ग्लूकोज (भोजन) बनाती हैं और ऑक्सीजन मुक्त करती हैं।\n"
              "   - **अभिक्रिया सूत्र**: $6CO_2 + 6H_2O + \\text{प्रकाश ऊर्जा} \\rightarrow C_6H_{12}O_6 + 6O_2$।\n\n"
              "3️⃣ **मानव शरीर प्रणाली (Human Body Systems)**:\n"
              "   - परिसंचरण तंत्र (Circulatory System) में हृदय रक्त को पूरे शरीर में पंप करता है। धमनियाँ (Arteries) साफ ऑक्सीजन युक्त रक्त ले जाती हैं और शिराएँ (Veins) अशुद्ध रक्त वापस हृदय तक लाती हैं।";
        } else {
          aiResponse = "Biology Theoretical Core Guide & Functional Analysis 🧬:\n\n"
              "1️⃣ **Cell Structure (Animal vs. Plant Cells)**:\n"
              "   - The cell is the basic structural and functional unit of life. Plant cells possess a rigid, external Cell Wall and green Chloroplasts for energy conversion, which animal cells lack.\n\n"
              "2️⃣ **Photosynthesis Process & Formula**:\n"
              "   - Plants convert inorganic molecules ($CO_2$ and $H_2O$) into organic glucose sugar ($C_6H_{12}O_6$) utilizing solar energy captured by chlorophyll pigments, expelling oxygen ($O_2$) as a vital byproduct.\n"
              "   - **Balanced Equation**: $6CO_2 + 6H_2O + \\text{light energy} \\rightarrow C_6H_{12}O_6 + 6O_2$.\n\n"
              "3️⃣ **Human Circulation System**:\n"
              "   - The human cardiovascular system utilizes the heart to pump blood. Arteries transport oxygenated blood away from the heart to feed tissues, while Veins return deoxygenated blood containing carbon dioxide back to the heart.";
        }
      } else if (query.contains("science")) {
        if (isHindi) {
          aiResponse = "विज्ञान ट्यूटर हब (Science Branches and Syllabus) 🔬:\n\n"
              "विज्ञान मुख्य रूप से तीन शाखाओं में विभाजित है:\n"
              "1️⃣ **भौतिकी (Physics)**: पदार्थ, ऊर्जा, प्रकाश, गति, और विद्युत चुम्बकीय बलों का अध्ययन। (उदा: न्यूटन के गति के नियम, विद्युत परिपथ)।\n"
              "2️⃣ **रसायन विज्ञान (Chemistry)**: तत्वों, अणुओं, उनके गुणों, रासायनिक प्रतिक्रियाओं और पीएच स्केल का अध्ययन। (उदा: रासायनिक समीकरणों को संतुलित करना)।\n"
              "3️⃣ **जीव विज्ञान (Biology)**: जीवन, कोशिकाओं, पौधों, जानवरों और मानव शरीर प्रणालियों का अध्ययन। (उदा: कोशिका संरचना, प्रकाश संश्लेषण)।\n\n"
              "💡 **सलाह**: आप किस विषय की विस्तृत व्याख्या और उदाहरण देखना चाहते हैं? उसका नाम टाइप करें (जैसे: 'photosynthesis', 'gravity', 'acid')!";
        } else {
          aiResponse = "Science Tutor Hub & Curriculum Outline 🔬:\n\n"
              "Science is structured into three primary academic disciplines:\n"
              "1️⃣ **Physics**: The study of matter, energy, light, gravity, motion, and electric currents (e.g. Newton's Laws, circuit analysis).\n"
              "2️⃣ **Chemistry**: The study of substances, atomic compositions, chemical bonds, reactions, and properties (e.g. stoichiometry, atomic structures).\n"
              "3️⃣ **Biology**: The study of living organisms, cellular functions, photosynthesis, and human anatomy.\n\n"
              "💡 **Tip**: Type a specific term you wish to analyze in detail (e.g. type 'gravity' for physics, 'atom' for chemistry, or 'cell' for biology) to see step-by-step examples!";
        }
      } else if (query.contains("economics") || query.contains("money") || query.contains("demand") || query.contains("supply") || query.contains("market")) {
        if (isHindi) {
          aiResponse = "अर्थशास्त्र गाइड (Economics & Markets) 📊:\n\n"
              "1️⃣ **मांग और आपूर्ति का नियम (Law of Demand and Supply)**:\n"
              "   - **मांग का नियम**: जब किसी वस्तु की कीमत बढ़ती है, तो उसकी मांग घटती है (कीमत ➔ मांग ⬇️)।\n"
              "   - **आपूर्ति का नियम**: जब कीमत बढ़ती है, तो उत्पादक अधिक मुनाफा कमाने के लिए बाजार में आपूर्ति बढ़ा देते हैं (कीमत ➔ आपूर्ति ⬆️)।\n"
              "   - **उदाहरण**: यदि आम का सीजन शुरू होता है और बाजार में बहुत सारे आम आ जाते हैं (आपूर्ति बढ़ जाती है), तो आम की कीमत कम हो जाती है।\n\n"
              "2️⃣ **भारतीय अर्थव्यवस्था के क्षेत्र (Sectors of Economy)**:\n"
              "   - **प्राथमिक क्षेत्र**: कृषि, पशुपालन, और खनन।\n"
              "   - **द्वितीयक क्षेत्र**: विनिर्माण (manufacturing) और कारखाने।\n"
              "   - **तृतीयक (सेवा) क्षेत्र**: आईटी, बैंकिंग, शिक्षा, और परिवहन।";
        } else {
          aiResponse = "Economics Core Principles & Sector Analysis 📊:\n\n"
              "1️⃣ **The Law of Supply and Demand**:\n"
              "   - **Law of Demand**: Keeping all factors constant, as the price of a good increases, consumer demand for that good falls.\n"
              "   - **Law of Supply**: As the price of a good increases, suppliers are motivated to produce more of it to maximize profits.\n"
              "   - **Example**: During winter, the demand for woollen jackets rises, causing retailers to increase supply. The point where demand and supply curves cross is the Equilibrium Price.\n\n"
              "2️⃣ **Sectors of the Economy**:\n"
              "   - **Primary Sector**: Extraction of raw materials (e.g. agriculture, forestry, coal mining).\n"
              "   - **Secondary Sector**: Processing raw materials into finished goods (e.g. automobile assembly, steel mills).\n"
              "   - **Tertiary Sector**: Service industry supplying intangibles (e.g. computer programming, teaching, retail banking).";
        }
      } else if (query.contains("history") || query.contains("gandhi") || query.contains("independence") || query.contains("harappa") || query.contains("revolution")) {
        if (isHindi) {
          aiResponse = "इतिहास और स्वतंत्रता आंदोलन (History & Independence Guide) 📜:\n\n"
              "1️⃣ **हड़प्पा सभ्यता (Indus Valley Civilization)**:\n"
              "   - यह एक प्राचीन कांस्य युगीन (Bronze Age) सभ्यता थी जो सिंधु नदी घाटी में विकसित हुई थी। यह अपनी सुनियोजित नगर नियोजन प्रणाली (grid system), पक्की ईंटों के घरों और उन्नत जल निकासी व्यवस्था (drainage system) के लिए जानी जाती है।\n\n"
              "2️⃣ **भारतीय स्वतंत्रता आंदोलन (Indian Freedom Struggle)**:\n"
              "   - भारत को ब्रिटिश शासन से 15 अगस्त 1947 को स्वतंत्रता मिली।\n"
              "   - **महात्मा गांधी और आंदोलन**: गांधीजी ने अहिंसा (Non-Violence) और सत्याग्रह के माध्यम से असहयोग आंदोलन (Non-Cooperation Movement, 1920), नमक सत्याग्रह (Dandi March, 1930) और भारत छोड़ो आंदोलन (Quit India, 1942) का नेतृत्व किया।\n"
              "   - **क्रांतिकारी नेता**: नेताजी सुभाष चंद्र बोस ने 'आजाद हिंद फौज' का गठन किया और नारा दिया 'तुम मुझे खून दो, मैं तुम्हें आजादी दूंगा।';";
        } else {
          aiResponse = "Historical Milestones & National Movements 📜:\n\n"
              "1️⃣ **Harappan/Indus Valley Civilization**:\n"
              "   - An ancient Bronze Age culture (~2500 BCE) famous for its grid-based urban town planning, advanced underground baked-brick drainage pipelines, public baths (e.g. The Great Bath at Mohenjo-daro), and standardized weight scales.\n\n"
              "2️⃣ **Indian Struggle for Independence (1857 - 1947)**:\n"
              "   - **First War of Independence (1857)**: A massive rebellion sparked by soldiers like Mangal Pandey against the East India Company rule.\n"
              "   - **Gandhian Era**: Mahatma Gandhi pioneered non-violent resistance (Satyagraha) through major campaigns:\n"
              "     - Non-Cooperation Movement (1920-1922) for self-rule.\n"
              "     - Salt Satyagraha / Dandi March (1930) protesting salt manufacturing taxes.\n"
              "     - Quit India Movement (1942) demanding complete British withdrawal.\n"
              "   - **Revolutionary Path**: Subhash Chandra Bose organized the Indian National Army (INA) to liberate India by military force.";
        }
      } else if (query.contains("geography") || query.contains("earth") || query.contains("map") || query.contains("continent") || query.contains("river") || query.contains("soil")) {
        if (isHindi) {
          aiResponse = "भूगोल ट्यूटर (Geography Complete Guide) 🌍:\n\n"
              "1️⃣ **पृथ्वी की आंतरिक संरचना (Layers of the Earth)**:\n"
              "   - **भूपर्पटी (Crust)**: सबसे बाहरी ठोस परत जहाँ हम रहते हैं (मोटाई 5 से 70 किमी)।\n"
              "   - **मेंटल (Mantle)**: बीच की मोटी परत जो पिघली हुई चट्टानों (magma) से बनी है (गहराई 2900 किमी)।\n"
              "   - **क्रोड (Core)**: सबसे भीतरी भाग जो मुख्य रूप से लोहे और निकल (NIFE) से बना है। यह बाहरी तरल क्रोड और आंतरिक ठोस क्रोड में विभाजित है।\n\n"
              "2️⃣ **वायुमंडल की परतें (Atmosphere Layers)**:\n"
              "   - **क्षोभमंडल (Troposphere)**: सबसे निचली परत जहाँ मौसम की सभी घटनाएं (बादल, वर्षा) होती हैं।\n"
              "   - **समतापमंडल (Stratosphere)**: जेट विमानों के उड़ने के लिए आदर्श परत क्योंकि यहाँ बादल नहीं होते। इसी में **ओजोन परत (Ozone Layer)** होती है जो हानिकारक UV किरणों को रोकती है।\n\n"
              "3️⃣ **नदियाँ और जल चक्र (Water Cycle)**: नदियों का उद्गम पहाड़ों (glaciers) से होता है और अंततः वे समुद्र में मिलती हैं। जल वाष्पीकरण ➔ संघनन ➔ वर्षा के चक्र से पृथ्वी पर पानी का संतुलन बना रहता है।";
        } else {
          aiResponse = "Geography Core Principles & Earth Systems 🌍:\n\n"
              "1️⃣ **Internal Layered Structure of Earth**:\n"
              "   - **Crust**: The brittle silicate shell we live on, ranging from 5km (oceanic crust) to 70km (continental crust) thick.\n"
              "   - **Mantle**: Highly viscous silicate rock representing 84% of Earth's volume. Convection currents here drive tectonic plates.\n"
              "   - **Core**: Innermost dense layer made of Nickel and Iron (NiFe). The liquid outer core generates Earth's protective magnetic field, while the inner core is solid due to immense pressure.\n\n"
              "2️⃣ **Atmosphere Layers**:\n"
              "   - **Troposphere**: Lowest layer (0-12 km) containing 75% of atmospheric mass and all weather phenomena.\n"
              "   - **Stratosphere**: Contains the crucial **Ozone ($O_3$) Layer** which absorbs 98% of the sun's ionizing ultraviolet radiation.\n\n"
              "3️⃣ **Rock Types & Soil Profiles**:\n"
              "   - Igneous Rocks (crystallized from cooling magma, e.g., basalt), Sedimentary Rocks (accumulated mineral deposits, e.g., limestone), and Metamorphic Rocks (transformed by heat & pressure, e.g., marble).";
        }
      } else if (query.contains("english") || query.contains("grammar") || query.contains("noun") || query.contains("verb") || query.contains("tense")) {
        if (isHindi) {
          aiResponse = "अंग्रेजी व्याकरण (English Grammar In-Depth) 📝:\n\n"
              "1️⃣ **संज्ञा (Noun)**: किसी व्यक्ति, स्थान, वस्तु, या विचार के नाम को संज्ञा कहते हैं।\n"
              "   - **प्रकार और उदाहरण**: Common Noun (boy, city), Proper Noun (Aman, Patna), Abstract Noun (honesty, love)।\n"
              "   - **वाक्य उदाहरण**: *Aman* lives in a beautiful *city* called *Patna*.\n\n"
              "2️⃣ **क्रिया (Verb)**: वह शब्द जो किसी कार्य के करने या स्थिति को दर्शाता है।\n"
              "   - **उदाहरण**: write (लिखना), run (दौड़ना), is (है)।\n"
              "   - **वाक्य उदाहरण**: She *runs* fast. / He *is* playing.\n\n"
              "3️⃣ **काल (Tenses - समय काल)**:\n"
              "   - **Present Tense (वर्तमान)**: 'I study English grammar.' (मैं पढ़ता हूँ)\n"
              "   - **Past Tense (भूतकाल)**: 'I studied English yesterday.' (मैंने कल पढ़ा)\n"
              "   - **Future Tense (भविष्यकाल)**: 'I will study English tomorrow.' (मैं कल पढूँगा)";
        } else {
          aiResponse = "Advanced English Grammar Guide & Sentence Structures 📝:\n\n"
              "1️⃣ **Parts of Speech: Nouns and Verbs**:\n"
              "   - **Noun**: Names a person, place, thing, or concept. Example: *Patna* is the capital *city*.\n"
              "   - **Verb**: Denotes action or state of being. Example: The children *laugh* heartily (action). She *seems* happy (state).\n\n"
              "2️⃣ **Tense System & Conjugation Rules**:\n"
              "   - **Present Simple**: Used for habits and universal facts. E.g. 'The Earth *revolves* around the sun.'\n"
              "   - **Past Simple**: Used for completed past events. E.g. 'They *built* this academy in 2015.'\n"
              "   - **Future Simple**: Used for future intents. E.g. 'We *will launch* the coding classes next month.'\n\n"
              "3️⃣ **Active vs. Passive Voice (Example)**:\n"
              "   - *Active*: 'Ms. Anjali Verma graded the homework.'\n"
              "   - *Passive*: 'The homework was graded by Ms. Anjali Verma.'";
        }
      } else if (query.contains("hindi") || query.contains("vyakaran") || query.contains("sangya") || query.contains("kriya")) {
        aiResponse = "हिंदी व्याकरण ट्यूटर (व्यापक नियम और उदाहरण) ✍️:\n\n"
            "1️⃣ **संज्ञा (Noun)**: किसी व्यक्ति, वस्तु, स्थान, भाव या जाति के नाम को संज्ञा कहते हैं।\n"
            "   - **भेद और उदाहरण**:\n"
            "     - व्यक्तिवाचक संज्ञा: राम, पटना, हिमालय।\n"
            "     - जातिवाचक संज्ञा: लड़का, शहर, नदी।\n"
            "     - भाववाचक संज्ञा: ईमानदारी, बुढ़ापा, मिठास।\n"
            "   - **वाक्य**: *अमन* अपनी *ईमानदारी* के कारण *पटना* शहर में प्रसिद्ध है।\n\n"
            "2️⃣ **क्रिया (Verb)**: जिस शब्द से किसी काम के करने या होने का बोध हो, उसे क्रिया कहते हैं।\n"
            "   - **भेद और उदाहरण**:\n"
            "     - सकर्मक क्रिया (कर्म के साथ): 'वह पुस्तक पढ़ता है।' (पुस्तक कर्म है)\n"
            "     - अकर्मक क्रिया (बिना कर्म के): 'लड़का सोता है।'\n\n"
            "3️⃣ **सर्वनाम (Pronoun)**: संज्ञा के स्थान पर प्रयुक्त होने वाले शब्द।\n"
            "   - **उदाहरण**: मैं, तुम, वह, हम, उनका। (उदा: 'राम स्कूल जाता है। *वह* वहाँ पढ़ाई करता है।')";
      } else if (query.contains("vlookup") || query.contains("xlookup") || query.contains("pivot") || query.contains("excel") || query.contains("spreadsheet") || query.contains("formula")) {
        if (isHindi) {
          aiResponse = "एक्सेल और स्प्रेडशीट गाइड (Basic to Advanced Formulas) 📊:\n\n"
              "1️⃣ **मूल सांख्यिकीय फॉर्मूले**:\n"
              "   - **SUM**: `=SUM(A1:A10)` - सेल रेंज A1 से A10 तक के सभी नंबरों को जोड़ता है।\n"
              "   - **AVERAGE**: `=AVERAGE(B1:B10)` - औसत मान निकालता है।\n"
              "   - **IF कंडीशन**: `=IF(D2>=33, \"Pass\", \"Fail\")` - यदि सेल D2 में मान 33 या अधिक है, तो 'Pass' लिखेगा, अन्यथा 'Fail'।\n\n"
              "2️⃣ **VLOOKUP (वर्टिकल लुकअप - खोज टूल)**:\n"
              "   - **सिंटैक्स**: `=VLOOKUP(lookup_value, table_array, col_index_num, [range_lookup])`\n"
              "   - **उदाहरण**: `=VLOOKUP(\"Roll-05\", A2:D100, 2, FALSE)` - यह सीमा A2 से D100 में रोल नंबर 'Roll-05' खोजेगा और दूसरे कॉलम (जैसे छात्र का नाम) की जानकारी देगा।\n\n"
              "3️⃣ **XLOOKUP (आधुनिक लुकअप)**:\n"
              "   - **सिंटैक्स**: `=XLOOKUP(lookup_value, lookup_array, return_array)`\n"
              "   - **उदाहरण**: `=XLOOKUP(\"Roll-05\", A2:A100, B2:B100)` - यह रोल नंबर कॉलम A में खोजेगा और नाम कॉलम B से लौटाएगा। यह बाईं ओर भी खोज सकता है और बहुत तेज़ है।\n\n"
              "4️⃣ **Pivot Tables (पिवट टेबल)**: बड़ी डेटा शीट को सारांशित करने का टूल। डेटा का चयन करें ➔ 'Insert' पर क्लिक करें ➔ 'PivotTable' चुनें। फिर ड्रग-एंड-ड्रॉप करके सेल्स रिपोर्ट तैयार करें।";
        } else {
          aiResponse = "Microsoft Excel Professional Data Analysis Tutorial 📊:\n\n"
              "1️⃣ **Core Logic Formulas**:\n"
              "   - **IF logic**: `=IF(E2>=90, \"A Grade\", \"B Grade\")` - returns text dynamically based on numeric cell parameters.\n"
              "   - **SUMIFS**: `=SUMIFS(C2:C100, B2:B100, \"Laptop\")` - sums numbers in range C2:C100 only if the corresponding cell in B2:B100 matches the category 'Laptop'.\n\n"
              "2️⃣ **VLOOKUP (Vertical Search Engine)**:\n"
              "   - **Syntax**: `=VLOOKUP(lookup_value, table_array, col_index, [range_lookup])`\n"
              "   - **Step-by-Step Example**: Suppose cell A2 holds ID 'EMP12'. `=VLOOKUP(A2, Sheet2!A2:E500, 3, FALSE)`. This finds 'EMP12' in Sheet2 range A2:E500 and retrieves the value from the 3rd column (e.g. Employee Department).\n\n"
              "3️⃣ **XLOOKUP (Advanced Modern Standard)**:\n"
              "   - **Syntax**: `=XLOOKUP(lookup_val, lookup_range, return_range, [if_not_found])`\n"
              "   - **Example**: `=XLOOKUP(\"EMP12\", A2:A100, D2:D100, \"Not Found\")`. It searches column A for 'EMP12' and fetches the phone number from column D. It requires no column indexes and searches bidirectionally.\n\n"
              "4️⃣ **Pivot Tables**: Transform millions of raw rows into compact grid matrices. Go to 'Insert' ➔ 'PivotTable'. Drag fields into Rows (e.g. Regions) and Values (e.g. Sum of Sales) to dynamically structure charts.";
        }
      } else if (query.contains("mail merge") || query.contains("macro") || query.contains("word") || query.contains("typing") || query.contains("document") || query.contains("format")) {
        if (isHindi) {
          aiResponse = "एमएस वर्ड और डॉक्यूमेंट फॉर्मेटिंग गाइड (Professional Level) 📄:\n\n"
              "1️⃣ **मेल मर्ज (Mail Merge - समूह पत्र भेजने की विधि)**:\n"
              "   - **उपयोग**: जब आपको एक ही पत्र को 500 ग्राहकों को भेजना हो और सभी के पत्र पर उनका व्यक्तिगत नाम और पता लिखना हो।\n"
              "   - **कदम**: 'Mailings' टैब पर जाएं ➔ 'Start Mail Merge' ➔ 'Letters' चुनें ➔ 'Select Recipients' पर क्लिक करके अपनी एक्सेल फाइल लोड करें ➔ 'Insert Merge Field' पर क्लिक करके नाम और पते की जगह सेट करें ➔ 'Finish & Merge' पर क्लिक करें।\n\n"
              "2️⃣ **मैक्रोज़ और स्वचालन (Macros - Automation)**:\n"
              "   - **विवरण**: यह बार-बार दोहराए जाने वाले माउस क्लिक और टाइपिंग को रिकॉर्ड करता है।\n"
              "   - **कदम**: 'View' टैब पर जाएं ➔ 'Macros' ➔ 'Record Macro' पर क्लिक करें ➔ एक शॉर्टकट कुंजी (जैसे Alt+K) असाइन करें ➔ रिकॉर्डिंग शुरू होने पर अपना कार्य करें ➔ मैक्रो स्टॉप करें। अब Alt+K दबाते ही वह कार्य तुरंत हो जाएगा।\n\n"
              "3️⃣ **सेक्शन ब्रेक (Section Breaks)**:\n"
              "   - 'Layout > Breaks > Next Page' पर जाएं। इसका उपयोग करके आप दस्तावेज़ के पहले 2 पन्नों को पोर्ट्रेट और तीसरे पन्ने को लैंडस्केप (landscape) लेआउट में सेट कर सकते हैं।";
        } else {
          aiResponse = "Microsoft Word Professional Formatting & Templates Tutorial 📄:\n\n"
              "1️⃣ **Mail Merge Automation (Mass Mailings)**:\n"
              "   - **Purpose**: Instantly generates personalized invoices, certificates, or envelopes from a common list source.\n"
              "   - **Step-by-Step**: Go to 'Mailings' tab ➔ click 'Start Mail Merge' ➔ select 'Letters' ➔ choose 'Select Recipients > Use an Existing List' and upload your Excel sheet ➔ place the cursor where you want names and click 'Insert Merge Field' ➔ click 'Finish & Merge' to generate a multi-page document.\n\n"
              "2️⃣ **VBA Macros (Task Recording)**:\n"
              "   - **Purpose**: Automates repetitive formatting routines.\n"
              "   - **Step-by-Step**: Go to 'View > Macros > Record Macro' ➔ name it and bind to a hotkey (like Alt+Shift+F) ➔ perform formatting operations (e.g. blue color, bold, size 14, center) ➔ click 'Stop Recording'. Now, whenever Alt+Shift+F is pressed, the layout formatting is applied instantly.\n\n"
              "3️⃣ **Formatting Page Layouts**: Insert section breaks under 'Layout > Breaks > Next Page' to isolate pages. This allows mixing different header styles or paper orientations (portrait and landscape) inside the same document.";
        }
      } else if (query.contains("slide master") || query.contains("transition") || query.contains("animation") || query.contains("powerpoint") || query.contains("slide") || query.contains("presentation")) {
        if (isHindi) {
          aiResponse = "एमएस पावरपॉइंट प्रोफेशनल प्रेजेंटेशन निर्माण 📉:\n\n"
              "1️⃣ **स्लाइड मास्टर (Slide Master - मूल डिजाइन प्रणाली)**:\n"
              "   - **महत्व**: यदि आप चाहते हैं कि आपके सभी 50 स्लाइडों पर आपकी कंपनी का लोगो और फॉन्ट एक जैसा दिखे, तो अलग-अलग करने के बजाय स्लाइड मास्टर में बदलाव करें।\n"
              "   - **कदम**: 'View' टैब पर जाएं ➔ 'Slide Master' चुनें ➔ सबसे ऊपर वाली मास्टर स्लाइड में लोगो लगाएं और फॉन्ट चुनें। 'Close Master View' करने पर यह स्वतः सभी स्लाइडों पर लागू हो जाएगा।\n\n"
              "2️⃣ **Morph ट्रांजिशन (आधुनिक एनिमेशन प्रभाव)**:\n"
              "   - **उपयोग**: यह दो स्लाइडों के बीच की आकृतियों को सुचारू रूप से बदलता (smooth transition) है।\n"
              "   - **कदम**: पहली स्लाइड पर एक वृत्त (circle) बनाएं ➔ स्लाइड को डुप्लीकेट करें ➔ दूसरी स्लाइड पर उस वृत्त को बड़ा करें और दाईं ओर खिसकाएं ➔ 'Transitions' में जाकर **'Morph'** चुनें।\n\n"
              "3️⃣ **शॉर्टकट कुंजी**:\n"
              "   - F5: प्रेजेंटेशन को पहले पन्ने से शुरू करता है।\n"
              "   - Shift + F5: वर्तमान खुली हुई स्लाइड से शो चलाता है।";
        } else {
          aiResponse = "Microsoft PowerPoint Professional Deck Design Tutorial 📉:\n\n"
              "1️⃣ **Slide Master Layouts (Corporate Brand Standards)**:\n"
              "   - **Purpose**: Governs global slide templates, logo watermarks, and font sizes to ensure uniform slides without manual styling.\n"
              "   - **Step-by-Step**: Go to 'View' tab ➔ select 'Slide Master' ➔ edit the top master layout card. Insert your custom company logo and set headers. Click 'Close Master View'. All current and future slides will reflect this template.\n\n"
              "2️⃣ **Morph Transition (Advanced Motion Effects)**:\n"
              "   - **Purpose**: Creates highly premium, fluid movement animations of shapes and text moving across sequential slides.\n"
              "   - **Step-by-Step**: Place an image on Slide 1 ➔ Duplicate Slide 1 ➔ On Slide 2, scale the image up and relocate it to the opposite corner ➔ Go to 'Transitions' tab and select **'Morph'**.\n\n"
              "3️⃣ **Keyboard Shortcuts**:\n"
              "   - F5: Begins the slideshow presentation from slide 1.\n"
              "   - Shift + F5: Initiates presentation from the current active slide.";
        }
      } else if (query.contains("computer") || query.contains("what is computer") || query.contains("generation")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर वास्तुकला, प्रकार और इतिहास का गहन ज्ञान 💻:\n\n"
              "1️⃣ **कंप्यूटर की परिभाषा और बुनियादी घटक**:\n"
              "   - कंप्यूटर एक डिजिटल इलेक्ट्रॉनिक मशीन है जो यूजर से डेटा (Input) लेती है, उसे सीपीयू में प्रोसेस (Process) करती है, और एक व्यवस्थित अर्थपूर्ण आउटपुट (Output) देती है।\n"
              "   - **वॉन न्यूमैन आर्किटेक्चर (Von Neumann)**: इसमें पांच मुख्य भाग होते हैं: Control Unit (सिग्नल भेजना), ALU (गणित करना), Main Memory (RAM), Secondary Storage (हार्ड ड्राइव) और Input/Output इंटरफेस।\n\n"
              "2️⃣ **कंप्यूटर की पीढ़ियों का इतिहास (History & Evolution)**:\n"
              "   - **पहली पीढ़ी (1940-1956)**: *वैक्यूम ट्यूब (Vacuum Tubes)* का उपयोग। ये बहुत बड़े थे और भारी मात्रा में गर्मी पैदा करते थे (उदा: ENIAC, EDVAC)।\n"
              "   - **दूसरी पीढ़ी (1956-1963)**: *ट्रांजिस्टर (Transistors)* का आगमन। ये छोटे, तेज और सस्ते थे (उदा: IBM 7090)।\n"
              "   - **तीसरी पीढ़ी (1963-1971)**: *इंटीग्रेटेड सर्किट (IC)* का उपयोग। एक सिंगल सिलिकॉन चिप पर सैकड़ों ट्रांजिस्टर लगाया गए।\n"
              "   - **चौथी पीढ़ी (1971-वर्तमान)**: *माइक्रोप्रोसेसर (Microprocessor)*। बहुत बड़े पैमाने पर एकीकरण (VLSI) करके पूरा CPU एक चिप पर बनाया गया (उदा: Intel 4004)।\n"
              "   - **पांचवीं पीढ़ी (भविष्य)**: *आर्टिफिशियल इंटेलिजेंस (AI)*, सुपरकंप्यूटर, क्वांटम कंप्यूटिंग और रोबोटिक्स।";
        } else {
          aiResponse = "Computer Architecture, Systems Science & History 💻:\n\n"
              "1️⃣ **Core Engineering Architecture (Von Neumann Design)**:\n"
              "   - Governed by 5 distinct hardware blocks connected by system buses:\n"
              "     1. CPU (Central Processing Unit) containing ALU (calculates math) and Control Unit (coordinates timing clock cycles).\n"
              "     2. Main Memory (RAM) for working process storage.\n"
              "     3. Secondary Storage (SSD/HDD) for persistent file storage.\n"
              "     4. Input interfaces (keyboard, mouse) and Output channels (monitors, printers).\n\n"
              "2️⃣ **Generations of Computing History**:\n"
              "   - **1st Gen (1940-1956 - Vacuum Tubes)**: Used thermionic valves to amplify electrical currents. Massive power draw and heat generation (e.g. ENIAC, UNIVAC).\n"
              "   - **2nd Gen (1956-1963 - Transistors)**: Replaced vacuum tubes with solid-state transistors, radically reducing physical size and execution speed.\n"
              "   - **3rd Gen (1963-1971 - Integrated Circuits)**: Printed multiple transistors onto a single silicon semiconductor wafer (ICs) for mass production.\n"
              "   - **4th Gen (1971-Present - Microprocessors)**: Integrated an entire CPU's logic gates onto one silicon microchip using VLSI (Very Large Scale Integration).\n"
              "   - **5th Gen (Next Gen - Parallel & AI)**: Exploiting superconducting materials for quantum calculations, parallel grid processing, and artificial neural networks.";
        }
      } else if (query.contains("hardware") || query.contains("ram") || query.contains("rom") || query.contains("cpu") || query.contains("processor") || query.contains("storage") || query.contains("motherboard")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर हार्डवेयर और आंतरिक घटक (System Hardware & Components) 🔌:\n\n"
              "1️⃣ **CPU (सेंट्रल प्रोसेसिंग यूनिट - प्रोसेसर)**:\n"
              "   - इसे कंप्यूटर का हृदय और मस्तिष्क कहते हैं। यह प्रति सेकंड अरबों निर्देशों को प्रोसेस करता है। प्रोसेसर की गति **गीगाहर्ट्ज़ (GHz)** में मापी जाती है (उदा: 3.5 GHz का मतलब 3.5 अरब क्लॉक चक्र प्रति सेकंड)। इसमें ALU (Arithmetic Logic Unit) और Control Unit होते हैं।\n\n"
              "2️⃣ **RAM बनाम ROM (मेमोरी के प्रकार)**:\n"
              "   - **RAM (Random Access Memory)**: यह एक प्राथमिक वोलेटाइल (अस्थायी) मेमोरी है। यह वर्तमान में निष्पादित हो रहे प्रोग्रामों का डेटा होल्ड करती है। बिजली कटने पर इसका सारा डेटा मिट जाता है (उदा: DDR4, DDR5 RAM)।\n"
              "   - **ROM (Read Only Memory)**: यह नॉन-वोलेटाइल (स्थायी) होती है। इसमें मदरबोर्ड बनाने वाली कंपनी द्वारा 'BIOS/UEFI' प्रोग्राम राइट किया जाता है, जो कंप्यूटर को बूट करने और हार्डवेयर का परीक्षण करने (POST) का कार्य करता है।\n\n"
              "3️⃣ **SSD बनाम HDD (स्टोरेज टेक्नोलॉजी)**:\n"
              "   - **HDD (Hard Disk Drive)**: चुंबकीय डिस्क होती है जो गोल घूमती है। यह सस्ती होती है पर धीमी होती है (गति लगभग 100 MB/s)।\n"
              "   - **SSD (Solid State Drive)**: यह फ्लैश मेमोरी का उपयोग करती है (कोई घूमने वाला भाग नहीं)। इसकी गति 1000 MB/s से 7000 MB/s तक होती है, जिससे कंप्यूटर तुरंत बूट होता है।";
        } else {
          aiResponse = "Computer Hardware & Micro-Component Engineering 🔌:\n\n"
              "1️⃣ **CPU Logic Core Design**:\n"
              "   - The microprocessor contains millions of microscopic logic gates. It features two prime compartments:\n"
              "     - **ALU (Arithmetic Logic Unit)**: Executes arithmetic functions ($+, -, \\times, \\div$) and logical comparisons ($<, >, =$).\n"
              "     - **CU (Control Unit)**: Directs the data flow inside the motherboard and translates assembly instructions into execution signals.\n\n"
              "2️⃣ **Volatile vs. Non-Volatile Memory**:\n"
              "   - **RAM (Random Access Memory)**: Primary volatile storage. High bandwidth channels feed data from storage to CPU cache. Loses memory charge once power supply shuts off.\n"
              "   - **ROM (Read-Only Memory)**: Permanent silicon storage. Contains the bootloader firmware (BIOS or modern UEFI) which runs a POST (Power-On Self-Test) routine to boot hardware controllers.\n\n"
              "3️⃣ **Solid State Drives (SSD) vs. Hard Disk Drives (HDD)**:\n"
              "   - **HDD**: Relies on a mechanical read/write arm traversing rotating magnetic platters (5400/7200 RPM). Prone to mechanical failure and shock.\n"
              "   - **SSD (SATA / NVMe)**: Uses NAND flash memory blocks. Lacks moving parts. SATA SSDs transfer at ~550 MB/s, while PCIe NVMe SSDs easily exceed 7000 MB/s.";
        }
      } else if (query.contains("software") || query.contains("operating system") || query.contains("windows") || query.contains("linux") || query.contains("os")) {
        if (isHindi) {
          aiResponse = "सॉफ्टवेयर और ऑपरेटिंग सिस्टम की संरचना 💿:\n\n"
              "1️⃣ **सॉफ्टवेयर वर्गीकरण (Software Categories)**:\n"
              "   - **सिस्टम सॉफ्टवेयर (System Software)**: जो कंप्यूटर हार्डवेयर को मैनेज और कंट्रोल करता है। उदा: ऑपरेटिंग सिस्टम (OS), कंपाइलर, असेंबलर, डिवाइस ड्राइवर्स।\n"
              "   - **एप्लीकेशन सॉफ्टवेयर (Application Software)**: यूजर के विशिष्ट कार्यों के लिए बनाए गए प्रोग्राम। उदा: MS Office, वेब ब्राउज़र (Chrome), फोटोशॉप, वीडियो प्लेयर।\n\n"
              "2️⃣ **ऑपरेटिंग सिस्टम (OS) के मुख्य कार्य**:\n"
              "   - **मेमोरी मैनेजमेंट**: RAM में प्रोसेस को स्पेस देना और खाली करना।\n"
              "   - **प्रोसेस मैनेजमेंट**: सीपीयू शेड्यूलिंग एल्गोरिदम (जैसे Round Robin, FIFO) द्वारा तय करना कि कौन सा प्रोग्राम पहले चलेगा।\n"
              "   - **फाइल सिस्टम मैनेजमेंट**: हार्ड ड्राइव पर डेटा को स्टोर और इंडेक्स करना (उदा: NTFS, FAT32 फाइल सिस्टम)।\n\n"
              "3️⃣ **प्रमुख ओएस प्लेटफॉर्म**:\n"
              "   - **Windows**: डेस्कटॉप कंप्यूटरों में सबसे ज्यादा लोकप्रिय। उपयोगकर्ता के अनुकूल जीयूआई (GUI)।\n"
              "   - **Linux**: ओपन-सोर्स (मुफ्त कोड), वायरस-मुक्त और सबसे सुरक्षित। सर्वर और हैकिंग में 90% से ज्यादा उपयोग।";
        } else {
          aiResponse = "Software Classification & Operating System Architecture 💿:\n\n"
              "1️⃣ **Software Systems Hierarchy**:\n"
              "   - **System Software**: Governs the machine layers. Contains device drivers, system utilities, compilers, and the core Operating System.\n"
              "   - **Application Software**: User-facing programs executing end tasks, e.g. web browsers, databases, accounting tools, or games.\n\n"
              "2️⃣ **Primary Kernel Services of an Operating System (OS)**:\n"
              "   - **Process Scheduling**: Distributes CPU cores to active task processes using algorithms like Round Robin or Shortest Job First.\n"
              "   - **Memory Management**: Allocates stack/heap space in RAM and prevents memory leaks or program crashes.\n"
              "   - **I/O Device Handling**: Bridges communication using device drivers.\n"
              "   - **File Systems**: Organizes files into directories using tables like NTFS (Windows) or Ext4 (Linux).\n\n"
              "3️⃣ **Windows vs. Linux Kernels**:\n"
              "   - **Windows**: Relies on a hybrid monolithic kernel. Excellent desktop ecosystem and graphics drivers.\n"
              "   - **Linux**: Uses a monolithic open-source kernel. Extremely robust, modular, secure, and drives 96% of the world's supercomputers and cloud platforms.";
        }
      } else if (query.contains("network") || query.contains("internet") || query.contains("ip address") || query.contains("dns") || query.contains("protocol") || query.contains("wifi") || query.contains("router")) {
        if (isHindi) {
          aiResponse = "नेटवर्किंग, इंटरनेट और प्रोटोकॉल का संपूर्ण विवरण 🌐:\n\n"
              "1️⃣ **IP एड्रेस (Internet Protocol Address - पहचान पता)**:\n"
              "   - नेटवर्क पर जुड़े हर डिवाइस का एक विशिष्ट पता होता है।\n"
              "   - **IPv4**: 32-बिट का होता है, डॉट द्वारा विभाजित होता है (उदा: 192.168.1.1)। इसकी सीमा लगभग 4.3 अरब पते हैं।\n"
              "   - **IPv6**: 128-बिट का होता है, हेक्साडेसिमल में लिखा जाता है (उदा: 2001:db8::ff00:42:8329)। यह असीमित संख्या में पते प्रदान करता है।\n\n"
              "2️⃣ **DNS (Domain Name System - इंटरनेट की फोनबुक)**:\n"
              "   - हम ब्राउज़र में 'google.com' लिखते हैं। कंप्यूटर इस नाम को नहीं समझता। DNS सर्वर इस नाम को सर्वर के वास्तविक आईपी पते (जैसे 142.250.190.46) में बदल देता है, जिससे वेबसाइट लोड होती है।\n\n"
              "3️⃣ **नेटवर्क प्रोटोकॉल (प्रोटोकॉल का अर्थ नियम है)**:\n"
              "   - **HTTP/HTTPS**: वेब पेजों को सुरक्षित रूप से डाउनलोड करने के लिए। (S = Secure SSL)।\n"
              "   - **TCP**: डेटा को छोटे पैकेटों में तोड़कर बिना किसी नुकसान के गंतव्य तक पहुँचाता है (विश्वसनीय)।\n"
              "   - **SMTP**: ईमेल भेजने के लिए उपयोग होने वाला मुख्य प्रोटोकॉल।";
        } else {
          aiResponse = "Computer Networks, Protocols & Internet Infrastructure 🌐:\n\n"
              "1️⃣ **IP Address Formats (Device Identifiers)**:\n"
              "   - **IPv4**: A 32-bit address split into 4 octets separated by decimals (e.g., 192.168.1.50). Limits global addresses to ~4.3 billion.\n"
              "   - **IPv6**: A 128-bit hexadecimal addressing format designed to handle the billions of IoT devices globally. E.g. `2001:0db8:85a3:0000:0000:8a2e:0370:7334`.\n"
              "2️⃣ **Domain Name System (DNS - Resolution Pipeline)**:\n"
              "   - Converts human domains (e.g. `google.com`) to computer-readable numerical IP addresses. When you enter a URL, the router queries a DNS Resolver, which checks Root, TLD, and Authoritative Name Servers to return the IP address.\n\n"
              "3️⃣ **Core Protocol Suites**:\n"
              "   - **TCP/IP**: TCP establishes the connection handshakes, guarantees packet sequence delivery, and handles packet errors. IP handles routing and addressing.\n"
              "   - **HTTP/HTTPS**: Hypertext Transfer Protocol. HTTPS encrypts packets using SSL/TLS certificates over port 443.";
        }
      } else if (query.contains("database") || query.contains("sql") || query.contains("dbms") || query.contains("nosql")) {
        if (isHindi) {
          aiResponse = "डेटाबेस मैनेजमेंट सिस्टम (DBMS & SQL Advanced) 🗄️:\n\n"
              "1️⃣ **रिलेशनल डेटाबेस (RDBMS - रिलेशनल डेटाबेस)**:\n"
              "   - डेटा को परस्पर जुड़ी तालिकाओं (tables - rows और columns) में व्यवस्थित किया जाता है। उदा: MySQL, Oracle, PostgreSQL।\n"
              "   - **कुंजियाँ (Keys)**:\n"
              "     - **Primary Key**: जो तालिका के प्रत्येक रिकॉर्ड को विशिष्ट रूप से अलग पहचानती है (उदा: Student ID, Roll No)। यह कभी खाली नहीं हो सकती।\n"
              "     - **Foreign Key**: जो दो तालिकाओं को आपस में लिंक करती है।\n\n"
              "2️⃣ **SQL (स्ट्रक्चर्ड क्वेरी लैंग्वेज - डेटाबेस भाषा)**:\n"
              "   - डेटा खोजने और जोड़ने के लिए उपयोग होने वाली भाषा।\n"
              "   - **क्वेरी का उदाहरण**: `SELECT name, class FROM students WHERE grade = 'A' ORDER BY name ASC;`\n"
              "     (यह उन छात्रों के नाम और कक्षा को वर्णानुक्रम में लाएगा जिनका ग्रेड 'A' है)।\n\n"
              "3️⃣ **NoSQL (नॉन-रिलेशनल डेटाबेस)**:\n"
              "   - यह तालिकाओं का उपयोग नहीं करता, बल्कि JSON-जैसे दस्तावेजों में डेटा रखता है (उदा: MongoDB, Firebase Firestore)। यह अत्यधिक लचीला और स्केलेबल होता है।";
        } else {
          aiResponse = "Database Management Systems (DBMS) & Data Modeling 🗄️:\n\n"
              "1️⃣ **Relational Databases (RDBMS)**:\n"
              "   - Stores data inside rigid grid tables mapping rows (records) to columns (attributes). Governed by ACID principles (Atomicity, Consistency, Isolation, Durability) to ensure crash-proof data.\n"
              "   - **Relational Keys**:\n"
              "     - **Primary Key**: A column holding unique, non-null values that identify each row (e.g. Student_ID).\n"
              "     - **Foreign Key**: A column pointing to the primary key of another table, creating relational links.\n\n"
              "2️⃣ **SQL Query Syntax and Logic Examples**:\n"
              "   - Query: Find top-scoring students in Class 10:\n"
              "     ```sql\n"
              "     SELECT student_id, name, score \n"
              "     FROM class_10_students \n"
              "     WHERE score > 90 \n"
              "     ORDER BY score DESC;\n"
              "     ```\n\n"
              "3️⃣ **NoSQL Architecture**:\n"
              "   - Key-Value, Document (JSON), Column, or Graph-based. E.g., MongoDB, or Firebase Firestore which stores items as nested key-value documents, ideal for high-speed dynamic scaling.";
        }
      } else if (query.contains("coding") || query.contains("programming") || query.contains("python") || query.contains("java") || query.contains("c++") || query.contains("javascript") || query.contains("compiler") || query.contains("loop") || query.contains("algorithm")) {
        if (isHindi) {
          aiResponse = "प्रोग्रामिंग, कोडिंग और सॉफ्टवेयर डेवलपमेंट लॉजिक 💻:\n\n"
              "1️⃣ **प्रमुख भाषाओं की गहरी समझ**:\n"
              "   - **Python**: सीखने में सबसे आसान। आर्टिफिशियल इंटेलिजेंस (AI), मशीन लर्निंग, डेटा साइंस और स्क्रिप्टिंग की दुनिया की सर्वश्रेष्ठ भाषा।\n"
              "     - *उदाहरण कोड*:\n"
              "       ```python\n"
              "       # Python Print & Loop\n"
              "       for i in range(1, 6):\n"
              "           print(f\"Hello AKH: {i}\")\n"
              "       ```\n"
              "   - **Java**: पूरी तरह ऑब्जेक्ट-ओरिएंटेड। यह प्लेटफॉर्म-स्वतंत्र है (JVM के कारण)। एंड्रॉइड ऐप्स और बैंकिंग सॉफ्टवेयर में व्यापक उपयोग।\n"
              "   - **C++**: सबसे तेज प्रोग्रामिंग भाषा। इसका उपयोग ऑपरेटिंग सिस्टम, गेम इंजन (Unreal Engine) और 3D सॉफ्टवेयर बनाने में होता है।\n"
              "   - **JavaScript**: वेब डेवलपमेंट की रीढ़। वेबसाइटों को जीवित और इंटरैक्टिव बनाती है।\n\n"
              "2️⃣ **कंपाइलर बनाम इंटरप्रेटर (Compiler vs Interpreter)**:\n"
              "   - **कंपाइलर (Compiler)**: पूरे कोड को एक साथ मशीन कोड (EXE) में बदल देता है (उदा: C++), यह बहुत तेज होता है।\n"
              "   - **इंटरप्रेटर (Interpreter)**: कोड को लाइन-बाय-लाइन पढ़ता है और चलाता है (उदा: Python)। यह एरर ढूंढने में आसान है पर थोड़ा धीमा है।";
        } else {
          aiResponse = "Advanced Programming Languages, Compiler Design & Software Logic 💻:\n\n"
              "1️⃣ **Core Languages Compared**:\n"
              "   - **Python**: Interpreted, dynamic typing. Ideal for AI, mathematical analysis, and data engineering.\n"
              "     - *Code Example*:\n"
              "       ```python\n"
              "       # Print numbers from 1 to 5\n"
              "       for i in range(1, 6):\n"
              "           print(f\"Value is: {i}\")\n"
              "       ```\n"
              "   - **Java**: Compiled object-oriented language. Compiles to Java Bytecode which runs on any JVM (Java Virtual Machine), ensuring complete platform portability.\n"
              "   - **C++**: Statically typed, compiled language offering raw memory control through Pointers. Used for game engines and systems software.\n"
              "   - **JavaScript**: Prototype-based scripting powering frontend browser layouts and servers via Node.js.\n\n"
              "2️⃣ **Execution: Compilers vs. Interpreters**:\n"
              "   - **Compilers**: Translate the entire source code into binary machine code files beforehand (e.g. `.exe` in C++), executing extremely fast.\n"
              "   - **Interpreters**: Translate and run the code line-by-line during runtime (e.g. Python, JS), slower but allows rapid debugging.";
        }
      } else if (query.contains("office") || query.contains("ms office") || query.contains("computer science")) {
        if (isHindi) {
          aiResponse = "एमएस ऑफिस और कंप्यूटर शिक्षा (Complete Suite Details) 💻:\n\n"
              "एमएस ऑफिस व्यावसायिक कार्यों के लिए दुनिया का सबसे पसंदीदा सुइट है:\n"
              "1️⃣ **एमएस वर्ड (MS Word)**: पत्र, प्रमाण पत्र, असाइनमेंट, और नोट्स तैयार करने का वर्ड प्रोसेसर। (उन्नत सीखें: Mail Merge, Macros, Tables)।\n"
              "2️⃣ **एमएस एक्सेल (MS Excel)**: संख्यात्मक डेटा, बजट रिपोर्ट, और ग्राफ बनाने की स्प्रेडशीट। (उन्नत सीखें: XLOOKUP, Pivot Tables, SUMIFS)।\n"
              "3️⃣ **एमएस पावरपॉइंट (MS PowerPoint)**: शैक्षणिक और व्यावसायिक विषयों को प्रस्तुत करने का स्लाइड शो टूल। (उन्नत सीखें: Slide Master, Morph Animation, SmartArt)।\n"
              "4️⃣ **एमएस आउटलुक (MS Outlook)**: ईमेल भेजने, कैलेंडर मैनेज करने, और बैठकों को शेड्यूल करने का टूल।\n\n"
              "💡 **सलाह**: आप किस प्रोग्राम के फॉर्मूले या शॉर्टकट को विस्तार से सीखना चाहते हैं? उसका नाम लिखें (जैसे: 'vlookup', 'mail merge', 'slide master')!";
        } else {
          aiResponse = "Microsoft Office Suite & Computer Science Core 💻:\n\n"
              "Microsoft Office is the industry standard for business workflow automation:\n"
              "1️⃣ **MS Word**: Document creation and typesetting engine. (Advanced concepts: Mail Merge, Custom Macros, and Styles).\n"
              "2️⃣ **MS Excel**: Grid-based computational sheet. (Advanced concepts: Data modeling, Pivot Charts, SUMIFS, XLOOKUP).\n"
              "3️⃣ **MS PowerPoint**: Slide deck creation utility. (Advanced concepts: Slide Master layouts, Custom Morph animations, and audio transitions).\n"
              "4️⃣ **MS Outlook**: Information manager for email communication, calendars, and tasks.\n\n"
              "💡 **Tip**: Enter a specific function you wish to explore (e.g., type 'vlookup' for Excel formulas, or 'mail merge' for Word automation) to see step-by-step guides!";
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

  Widget _buildLanguageToggleItem(String lang, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        setState(() {
          _selectedLanguage = lang;
          final isHindi = lang == 'Hindi';
          _messages.add(
            MessageBubble(
              text: isHindi 
                ? "भाषा बदलकर हिंदी कर दी गई है। अब आप हिंदी में सवाल पूछ सकते हैं!"
                : "Language changed to English. You can ask doubts in English now!",
              isUser: false,
              time: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.secondaryOrange : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondaryOrange.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          lang,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isHindi = _selectedLanguage == 'Hindi';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Doubt Support', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // 3D Segmented Language Toggle Switch (No flags, solves clipping/dropdown issues)
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2638) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white10 : Colors.white60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageToggleItem('English', !isHindi, isDark),
                _buildLanguageToggleItem('Hindi', isHindi, isDark),
              ],
            ),
          )
        ],
      ),
      body: Container(
        // Modern Premium Diagonal Gradient Background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                : [const Color(0xFFE0F2FE), const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Banner with Bilingual Explanation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.secondaryOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isHindi
                            ? 'अपनी पसंदीदा भाषा चुनें। अगर आप English में भी पूछेंगे, तो भी AI हिंदी में जवाब देगा!'
                            : 'Choose your preferred language. AI will reply in your chosen language even if you type in English!',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white90 : Colors.black87,
                        ),
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
                          // 3D Elevated Speaker Icon Button
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF1E2638) : Colors.white,
                              border: Border.all(
                                color: isSpeakingThis 
                                    ? AppColors.secondaryOrange 
                                    : (isDark ? Colors.white10 : Colors.grey[300]!),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(1, 3),
                                )
                              ]
                            ),
                            child: IconButton(
                              icon: Icon(
                                isSpeakingThis ? Icons.volume_up : Icons.volume_up_outlined,
                                color: isSpeakingThis 
                                  ? AppColors.secondaryOrange 
                                  : (isDark ? Colors.white70 : Colors.black54),
                                size: 18,
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
                          ),
                          const SizedBox(width: 8),
                        ],
                        // 3D Card Glassmorphic Message Bubbles
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
                          decoration: BoxDecoration(
                            gradient: message.isUser
                                ? const LinearGradient(
                                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: isDark
                                        ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                                        : [Colors.white, const Color(0xFFF9FAFB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(message.isUser ? 20 : 0),
                              bottomRight: Radius.circular(message.isUser ? 0 : 20),
                            ),
                            border: Border.all(
                              color: message.isUser
                                  ? Colors.white12
                                  : (isDark ? Colors.white10 : Colors.grey[200]!),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: message.isUser
                                    ? const Color(0xFF4F46E5).withOpacity(0.35)
                                    : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser
                                  ? Colors.white
                                  : (isDark ? Colors.white90 : Colors.black87),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
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
              
            // 3D Elevated Tray Input bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2638) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: isDark ? Colors.blue.withOpacity(0.05) : Colors.blue.withOpacity(0.02),
                            blurRadius: 20,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Type your doubt here...',
                          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 3D Circular Floating Send Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        )
                      ]
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
