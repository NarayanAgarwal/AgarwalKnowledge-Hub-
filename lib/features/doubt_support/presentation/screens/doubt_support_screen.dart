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
  String _selectedLanguage = 'English'; // 'English' or 'Hindi'

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
          aiResponse = "Let's learn Hindi Varnmala ✍️:\n\nVowels: अ (Anar 🍒), आ (Aam 🥭), इ (Imli 🫒)...\nConsonants: क (Kabootar 🕊️), ख (Khargosh 🐇), ग (Gamla 🪴)...\n\nOpen the 'Play Study' tab on your Home screen to hear correct pronunciations!";
        }
      } else if (query.contains("fraction")) {
        if (isHindi) {
          aiResponse = "गणित की शंका हल! 🔢 भिन्न (Fraction) एक संपूर्ण के हिस्से को दर्शाता है (अंश/हर)। उदाहरण के लिए, 3/4 का अर्थ है 4 बराबर भागों में से 3 भाग। समान हर वाले भिन्न को सीधे अंश जोड़कर जोड़ा जाता है (उदा. 1/5 + 2/5 = 3/5)।";
        } else {
          aiResponse = "Math doubt solved! 🔢 A fraction represents a part of a whole (Numerator/Denominator). For example, 3/4 means 3 parts out of 4 equal parts. To add fractions with common denominators, add their numerators directly (e.g., 1/5 + 2/5 = 3/5).";
        }
      } else if (query.contains("math") || query.contains("sum") || query.contains("add") || query.contains("multiply") || query.contains("divide") || query.contains("algebra") || query.contains("geometry")) {
        if (isHindi) {
          aiResponse = "गणित शिक्षक गाइड (कक्षा 1-10) 📐:\n1. अंकगणित: BODMAS नियम गणना का क्रम तय करता है (कोष्ठक, क्रम, भाग, गुणा, जोड़, घटाव)।\n2. ज्यामिति: आयत की परिधि = 2*(लंबाई + चौड़ाई)। वृत्त का क्षेत्रफल = π * r^2।\n3. बीजगणित: x का मान निकालने के लिए चर पदों को एक तरफ और अचर को दूसरी तरफ रखें (उदा: 2x = 10 => x = 5)।";
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
      } else if (query.contains("excel") || query.contains("spreadsheet") || query.contains("formula")) {
        if (isHindi) {
          aiResponse = "माइक्रोसॉफ्ट एक्सेल बेसिक्स 📊:\nएक्सेल एक स्प्रेडशीट टूल है जिसका उपयोग पंक्तियों और स्तंभों में डेटा व्यवस्थित करने के लिए किया जाता है।\n1. सेल का पता: कॉलम लेटर और रो नंबर का चौराहा (जैसे A1)।\n2. सम फॉर्मूला: `=SUM(A1:A5)` सेल A1 से A5 में नंबर जोड़ता है।\n3. औसत फॉर्मूला: `=AVERAGE(B1:B10)` औसत निकालता है।";
        } else {
          aiResponse = "Microsoft Excel Basics 📊:\nExcel is a spreadsheet tool used to organize data in rows and columns.\n1. Cell Address: Intersection of column letter and row number (e.g. A1).\n2. Sum Formula: `=SUM(A1:A5)` adds numbers in cells A1 to A5.\n3. Average Formula: `=AVERAGE(B1:B10)` calculates average.";
        }
      } else if (query.contains("word") || query.contains("typing") || query.contains("format")) {
        if (isHindi) {
          aiResponse = "माइक्रोसॉफ्ट वर्ड बेसिक्स 📄:\nवर्ड एक वर्ड प्रोसेसिंग सॉफ्टवेयर है जिसका उपयोग डॉक्यूमेंट, पत्र और रिपोर्ट टाइप करने के लिए किया जाता है।\n1. शॉर्टकट: Ctrl+C (कॉपी), Ctrl+V (पेस्ट), Ctrl+B (बोल्ड), Ctrl+I (इटैलिक)।\n2. अलाइनमेंट: लेफ्ट, सेंटर, राइट और जस्टिफाइड।";
        } else {
          aiResponse = "Microsoft Word Basics 📄:\nWord is a word processing software used to type documents, letters, and reports.\n1. Shortcuts: Ctrl+C (Copy), Ctrl+V (Paste), Ctrl+B (Bold), Ctrl+I (Italic), Ctrl+U (Underline).\n2. Alignment: Left, Center, Right, and Justified.";
        }
      } else if (query.contains("powerpoint") || query.contains("slide") || query.contains("presentation")) {
        if (isHindi) {
          aiResponse = "माइक्रोसॉफ्ट पावरपॉइंट बेसिक्स 📉:\nपावरपॉइंट का उपयोग प्रस्तुतियों के लिए स्लाइड बनाने के लिए किया जाता है।\n1. स्लाइड: प्रेजेंटेशन का एक सिंगल पेज।\n2. ट्रांजिशन: स्लाइड बदलते समय दिखने वाले एनिमेशन प्रभाव।\n3. स्लाइड शो: फुल स्क्रीन में स्लाइड चलाने के लिए F5 दबाएं।";
        } else {
          aiResponse = "Microsoft PowerPoint Basics 📉:\nPowerPoint is used to build slides for presentations.\n1. Slide: A single page of a presentation.\n2. Transitions: Animation effects that play when moving from one slide to another.\n3. Slide Show: Press F5 shortcut to play slides full screen.";
        }
      } else if (query.contains("office") || query.contains("ms office") || query.contains("computer science")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर विज्ञान और एमएस ऑफिस ट्यूटर 💻:\nहम सिखाते हैं:\n1. एमएस वर्ड: टाइपिंग और फॉर्मेटिंग।\n2. एमएस एक्सेल: फॉर्मूले `=SUM()` और चार्ट।\n3. एमएस पावरपॉइंट: स्लाइड्स बनाना।\nआप आज इनमें से कौन सा प्रोग्राम पढ़ रहे हैं?";
        } else {
          aiResponse = "Computer Science & MS Office Tutor 💻:\nWe teach:\n1. MS Word: Typing and formatting text.\n2. MS Excel: Spreadsheet formulas `=SUM()` and charts.\n3. MS PowerPoint: Interactive slide decks.\nWhich of these programs are you studying today?";
        }
      } else if (query.contains("admission") || query.contains("join") || query.contains("fee") || query.contains("class") || query.contains("register")) {
        if (isHindi) {
          aiResponse = "स्वागत है! अग्रवाल नॉलेज हब (पटना शाखाओं) में नर्सरी से कक्षा 7 और विशिष्ट कंप्यूटर कोर्स के लिए प्रवेश खुले हैं। हम संकल्पनात्मक शिक्षा पर ध्यान केंद्रित करते हैं। पंजीकरण फॉर्म और मासिक शुल्क संबंधी प्रश्नों के लिए कार्यालय में डायरेक्टर अग्रवाल या सुश्री अंजलि वर्मा से संपर्क करें!";
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
                final message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? AppColors.primaryBlue
                          : (isDark ? AppColors.darkSurface : Colors.grey[150]),
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
