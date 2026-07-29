import 'package:flutter/material.dart';
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
      
      if (query.contains("twinkle") || query.contains("rhyme") || query.contains("johny") || query.contains("humpty")) {
        aiResponse = "Here is a classic Baby Rhyme for children 🎵:\n\n'Twinkle, twinkle, little star,\nHow I wonder what you are!\nUp above the world so high,\nLike a diamond in the sky.'\n\nYou can also open the new 'Play Study' tab on your Home screen to see the full Rhymes player!";
      } else if (query.contains("counting") || query.contains("number") || query.contains("counting number")) {
        aiResponse = "Let's count numbers with fun playing style 🔟:\n\n1 (One) 🌟\n2 (Two) 🌟🌟\n3 (Three) 🌟🌟🌟\n4 (Four) 🌟🌟🌟🌟\n5 (Five) 🌟🌟🌟🌟🌟\n\nOpen the 'Play Study' page on the dashboard to tap and see counting stars anims!";
      } else if (query.contains("alphabet") || query.contains("abcd")) {
        aiResponse = "Let's learn English Alphabets 🔠:\n\nA for Apple 🍎\nB for Ball ⚽\nC for Cat 🐱\nD for Dog 🐶\n\nYou can explore A to Z cards in the 'Play Study' section of the app!";
      } else if (query.contains("swar") || query.contains("vyanjan") || query.contains("varnmala")) {
        aiResponse = "आइए हिंदी वर्णमाला सीखें ✍️:\n\nस्वर (Vowels): अ (अनार 🍎), आ (आम 🥭), इ (इमली 🫒)...\nव्यंजन (Consonants): क (कबूतर 🕊️), ख (खरगोश 🐇), ग (गमला 🪴)...\n\nबच्चों के सीखने के लिए 'Play Study' section में Varnmala tab open करें!";
      } else if (query.contains("fraction")) {
        aiResponse = "Math doubt solved! 🔢 A fraction represents a part of a whole (Numerator/Denominator). For example, 3/4 means 3 parts out of 4 equal parts. To add fractions with common denominators, add their numerators directly (e.g., 1/5 + 2/5 = 3/5).";
      } else if (query.contains("math") || query.contains("sum") || query.contains("add") || query.contains("multiply") || query.contains("divide") || query.contains("algebra") || query.contains("geometry")) {
        aiResponse = "Mathematics Tutor Guide (Standard 1-10) 📐:\n1. Arithmetic: BODMAS rule determines order of operations (Brackets, Order, Division, Multiplication, Addition, Subtraction).\n2. Geometry: Perimeter of rectangle = 2*(length + width). Area of circle = π * r^2.\n3. Algebra: Solve for x by keeping variable terms on one side and constants on other (e.g. 2x = 10 => x = 5).";
      } else if (query.contains("physics") || query.contains("gravity") || query.contains("force") || query.contains("motion") || query.contains("light") || query.contains("electricity")) {
        aiResponse = "Physics Tutor Explanation (Standard 1-10) ⚡:\n1. Force: A push or pull acting upon an object (F = mass * acceleration).\n2. Gravity: An attractive force pulling objects down (acceleration g ≈ 9.8 m/s^2).\n3. Light: Travel in straight lines; reflects off smooth surfaces and refracts when changing mediums.";
      } else if (query.contains("chemistry") || query.contains("acid") || query.contains("base") || query.contains("element") || query.contains("atom") || query.contains("molecule")) {
        aiResponse = "Chemistry Tutor Explanation (Standard 1-10) 🧪:\n1. Atoms: The basic unit of chemical elements, consisting of protons, neutrons, and electrons.\n2. Molecules: Groups of atoms bonded together (e.g., Water is H2O).\n3. Acids & Bases: Acids have pH < 7 (sour, e.g. lemon juice), Bases have pH > 7 (bitter/slippery, e.g. soap). Neutral is pH = 7.";
      } else if (query.contains("biology") || query.contains("cell") || query.contains("plant") || query.contains("photosynthesis") || query.contains("human body")) {
        aiResponse = "Biology Tutor Explanation (Standard 1-10) 🧬:\n1. Cell: Basic structural and functional unit of life. Animal cells have membrane, Plant cells have extra cell wall.\n2. Photosynthesis: Plants use chlorophyll to absorb sunlight, carbon dioxide, and water to manufacture glucose and release oxygen.\n3. Circulation: Heart pumps oxygenated blood from lungs to body organs.";
      } else if (query.contains("science")) {
        aiResponse = "Science Tutor Hub (Standard 1-10) 🔬:\nScience is divided into:\n1. Physics: Study of energy, force, light, and motion.\n2. Chemistry: Study of matter, elements, reactions, and pH scale.\n3. Biology: Study of cells, plant/human body life cycles, and ecosystems.\nTell me which topic you want to learn about!";
      } else if (query.contains("economics") || query.contains("money") || query.contains("demand") || query.contains("supply") || query.contains("market")) {
        aiResponse = "Economics Tutor explanation (Standard 9-10) 📊:\n1. Supply and Demand: Law of Demand states that higher prices lead to lower demand. Law of Supply states that higher prices lead to higher supply.\n2. Sectors of Indian Economy: Primary (Agriculture), Secondary (Manufacturing), Tertiary (Services/IT).";
      } else if (query.contains("history") || query.contains("gandhi") || query.contains("independence") || query.contains("harappa") || query.contains("revolution")) {
        aiResponse = "History Tutor Guide (Standard 1-10) 📜:\n1. Harappan Civilization: An ancient Bronze Age urban culture located near the Indus River basin (famous for brick houses, grid planning, drainage).\n2. Indian Independence: India gained freedom from British rule on 15 August 1947, led by freedom struggles of Mahatma Gandhi (Non-Violence), Subhash Chandra Bose, etc.";
      } else if (query.contains("geography") || query.contains("earth") || query.contains("map") || query.contains("continent") || query.contains("river") || query.contains("soil")) {
        aiResponse = "Geography Tutor explanation (Standard 1-10) 🌍:\n1. Earth Structure: Core (innermost), Mantle (middle silicate layer), Crust (outer solid surface where we live).\n2. Rivers & Oceans: Rivers flow from mountains down to seas. Oceans cover 71% of Earth surface.\n3. Atmosphere: Troposphere (where weather occurs), Stratosphere (holds ozone layer), Mesosphere.";
      } else if (query.contains("english") || query.contains("grammar") || query.contains("noun") || query.contains("verb") || query.contains("tense")) {
        aiResponse = "English Grammar Guide (Standard 1-10) 📝:\n1. Noun: Name of a person, place, thing, or idea (e.g. Aman, Patna, book).\n2. Verb: Actions performed (e.g. write, run, study).\n3. Tenses: Present (I study), Past (I studied), Future (I will study).";
      } else if (query.contains("hindi") || query.contains("vyakaran") || query.contains("sangya") || query.contains("kriya")) {
        aiResponse = "हिंदी व्याकरण सहायक (कक्षा 1-10) ✍️:\n1. संज्ञा (Noun): किसी व्यक्ति, स्थान, या वस्तु के नाम को संज्ञा कहते हैं (जैसे - राम, पटना, किताब)।\n2. क्रिया (Verb): जिस शब्द से किसी काम का करना या होना पाया जाए, उसे क्रिया कहते हैं (जैसे - लिखना, दौड़ना)।\n3. सर्वनाम (Pronoun): संज्ञा के स्थान पर प्रयुक्त होने वाले शब्द (जैसे - वह, तुम, मैं)।";
      } else if (query.contains("excel") || query.contains("spreadsheet") || query.contains("formula")) {
        aiResponse = "Microsoft Excel Basics 📊:\nExcel is a spreadsheet tool used to organize data in rows and columns.\n1. Cell Address: Intersection of column letter and row number (e.g. A1).\n2. Sum Formula: `=SUM(A1:A5)` adds numbers in cells A1 to A5.\n3. Average Formula: `=AVERAGE(B1:B10)` calculates average.";
      } else if (query.contains("word") || query.contains("typing") || query.contains("format")) {
        aiResponse = "Microsoft Word Basics 📄:\nWord is a word processing software used to type documents, letters, and reports.\n1. Shortcuts: Ctrl+C (Copy), Ctrl+V (Paste), Ctrl+B (Bold), Ctrl+I (Italic), Ctrl+U (Underline).\n2. Alignment: Left, Center, Right, and Justified.";
      } else if (query.contains("powerpoint") || query.contains("slide") || query.contains("presentation")) {
        aiResponse = "Microsoft PowerPoint Basics 📉:\nPowerPoint is used to build slides for presentations.\n1. Slide: A single page of a presentation.\n2. Transitions: Animation effects that play when moving from one slide to another.\n3. Slide Show: Press F5 shortcut to play slides full screen.";
      } else if (query.contains("office") || query.contains("ms office") || query.contains("computer science")) {
        aiResponse = "Computer Science & MS Office Tutor 💻:\nWe teach:\n1. MS Word: Typing and formatting text.\n2. MS Excel: Spreadsheet formulas `=SUM()` and charts.\n3. MS PowerPoint: Interactive slide decks.\nWhich of these programs are you studying today?";
      } else if (query.contains("admission") || query.contains("join") || query.contains("fee") || query.contains("class") || query.contains("register")) {
        aiResponse = "Welcome! Admissions are open at Agarwal Knowledge Hub (Patna branches) for Nursery to Class 7 and specialized Computer courses. We focus on conceptual learning and digital tools. For registration forms and monthly fee queries, please consult Director Agarwal or Ms. Anjali Verma at the admin cabin!";
      } else if (query.contains("homework") || query.contains("assignment") || query.contains("due")) {
        aiResponse = "You can access all assigned homework sheets under the 'Homework' tab in your portal. You can download the PDF worksheets, solve them, and submit snapshots directly from the 'Submit' screen. If you have any specific query from a worksheet, type it here!";
      } else if (query.contains("hi") || query.contains("hello") || query.contains("hey") || query.contains("helo")) {
        aiResponse = "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. I can help you solve doubts on Mathematics, Computer Science, and general classroom homework. What subject are you studying today?";
      } else if (query.contains("thank") || query.contains("thanks")) {
        aiResponse = "You're very welcome! Learning is a journey, and we are happy to support you. Let me know if you have any other questions!";
      } else {
        aiResponse = "That's an interesting question about '${text}'! As your AI Doubt Tutor, let's look at this concept:\n\n1. In your Agarwal Knowledge Hub reference curriculum, '${text}' is a key academic topic covered under your course syllabus.\n2. I recommend checking your class details notes or textbook pdf resources in the 'Library' tab.\n3. Write down a practical example or seek direct step-by-step guidance from Ms. Anjali Verma in the next live doubt clearing session!";
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
        title: const Text('AI Doubt Support'),
      ),
      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.secondaryOrange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI tutor solves questions instantly from your textbooks and PDFs.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.primaryBlue
                          : (isDark ? AppColors.darkSurface : Colors.grey[200]),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                        bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondaryOrange),
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
