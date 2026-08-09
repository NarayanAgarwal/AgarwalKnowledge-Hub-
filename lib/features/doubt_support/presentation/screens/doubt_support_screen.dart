import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/js.dart' as js;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
      text: "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. Ask me anything related to your homework, computer, software, hardware, programming, databases, or MS Office (Word, Excel, PowerPoint) in simple words!",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  final _controller = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  String _selectedLanguage = 'English'; // 'English' or 'Hindi'
  String? _currentlySpeakingText;
  String _geminiApiKey = '';

  @override
  void initState() {
    super.initState();
    _loadApiKey();
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
    _apiKeyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _geminiApiKey = prefs.getString('gemini_api_key') ?? '';
        _apiKeyController.text = _geminiApiKey;
      });
    } catch (e) {
      debugPrint("Error loading API key: $e");
    }
  }

  Future<void> _saveApiKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gemini_api_key', key);
      setState(() {
        _geminiApiKey = key;
      });
    } catch (e) {
      debugPrint("Error saving API key: $e");
    }
  }

  Future<String?> _callGeminiApi(String query) async {
    if (_geminiApiKey.isEmpty) return null;
    
    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': "System Instruction: You are the AI Doubt Assistant at Agarwal Knowledge Hub for school children. Explain academic doubts in extremely simple language with concrete everyday examples. Do not use double asterisks (**) or backticks (`) in your response. Keep headings simple. If the query is in Hindi or roman Hindi (Hinglish), reply in simple Hindi. Make sure to cover the user's specific query fully. Here is the question: $query"
                }
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'] as String;
        return reply;
      } else {
        debugPrint("Gemini API error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Gemini API exception: $e");
      return null;
    }
  }

  Future<String?> _callServerlessApi(String query) async {
    try {
      String origin = "https://agarwalknowledgehub.vercel.app";
      if (kIsWeb) {
        try {
          final webOrigin = js.context['window']['location']['origin'] as String?;
          if (webOrigin != null && webOrigin.isNotEmpty) {
            origin = webOrigin;
          }
        } catch (_) {}
      }
      
      final response = await http.post(
        Uri.parse('$origin/api/doubt-ai'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] as String;
      } else {
        debugPrint("Serverless API error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Serverless API exception: $e");
      return null;
    }
  }

  String _cleanText(String text) {
    return text.replaceAll('**', '').replaceAll('`', '');
  }

  void _speakText(String text) {
    if (kIsWeb) {
      try {
        final cleanText = _cleanText(text).replaceAll("'", "\\'").replaceAll("\n", " ");
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

    // Call live API or fallback to simulated delay
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      String aiResponse = "";
      
      // 1. Try Custom User API key if configured locally
      if (_geminiApiKey.isNotEmpty) {
        final liveReply = await _callGeminiApi(text);
        if (liveReply != null && liveReply.trim().isNotEmpty) {
          aiResponse = liveReply.trim();
          setState(() {
            _messages.add(MessageBubble(text: aiResponse, isUser: false, time: DateTime.now()));
            _isTyping = false;
          });
          _scrollToBottom();
          return;
        }
      }
      
      // 2. Try Vercel Serverless Backend Proxy (which uses securely configured API Key)
      final serverlessReply = await _callServerlessApi(text);
      if (serverlessReply != null && serverlessReply.trim().isNotEmpty) {
        aiResponse = serverlessReply.trim();
        setState(() {
          _messages.add(MessageBubble(text: aiResponse, isUser: false, time: DateTime.now()));
          _isTyping = false;
        });
        _scrollToBottom();
        return;
      }

      // 3. Offline Database Fallback
      final query = text.toLowerCase();
      
      // Smart Language Request Detection
      final userWantsHindi = _selectedLanguage == 'Hindi' ||
                             query.contains("hindi me") || 
                             query.contains("hindi mein") || 
                             query.contains("in hindi") ||
                             query.contains("kya h") ||
                             query.contains("kya hai") ||
                             query.contains("btao") ||
                             query.contains("batao") ||
                             query.contains("samjhao") ||
                             query.contains("kise kehte") ||
                             query.contains("kya hota");
                             
      final userWantsEnglish = query.contains("in english") || 
                               query.contains("english me") || 
                               query.contains("english mein");
                               
      final isHindi = userWantsHindi && !userWantsEnglish;
      
      // 1. PRIMARY CONCEPT: Computer
      if (query.contains("computer") || query.contains("generation")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर क्या है? (What is a Computer?) 💻:\n\n"
              "कंप्यूटर एक इलेक्ट्रॉनिक मशीन है जो हमसे जानकारी (Input) लेती है, उस पर काम (Processing) करती है, उसे सुरक्षित रखती है (Storage), और हमें परिणाम (Output) दिखाती है।\n\n"
              "आसान परिभाषा:\n"
              "\"कंप्यूटर एक ऐसी बिजली से चलने वाली मशीन है जो इनपुट लेती है, उस पर काम करती है, और हमें परिणाम देती है।\"\n\n"
              "कंप्यूटर के काम करने का तरीका:\n"
              "इनपुट ➔ प्रोसेसिंग ➔ आउटपुट ➔ स्टोरेज\n"
              "• इनपुट (Input): कीबोर्ड या माउस का उपयोग करके जानकारी डालना।\n"
              "• प्रोसेसिंग (Processing): सीपीयू (कंप्यूटर का दिमाग) काम या गणना करता है।\n"
              "• आउटपुट (Output): परिणाम को मॉनिटर स्क्रीन पर देखना या स्पीकर से सुनना।\n"
              "• स्टोरेज (Storage): फाइलों को हार्ड डिस्क या पेन ड्राइव में भविष्य के लिए सहेजना।\n\n"
              "आसान उदाहरण:\n"
              "अगर आप कीबोर्ड से 20 + 30 टाइप करते हैं ➔ सीपीयू इसकी गणना करता है ➔ आपकी स्क्रीन पर 50 दिखाई देता है!\n\n"
              "कंप्यूटर की मुख्य विशेषताएं:\n"
              "1. तेजी (Speed): यह पलक झपकते ही बहुत बड़ी गणना कर लेता है।\n"
              "2. सटीकता (Accuracy): यह कभी कोई गलती नहीं करता (अगर आपने सही इनपुट दिया है)।\n"
              "3. याददाश्त (Storage): यह बहुत सारे फोटो, वीडियो और किताबें याद रख सकता है।\n"
              "4. बहुमुखी प्रतिभा (Versatility): यह पढ़ाई करने, गेम खेलने, गाने सुनने और चित्र बनाने जैसे कई काम एक साथ कर सकता है।";
        } else {
          aiResponse = "What is a Computer? 💻:\n\n"
              "A computer is an electronic machine that takes info (Input), does work on it (Processing), saves it (Storage), and shows you the result (Output).\n\n"
              "Simple Definition:\n"
              "\"A computer is an electronic machine that takes input, processes it, stores data, and gives output.\"\n\n"
              "Basic Working of a Computer:\n"
              "Input ➔ Processing ➔ Output ➔ Storage\n"
              "• Input: You enter numbers or letters using a Keyboard or Mouse.\n"
              "• Processing: The CPU (Brain of the computer) does the thinking/work.\n"
              "• Output: You see the result on the Monitor or hear it from Speakers.\n"
              "• Storage: Files are saved in HDD, SSD, or Pen Drives so you can open them later.\n\n"
              "Easy Example:\n"
              "If you type 20 + 30 on your keyboard ➔ The CPU calculates it ➔ 50 shows up on your monitor!\n\n"
              "Main Characteristics (Features):\n"
              "1. Speed: It works super fast without taking breaks.\n"
              "2. Accuracy: It never makes mistakes if your input is correct.\n"
              "3. Storage: It can remember lots of photos, videos, and books.\n"
              "4. Versatility: It can play games, play music, write letters, and help you study.";
        }
      }
      // 2. PRIMARY CONCEPT: Hardware
      else if (query.contains("hardware") || query.contains("ram") || query.contains("rom") || query.contains("cpu") || query.contains("processor") || query.contains("storage") || query.contains("motherboard")) {
        if (isHindi) {
          aiResponse = "कंप्यूटर हार्डवेयर क्या है? (What is Hardware?) 🔌:\n\n"
              "हार्डवेयर कंप्यूटर के वे हिस्से होते हैं जिन्हें आप छू सकते हैं और देख सकते हैं। इसे आप अपने शरीर के अंगों (जैसे हाथ, आंख, पैर) की तरह समझ सकते हैं।\n\n"
              "मुख्य हार्डवेयर के भाग:\n"
              "1. सीपीयू (CPU):\n"
              "   • यह कंप्यूटर का दिमाग है।\n"
              "   • यह सारे काम करता है और बाकी सभी हिस्सों को निर्देश देता है।\n"
              "2. रैम (RAM):\n"
              "   • यह अस्थायी (temporary) याददाश्त है।\n"
              "   • उदाहरण: जब आप गेम खेलते हैं, तो वह रैम पर चलता है। कंप्यूटर बंद होते ही रैम सब भूल जाता है।\n"
              "3. रॉम (ROM):\n"
              "   • यह स्थायी (permanent) याददाश्त है।\n"
              "   • इसमें कंप्यूटर को चालू करने के मुख्य नियम होते हैं।\n"
              "4. स्टोरेज (SSD / HDD):\n"
              "   • यह कंप्यूटर की अलमारी है जहाँ सारा डेटा सेव होता है।\n"
              "   • SSD बहुत तेज़ होती है जिससे कंप्यूटर तुरंत खुल जाता है। HDD पुरानी और थोड़ी धीमी होती है।\n\n"
              "आसान उदाहरण:\n"
              "जब आप कंप्यूटर पर पेंटिंग करते हैं:\n"
              "• जिस माउस से आप चित्र बनाते हैं, वह इनपुट हार्डवेयर है।\n"
              "• रैम (RAM) आपके चालू चित्र को संभालती है।\n"
              "• एसएसडी (SSD) आपके चित्र को हमेशा के लिए सेव करके रखती है।\n"
              "• मॉनिटर आपको चित्र दिखाता है।";
        } else {
          aiResponse = "What is Computer Hardware? 🔌:\n\n"
              "Hardware is the physical parts of a computer that you can touch and see. Think of it like your body parts (eyes, hands, brain).\n\n"
              "Main Hardware Parts:\n"
              "1. CPU (Central Processing Unit):\n"
              "   • It is the Brain of the Computer.\n"
              "   • It does all calculations and controls other parts.\n"
              "2. RAM (Random Access Memory):\n"
              "   • It is the temporary working memory.\n"
              "   • E.g., when you play a game, the game runs on RAM. When you turn off the computer, RAM forgets everything.\n"
              "3. ROM (Read Only Memory):\n"
              "   • It is the permanent startup memory.\n"
              "   • It has the main instructions to turn on the computer.\n"
              "4. Storage (HDD / SSD):\n"
              "   • It is the permanent storage closet.\n"
              "   • SSD is like a modern fast pen drive, while HDD is a spin disk. SSD starts up the computer in seconds!\n\n"
              "Easy Example:\n"
              "If you are drawing in MS Paint:\n"
              "• The Mouse you draw with is input hardware.\n"
              "• The RAM holds the active drawing.\n"
              "• The SSD saves your drawing forever when you click Save.\n"
              "• The Monitor shows you the colors.";
        }
      }
      // 3. PRIMARY CONCEPT: Software
      else if (query.contains("software") || query.contains("operating system") || query.contains("windows") || query.contains("linux") || query.contains("os")) {
        if (isHindi) {
          aiResponse = "सॉफ्टवेयर और ऑपरेटिंग सिस्टम (Software & OS Made Easy) 💿:\n\n"
              "कंप्यूटर सॉफ्टवेयर क्या है?:\n"
              "सॉफ्टवेयर निर्देशों का एक समूह होता है जो हार्डवेयर को बताता है कि क्या करना है। आप सॉफ्टवेयर को छू नहीं सकते। उदाहरण के लिए, हार्डवेयर एक मोबाइल फोन की तरह है और सॉफ्टवेयर उसके अंदर चलने वाले ऐप्स (जैसे WhatsApp, YouTube) की तरह हैं!\n\n"
              "सॉफ्टवेयर के प्रकार:\n"
              "1. सिस्टम सॉफ्टवेयर (ऑपरेटिंग सिस्टम - OS):\n"
              "   • यह कंप्यूटर का बॉस होता है। यह कंप्यूटर को चालू करने और चलाने में मदद करता है।\n"
              "   • उदाहरण: Windows (कंप्यूटर के लिए), Android (मोबाइल के लिए), macOS (एप्पल कंप्यूटर के लिए)।\n"
              "2. एप्लीकेशन सॉफ्टवेयर:\n"
              "   • किसी खास काम को करने के लिए बनाए गए ऐप्स।\n"
              "   • उदाहरण: MS Paint (चित्र बनाने के लिए), Google Chrome (इंटरनेट चलाने के लिए), MS Word (लिखने के लिए)।\n\n"
              "आसान उदाहरण:\n"
              "गाना सुनने की मशीन में:\n"
              "• स्पीकर हार्डवेयर है (आप इसे छू सकते हैं)।\n"
              "• म्यूजिक प्लेयर ऐप सॉफ्टवेयर है (यह स्पीकर को बताता है कि कौन सा गाना बजाना है)।";
        } else {
          aiResponse = "What is Computer Software? 💿:\n\n"
              "Software is a set of instructions that tells the hardware what to do. You cannot touch software. Think of hardware as a smartphone, and software as the apps (WhatsApp, YouTube) inside it!\n\n"
              "Types of Software:\n"
              "1. System Software (Operating System):\n"
              "   • It is the boss of the computer. It helps the computer turn on and run.\n"
              "   • Examples: Windows (on PCs), Android (on phones), macOS (on Apple computers).\n"
              "2. Application Software:\n"
              "   • Programs made for specific tasks.\n"
              "   • Examples: MS Paint (for drawing), Google Chrome (for internet), MS Word (for writing).\n\n"
              "Easy Example:\n"
              "Imagine a music player:\n"
              "• The Speaker is hardware (you can touch it).\n"
              "• The Song Player App (like Spotify) is software (tells the speaker what sound to play).";
        }
      }
      // 4. PRIMARY CONCEPT: Excel (Only matches formula if it contains excel/vlookup/spreadsheet)
      else if (query.contains("vlookup") || query.contains("xlookup") || query.contains("pivot") || (query.contains("excel") && query.contains("formula")) || query.contains("spreadsheet")) {
        if (isHindi) {
          aiResponse = "एक्सेल और स्प्रेडशीट फ़ॉर्मूला (Excel Formulas Made Easy) 📊:\n\n"
              "1️⃣ मूल फ़ॉर्मूले:\n"
              "   - SUM (जोड़): =SUM(A1:A5) - खाने A1 से A5 तक के सभी नंबरों को जोड़ता है।\n"
              "   - AVERAGE (औसत): =AVERAGE(B1:B5) - औसत निकालता है।\n"
              "   - IF (हाँ या ना): =IF(C2>=33, \"Pass\", \"Fail\") - अगर नंबर 33 से ज़्यादा हैं तो Pass लिखेगा, नहीं तो Fail लिखेगा।\n\n"
              "2️⃣ VLOOKUP (वी-लुकअप - ढूंढने का साधन):\n"
              "   - आसान शब्दों में: यह टेलीफोन डायरेक्टरी में नाम ढूंढकर उसके सामने नंबर देखने जैसा है।\n"
              "   - फ़ॉर्मूला: =VLOOKUP(क्या ढूंढना है, कहाँ ढूंढना है, कॉलम नंबर, FALSE)\n"
              "   - आसान उदाहरण: =VLOOKUP(5, A1:B10, 2, FALSE) - यह रोल नंबर 5 को ढूंढेगा और उसके सामने वाले दूसरे कॉलम से उसका नाम बता देगा।\n\n"
              "3️⃣ XLOOKUP (नया और सबसे आसान):\n"
              "   - फ़ॉर्मूला: =XLOOKUP(क्या ढूंढना है, ढूंढने वाला कॉलम, परिणाम वाला कॉलम)\n"
              "   - आसान उदाहरण: =XLOOKUP(5, A1:A10, B1:B10) - कॉलम A में 5 ढूंढकर कॉलम B से उसका नाम सीधे बता देगा।";
        } else {
          aiResponse = "Microsoft Excel Formulas Made Super Easy 📊:\n\n"
              "1️⃣ Basic Calculations:\n"
              "   - SUM: =SUM(A1:A5) - Adds all numbers from cell A1 to A5.\n"
              "   - IF Logic: =IF(C2>=33, \"Pass\", \"Fail\") - Checks if score is 33 or more, showing Pass, else Fail.\n\n"
              "2️⃣ VLOOKUP (Vertical Search tool):\n"
              "   - Simple Explanation: It searches down a list for a name, then looks to the right to find their phone number.\n"
              "   - Formula: =VLOOKUP(search_value, table_range, column_number, FALSE)\n"
              "   - Easy Example: =VLOOKUP(5, A1:B10, 2, FALSE)\n"
              "     (Finds Roll Number 5 in column A, then gives the student Name from the 2nd column B).\n\n"
              "3️⃣ XLOOKUP (Modern Search):\n"
              "   - Formula: =XLOOKUP(search_value, search_column, return_column)\n"
              "   - Easy Example: =XLOOKUP(5, A1:A10, B1:B10)\n"
              "     (Searches for 5 in column A and directly fetches the name from column B. No column numbers needed!)";
        }
      }
      // 5. PRIMARY CONCEPT: Word
      else if (query.contains("mail merge") || query.contains("macro") || query.contains("word") || query.contains("typing") || query.contains("document") || query.contains("format")) {
        if (isHindi) {
          aiResponse = "एमएस वर्ड और शॉर्टकट टूल्स (MS Word Made Easy) 📄:\n\n"
              "1️⃣ मेल मर्ज (Mail Merge - एक साथ कई पत्र बनाना):\n"
              "   - आसान शब्दों में: यदि आपको 50 दोस्तों को जन्मदिन का कार्ड भेजना है, तो सबके नाम अलग-अलग टाइप करने के बजाय मेल मर्ज का उपयोग करें। यह एक्सेल की लिस्ट से नाम लेकर एक क्लिक में 50 अलग-अलग पत्र तैयार कर देता है।\n"
              "   - करने के तरीके:\n"
              "     1. Mailings टैब पर जाएं ➔ Start Mail Merge ➔ Letters चुनें।\n"
              "     2. Select Recipients पर क्लिक करें ➔ दोस्तों के नाम वाली एक्सेल फ़ाइल चुनें।\n"
              "     3. पत्र में नाम की जगह पर Insert Merge Field क्लिक करें।\n"
              "     4. Finish & Merge पर क्लिक करें।\n\n"
              "2️⃣ मैक्रोज़ (Macros - काम रिकॉर्डर):\n"
              "   - आसान शब्दों में: यह कंप्यूटर में काम रिकॉर्ड करने वाले टेप रिकॉर्डर जैसा है। जब कोई काम (जैसे बार-बार कोई बड़ा पता लिखना) रोज़ करना पड़े, तो मैक्रो रिकॉर्ड करके एक शॉर्टकट की (जैसे Alt + W) बना लें। दबाते ही पूरा काम 1 सेकंड में हो जाएगा।";
        } else {
          aiResponse = "Microsoft Word Made Simple & Easy 📄:\n\n"
              "1️⃣ Mail Merge (Creating Multiple Letters Instantly):\n"
              "   - Simple Explanation: If you want to invite 50 friends to a party, you don't need to write 50 letters manually. Mail Merge takes a names list from Excel and automatically prints 50 customized letters with a single click!\n"
              "   - Steps:\n"
              "     1. Go to Mailings tab ➔ Click Start Mail Merge ➔ Choose Letters.\n"
              "     2. Click Select Recipients ➔ Choose your Excel names sheet.\n"
              "     3. Place your cursor and click Insert Merge Field to place the Name.\n"
              "     4. Click Finish & Merge ➔ All letters are ready!\n\n"
              "2️⃣ Macros (Action Recorder):\n"
              "   - Simple Explanation: A Macro is like a video recorder for your typing. If you type your school address 10 times a day, you can record a Macro once, bind it to a key (like Alt + A), and press it to paste the address instantly.";
        }
      }
      // 6. PRIMARY CONCEPT: PowerPoint
      else if (query.contains("slide master") || query.contains("transition") || query.contains("animation") || query.contains("powerpoint") || query.contains("slide") || query.contains("presentation")) {
        if (isHindi) {
          aiResponse = "एमएस पावरपॉइंट प्रेजेंटेशन (PowerPoint Made Easy) 📉:\n\n"
              "1️⃣ स्लाइड मास्टर (Slide Master - मुख्य डिज़ाइन पेज):\n"
              "   - आसान शब्दों में: यदि आपके पास 50 slides हैं और आप चाहते हैं कि हर slide के कोने में school का logo दिखाई दे, तो 50 बार logo लगाने के बजाय slide master में लगाएं। यह अपने आप सब पर लग जाएगा।\n"
              "   - करने के तरीके:\n"
              "     1. View टैब पर जाएं ➔ Slide Master पर क्लिक करें।\n"
              "     2. सबसे ऊपर वाली पहली slide को चुनें और वहाँ logo लगाएं।\n"
              "     3. Close Master View पर क्लिक करें। सभी slides का डिज़ाइन एक साथ बदल जाएगा!\n\n"
              "2️⃣ मॉर्फ ट्रांजिशन (Morph):\n"
              "   - यह एक जादुई एनीमेशन है जो आकृतियों (shapes) को स्लाइड 1 से स्लाइड 2 पर जाते समय तैरते हुए सुचारू रूप से बड़ा या छोटा कर देता है।";
        } else {
          aiResponse = "Microsoft PowerPoint Made Simple & Easy 📉:\n\n"
              "1️⃣ Slide Master (Universal Design Template):\n"
              "   - Simple Explanation: If you have 50 slides and want the school logo to appear at the top corner of every single slide, you don't need to insert it 50 times. You just place it on the 'Slide Master' once, and it automatically updates all slides!\n"
              "   - Steps:\n"
              "     1. Go to View tab ➔ Click Slide Master.\n"
              "     2. Edit the very first slide template at the top (insert logo or set text font).\n"
              "     3. Click Close Master View. Your slides are updated!\n\n"
              "2️⃣ Morph Transition:\n"
              "   - A smooth motion animation. Copy a circle shape from Slide 1 to Slide 2, move it to a new corner, make it larger, and select 'Morph' transition. The circle will smoothly glide and grow on the screen!";
        }
      }
      // 7. PRIMARY CONCEPT: Database
      else if (query.contains("database") || query.contains("sql") || query.contains("dbms") || query.contains("nosql")) {
        if (isHindi) {
          aiResponse = "डेटाबेस और SQL (Databases Made Easy) 🗄️:\n\n"
              "डेटाबेस क्या है?:\n"
              "डेटाबेस कंप्यूटर की एक digital तिजोरी या अलमारी है जहाँ सारी जानकारी (data) टेबल के रूप में सजाकर रखी जाती है। जैसे स्कूल का हाजिरी रजिस्टर जिसमें हर छात्र की हाजिरी दर्ज होती है।\n\n"
              "SQL (एस-क्यू-एल) - आसान भाषा में:\n"
              "SQL डेटाबेस से बात करने की भाषा है। यह ऐसा है जैसे आप डेटाबेस से कहें: \"छात्रों की लिस्ट में से केवल उन बच्चों के नाम दिखाओ जो कक्षा 5 में पढ़ते हैं।\"\n\n"
              "आसान SQL क्वेरी का उदाहरण:\n"
              "यदि आप उन छात्रों के नाम देखना चाहते हैं जिनके 90 से अधिक नंबर आए हैं:\n"
              "```sql\n"
              "SELECT name, marks \n"
              "FROM students \n"
              "WHERE marks > 90;\n"
              "```\n"
              "• SELECT name, marks: नाम और नंबर दिखाओ.\n"
              "• FROM students: स्टूडेंट्स नाम के रजिस्टर से.\n"
              "• WHERE marks > 90: केवल उनके जिनके नंबर 90 से ज़्यादा हैं.";
        } else {
          aiResponse = "Databases and SQL Made Super Easy 🗄️:\n\n"
              "What is a Database?:\n"
              "A database is a digital cupboard where information is stored neatly in tables. E.g., a school register that records student marks.\n\n"
              "SQL (Structured Query Language):\n"
              "SQL is the simple language we use to search and edit databases. It is like telling the database: 'Show me the names of kids who scored 90 marks.'\n\n"
              "Basic SQL Example:\n"
              "```sql\n"
              "SELECT name, marks \n"
              "FROM students \n"
              "WHERE marks > 90;\n"
              "```\n"
              "• SELECT name, marks: Shows student name and score.\n"
              "• FROM students: Looks in the 'students' table.\n"
              "• WHERE marks > 90: Only shows kids with scores higher than 90.";
        }
      }
      // 8. PRIMARY CONCEPT: Coding
      else if (query.contains("coding") || query.contains("programming") || query.contains("python") || query.contains("java") || query.contains("c++") || query.contains("javascript") || query.contains("compiler") || query.contains("loop") || query.contains("algorithm")) {
        if (isHindi) {
          aiResponse = "कोडिंग और प्रोग्रामिंग (Coding Made Easy) 💻:\n\n"
              "कोडिंग क्या है?:\n"
              "कोडिंग कंप्यूटर को निर्देश देने का तरीका है। चूंकि कंप्यूटर हमारी तरह हिंदी या अंग्रेजी नहीं समझता, इसलिए हम कोडिंग भाषा (जैसे Python, Java) में लिखते हैं। यह केक बनाने की विधि (recipe) लिखने जैसा है!\n\n"
              "लूप (Loop) क्या है?:\n"
              "लूप का उपयोग किसी काम को बार-बार दोहराने के लिए किया जाता है। उदाहरण के लिए, यदि टीचर कहें: \"बोर्ड पर 5 बार 'मैं पढ़ाई करूँगा' लिखो,\" तो आप 5 बार अलग-अलग कोड नहीं लिखेंगे। आप लूप का उपयोग करेंगे जो इसे अपने आप 5 बार दोहरा देगा!\n\n"
              "आसान पायथन (Python) कोड का उदाहरण:\n"
              "```python\n"
              "# 5 बार प्रिंट करने का कोड\n"
              "for i in range(1, 6):\n"
              "    print(\"मैं पढ़ाई करूँगा\")\n"
              "```\n"
              "यह स्क्रीन पर 5 बार लिख देगा:\n"
              "1. मैं पढ़ाई करूँगा\n"
              "2. मैं पढ़ाई करूँगा\n"
              "... (5 बार)\n\n"
              "मुख्य भाषाएँ:\n"
              "• Python: सबसे आसान भाषा है, जिसके साथ एआई (AI) बनाने में मदद मिलती है।\n"
              "• JavaScript: इससे वेबसाइटों के बटन और एनीमेशन काम करते हैं।";
        } else {
          aiResponse = "Computer Coding and Loops Made Easy 💻:\n\n"
              "What is Coding?:\n"
              "Coding is writing step-by-step instructions for a computer. Since computers don't speak English or Hindi, we use languages like Python or JavaScript to tell them what to do. It's like writing a food recipe!\n\n"
              "What is a Loop?:\n"
              "A loop is used to repeat a task. E.g., if a teacher says: 'Write your name 5 times on the board,' you write it once inside a Loop and tell it to repeat 5 times!\n\n"
              "Easy Python Example:\n"
              "```python\n"
              "# Repeats print action 5 times\n"
              "for i in range(1, 6):\n"
              "    print(\"I will study hard\")\n"
              "```\n"
              "This prints on screen:\n"
              "1. I will study hard\n"
              "2. I will study hard\n"
              "...up to 5 times!\n\n"
              "Core Languages:\n"
              "• Python: Simplest to learn, used for AI & robots.\n"
              "• JavaScript: Powers website buttons and games.";
        }
      }
      // 9. PRIMARY CONCEPT: Office
      else if (query.contains("office") || query.contains("ms office") || query.contains("computer science")) {
        if (isHindi) {
          aiResponse = "एमएस ऑफिस सुइट (MS Office Made Simple) 💻:\n\n"
              "एमएस ऑफिस कंप्यूटर पर ऑफिस और स्कूल के काम करने के लिए ऐप्स का एक समूह है:\n"
              "1️⃣ एमएस वर्ड (MS Word): पत्र, निबंध और होमवर्क प्रोजेक्ट टाइप करने के लिए। (जैसे: स्कूल प्रोजेक्ट लिखना)।\n"
              "2️⃣ एमएस एक्सेल (MS Excel): रोल नंबर, अंक और फीस की लिस्ट बनाने तथा गणितीय गणनाएं करने के लिए। (जैसे: रिपोर्ट कार्ड बनाना)।\n"
              "3️⃣ एमएस पावरपॉइंट (MS PowerPoint): स्क्रीन पर चित्र और एनीमेशन के साथ सुंदर प्रेजेंटेशन दिखाने के लिए। (जैसे: टीचर द्वारा पाठ समझाना)।\n"
              "4️⃣ एमएस आउटलुक (MS Outlook): ईमेल भेजने और मीटिंग शेड्यूल करने के लिए।\n\n"
              "💡 सलाह: आप किस प्रोग्राम के बारे में सीखना चाहते हैं? उसका नाम लिखें (जैसे: 'vlookup', 'mail merge', 'slide master')!";
        } else {
          aiResponse = "Microsoft Office Suite Made Simple 💻:\n\n"
              "MS Office is a collection of apps that help you do school and office work easily:\n"
              "1️⃣ MS Word: Used to type letters, stories, and homework essays. (E.g. writing a class report).\n"
              "2️⃣ MS Excel: Used to create tables, marksheets, lists, and calculate sums. (E.g. tracking student marks).\n"
              "3️⃣ MS PowerPoint: Used to design slide presentations with pictures and animations. (E.g. teachers explaining a science lesson).\n"
              "4️⃣ MS Outlook: Used to send emails and check calendars.\n\n"
              "💡 Tip: Enter a specific term (e.g. type 'vlookup', 'mail merge', or 'slide master') to get step-by-step guides!";
        }
      }
      // 10. SUBJECT: History Akbar/Mughals/Kings (Fixes Akbar question fallback issue)
      else if (query.contains("akbar") || query.contains("ashoka") || query.contains("birbal") || query.contains("king") || query.contains("emperor") || query.contains("mughal") || query.contains("akbar kon")) {
        if (isHindi) {
          aiResponse = "इतिहास गाइड: सम्राट अकबर और बीरबल (Emperor Akbar & Birbal) 👑:\n\n"
              "1️⃣ अकबर कौन था? (Who was Akbar?):\n"
              "   - अकबर भारत के एक महान मुगल सम्राट (Mughal Emperor) थे। उन्होंने बहुत कम उम्र में शासन संभाला था।\n"
              "   - वे सभी धर्मों का सम्मान करते थे और उन्होंने दीन-ए-इलाही नाम का एक नया विचार शुरू किया था।\n"
              "   - उन्होंने प्रसिद्ध स्मारक फतेहपुर सीकरी और आगरा का किला बनवाया था।\n\n"
              "2️⃣ अकबर और बीरबल की कहानियां:\n"
              "   - बीरबल अकबर के दरबार के सबसे बुद्धिमान सलाहकार और नौ रत्नों (Nine Jewels) में से एक थे।\n"
              "   - वे अपनी चतुराई और हास्य-व्यंग्य से अकबर की हर कठिन समस्या का तुरंत हल निकाल देते थे। जैसे खिचड़ी पकाना की कहानी से उन्होंने अकबर को अपनी गलती का एहसास कराया था।";
        } else {
          aiResponse = "History Guide: Emperor Akbar and Birbal 👑:\n\n"
              "1️⃣ Who was Akbar?:\n"
              "   - Akbar was one of the greatest Mughal Emperors of India. He ruled with wisdom and unified a large part of India.\n"
              "   - He was known for encouraging art, literature, and religious harmony.\n"
              "   - He had nine great wise people in his court called the Navaratnas (Nine Jewels).\n\n"
              "2️⃣ Who was Birbal?:\n"
              "   - Birbal was Akbar's closest advisor and one of the Nine Jewels. He was famous for his quick wit, clever answers, and moral stories.";
        }
      }
      // 11. SUBJECT: Space / Solar System / Planets
      else if (query.contains("solar system") || query.contains("planet") || query.contains("sun") || query.contains("moon") || query.contains("star") || query.contains("space")) {
        if (isHindi) {
          aiResponse = "सौरमंडल और अंतरिक्ष (Solar System & Space) 🪐:\n\n"
              "1️⃣ सौरमंडल क्या है? (What is Solar System?):\n"
              "   - सूर्य (Sun) और उसके चारों ओर चक्कर लगाने वाले 8 ग्रहों (Planets) के परिवार को सौरमंडल कहते हैं।\n"
              "   - सूर्य इस परिवार का मुखिया है और यह बहुत गर्म गैस का एक तारा है।\n\n"
              "2️⃣ आठ ग्रह (8 Planets in order):\n"
              "   - बुध (Mercury) ➔ शुक्र (Venus) ➔ पृथ्वी (Earth - जहाँ हम रहते हैं) ➔ मंगल (Mars - लाल ग्रह) ➔ बृहस्पति (Jupiter - सबसे बड़ा ग्रह) ➔ शनि (Saturn - छल्ले वाला ग्रह) ➔ अरुण (Uranus) ➔ वरुण (Neptune)।\n\n"
              "3️⃣ चंद्रमा (Moon):\n"
              "   - चंद्रमा पृथ्वी का उपग्रह (satellite) है जो पृथ्वी के चक्कर लगाता है। यह खुद नहीं चमकता, बल्कि सूर्य की रोशनी से चमकता है।";
        } else {
          aiResponse = "Solar System and Space Guide 🪐:\n\n"
              "1️⃣ What is the Solar System?:\n"
              "   - The Solar System is the sun and all the objects that travel around it, including 8 planets and their moons.\n"
              "   - The Sun is a giant, hot star at the center.\n\n"
              "2️⃣ The 8 Planets (in order from the Sun):\n"
              "   1. Mercury (Closest) ➔ 2. Venus (Hottest) ➔ 3. Earth (Our home) ➔ 4. Mars (Red planet) ➔ 5. Jupiter (Largest) ➔ 6. Saturn (Has beautiful rings) ➔ 7. Uranus ➔ 8. Neptune (Coldest).\n\n"
              "3️⃣ The Moon:\n"
              "   - The Moon is Earth's natural satellite. It does not have its own light, it shines by reflecting sunlight.";
        }
      }
      // 12. SUBJECT: Rhyme
      else if (query.contains("twinkle") || query.contains("rhyme") || query.contains("johny") || query.contains("humpty")) {
        if (isHindi) {
          aiResponse = "बच्चों के लिए प्रसिद्ध बाल कविताएं (Nursery Rhymes) 🎵:\n\n"
              "1️⃣ ट्विंकल ट्विंकल लिटिल स्टार (Twinkle Twinkle):\n"
              "   'ट्विंकल ट्विंकल लिटिल स्टार, हाउ आई वंडर व्हाट यू आर!\n"
              "   अप अबव द वर्ल्ड सो हाई, लाइक ए डायमंड इन द स्काई।'\n\n"
              "2️⃣ जॉनी जॉनी यस पापा (Johny Johny):\n"
              "   'जॉनी जॉनी, यस पापा? ईटिंग शुगर, नो पापा!\n"
              "   टेलिंग लाइज़, नो पापा! OPEN YOUR MOUTH, हा हा हा!'\n\n"
              "💡 आसान स्पष्टीकरण: ये कविताएँ छोटे बच्चों को अक्षरों की आवाज, मज़ा और याद रखने की कला सिखाती हैं। इन्हें संगीत के साथ सुनने के लिए होम स्क्रीन पर 'Play Study' सेक्शन देखें!";
        } else {
          aiResponse = "Here are classic Nursery Rhymes for early learning 🎵:\n\n"
              "1️⃣ Twinkle Twinkle Little Star:\n"
              "   'Twinkle, twinkle, little star, How I wonder what you are!\n"
              "   Up above the world so high, Like a diamond in the sky.'\n\n"
              "2️⃣ Johny Johny Yes Papa:\n"
              "   'Johny, Johny, Yes, Papa? Eating sugar, No, Papa?\n"
              "   Telling lies, No, Papa? Open your mouth, Ha! Ha! Ha!'\n\n"
              "💡 Simple Explanation: Nursery rhymes help children learn word sounds, rhythm, and new words in a fun way. Tap the 'Play Study' tab on your Home screen to play them with voice synthesis!";
        }
      } 
      // 13. SUBJECT: Counting
      else if (query.contains("counting") || query.contains("number") || query.contains("counting number")) {
        if (isHindi) {
          aiResponse = "आइए संख्या गिनती (Counting Numbers) को आसान शब्दों में समझें 🔟:\n\n"
              "1️⃣ संख्या 1: 🌟 (एक तारा) - जैसे 'एक सूरज'\n"
              "2️⃣ संख्या 2: 🌟🌟 (दो तारे) - 1 और 1 मिलकर 2 बनते हैं।\n"
              "3️⃣ संख्या 3: 🌟🌟🌟 (तीन तारे) - 2 और 1 मिलकर 3 बनते हैं।\n"
              "4️⃣ संख्या 4: 🌟🌟🌟🌟 (चार तारे) - 3 और 1 मिलकर 4 बनते हैं।\n"
              "5️⃣ संख्या 5: 🌟🌟🌟🌟🌟 (पाँच तारे) - 4 और 1 मिलकर 5 बनते हैं।\n\n"
              "💡 आसान उदाहरण:\n"
              "यदि आपके पास 3 सेब हैं और अंजली मैम आपको 2 सेब और देती हैं, तो कुल 3 + 2 = 5 सेब हो जाएंगे! इसे गिनने के लिए आप 'Play Study' स्क्रीन पर रंगीन सितारों को दबा सकते हैं।";
        } else {
          aiResponse = "Let's learn numerical counting in a simple way 🔟:\n\n"
              "1️⃣ Number 1 (One): 🌟 (One star) - e.g., 'One bright sun.'\n"
              "2️⃣ Number 2 (Two): 🌟🌟 (Two stars) - Formed by adding 1 + 1 = 2.\n"
              "3️⃣ Number 3 (Three): 🌟🌟🌟 (Three stars) - Formed by adding 2 + 1 = 3.\n"
              "4️⃣ Number 4 (Four): 🌟🌟🌟🌟 (Four stars) - Formed by adding 3 + 1 = 4.\n"
              "5️⃣ Number 5 (Five): 🌟🌟🌟🌟🌟 (Five stars) - Formed by adding 4 + 1 = 5.\n\n"
              "💡 Practical Example:\n"
              "If you have 3 apples, and your teacher gives you 2 more, you count them: 4, 5. Total = 3 + 2 = 5 apples!\n"
              "Go to the 'Play Study' tab on the dashboard to click and count animated stars!";
        }
      } 
      // 14. SUBJECT: Alphabets (English)
      else if (query.contains("alphabet") || query.contains("abcd")) {
        if (isHindi) {
          aiResponse = "आइए अंग्रेजी वर्णमाला (English Alphabets) को आसान शब्दों में सीखें 🔠:\n\n"
              "🍎 A for Apple: सेब एक मीठा फल है जिसे खाने से हम स्वस्थ रहते हैं।\n"
              "⚽ B for Ball: गेंद एक गोल खिलौना है जिससे बच्चे खेलते हैं।\n"
              "🐱 C for Cat: बिल्ली एक छोटा पालतू जानवर है जो म्याऊँ-म्याऊँ करता है।\n"
              "🐶 D for Dog: कुत्ता एक वफादार जानवर है जो घर की रखवाली करता है।\n\n"
              "💡 आसान नियम: अंग्रेजी में 26 अक्षर होते हैं। इनमें 5 स्वर (Vowels: A, E, I, O, U) और 21 व्यंजन (Consonants) होते हैं। जब भी कोई शब्द स्वर (vowel) से शुरू होता है तो हम उसके आगे 'an' लगाते हैं (जैसे: an apple)।\n"
              "आप 'Play Study' में जाकर A से Z तक के कार्ड चित्रों के साथ देख सकते हैं!";
        } else {
          aiResponse = "Let's learn the English Alphabet with simple words 🔠:\n\n"
              "🍎 A for Apple: A sweet fruit. (e.g. 'I eat an Apple.')\n"
              "⚽ B for Ball: A round toy we play with. (e.g. 'Kick the Ball.')\n"
              "🐱 C for Cat: A small pet animal that meows. (e.g. 'The Cat is sleeping.')\n"
              "🐶 D for Dog: A loyal pet that barks. (e.g. 'My Dog is friendly.')\n\n"
              "💡 Easy Rule: There are 26 letters in the alphabet. 5 are Vowels (A, E, I, O, U) and 21 are Consonants. We write 'an' before words starting with vowel sounds (like: an apple) and 'a' before consonant sounds (like: a ball).\n"
              "Open the 'Play Study' page on the dashboard to swipe through A to Z cards!";
        }
      } 
      // 15. SUBJECT: Varnmala (Hindi Swar/Vyanjan)
      else if (query.contains("swar") || query.contains("vyanjan") || query.contains("varnmala")) {
        if (isHindi) {
          aiResponse = "आइए हिंदी वर्णमाला (Varnmala) को बहुत आसान तरीके से समझें ✍️:\n\n"
              "1️⃣ स्वर (Vowels): ये बिना किसी मदद के बोले जाने वाले अक्षर हैं (कुल 11):\n"
              "   - अ (अनार 🍒) -> अनार लाल दानों वाला फल है।\n"
              "   - आ (आम 🥭) -> आम फलों का राजा है।\n"
              "   - इ (इमली 🫒) -> इमली खट्टी होती है।\n\n"
              "2️⃣ व्यंजन (Consonants): इन्हें बोलने के लिए स्वरों की मदद चाहिए होती है (कुल 33):\n"
              "   - क (कबूतर 🕊️) -> कबूतर आसमान में उड़ता है।\n"
              "   - ख (खरगोश 🐇) -> खरगोश बहुत तेज़ी से दौड़ता है।\n"
              "   - ग (गमला 🪴) -> गमले में सुंदर पौधे हैं।\n\n"
              "💡 आसान बात: हिंदी भाषा को शुद्ध बोलने और लिखने के लिए स्वर और व्यंजनों को सीखना सबसे पहला कदम है। 'Play Study' में जाकर वर्णमाला के चित्र देखें!";
        } else {
          aiResponse = "Let's understand the Hindi Varnmala (Alphabet) in simple terms ✍️:\n\n"
              "1️⃣ Swar (Vowels): Sounds that can be spoken on their own (11 Swar):\n"
              "   - अ (Anar 🍒) -> Pomegranate.\n"
              "   - आ (Aam 🥭) -> Mango.\n"
              "   - इ (Imli 🫒) -> Tamarind.\n\n"
              "2️⃣ Vyanjan (Consonants): Sounds that need vowel sounds to be spoken (33 Vyanjan):\n"
              "   - क (Kabootar 🕊️) -> Pigeon (pronounced by combining K + a).\n"
              "   - ख (Khargosh 🐇) -> Rabbit.\n"
              "   - ग (Gamla 🪴) -> Flowerpot.\n\n"
              "💡 Simple Rule: Every Hindi consonant has a hidden 'a' (अ) sound when we speak it. Open the 'Play Study' section on the Home screen to practice speaking them!";
        }
      }
      // 16. SUBJECT: Fraction
      else if (query.contains("fraction")) {
        if (isHindi) {
          aiResponse = "गणित शंका हल! भिन्न (Fraction) क्या है? 🔢:\n\n"
              "आसान परिभाषा:\n"
              "\"भिन्न किसी पूरी चीज़ के एक छोटे हिस्से को दिखाता है। इसे ऊपर की संख्या (अंश) और नीचे की संख्या (हर) के रूप में लिखते हैं।\"\n\n"
              "💡 आसान पिज्जा उदाहरण:\n"
              "मान लीजिए आपने एक गोल पिज्जा को 4 बराबर टुकड़ों में काटा।\n"
              "• यदि आपने 1 टुकड़ा खा लिया, तो आपने पिज्जा का 1/4 हिस्सा खाया।\n"
              "• बचे हुए 3 टुकड़े पिज्जा का 3/4 हिस्सा हैं।\n\n"
              "भिन्न को जोड़ना (समान हर):\n"
              "अगर नीचे की संख्या एक जैसी है, तो बस ऊपर की संख्या को सीधे जोड़ दें:\n"
              "• उदाहरण: 2/5 + 1/5 = (2 + 1)/5 = 3/5.";
        } else {
          aiResponse = "Mathematics Doubt Solved! What is a Fraction? 🔢:\n\n"
              "Simple Definition:\n"
              "\"A fraction represents a part of a whole thing. It is written as a top number (Numerator) and a bottom number (Denominator) divided by a line.\"\n\n"
              "💡 Easy Pizza Example:\n"
              "Imagine you cut a round pizza into 4 equal slices.\n"
              "• If you eat 1 slice, you ate 1/4 of the pizza.\n"
              "• The remaining 3 slices are 3/4 of the pizza.\n\n"
              "Adding Fractions (Same Denominator):\n"
              "If the bottom numbers are the same, just add the top numbers directly:\n"
              "• Example: 2/5 + 1/5 = (2 + 1)/5 = 3/5.";
        }
      }
      // 17. SUBJECT: Math (Priority higher now, catches algebraic queries like "a+b", "square", "formula" or "+" symbols)
      else if (query.contains("math") || query.contains("sum") || query.contains("add") || query.contains("multiply") || query.contains("divide") || query.contains("algebra") || query.contains("geometry") || query.contains("formula") || query.contains("square") || query.contains("equation") || query.contains("solve") || query.contains("+") || query.contains("-") || query.contains("*") || query.contains("/") || query.contains("a+b") || query.contains("a-b")) {
        if (isHindi) {
          aiResponse = "गणित गाइड (Mathematics Simple Guide) 📐:\n\n"
              "1️⃣ महत्वपूर्ण सूत्र (Math Algebraic Formulas):\n"
              "   - (a + b) का होल स्क्वायर = a^2 + b^2 + 2ab\n"
              "   - (a - b) का होल स्क्वायर = a^2 + b^2 - 2ab\n"
              "   - (a + b)(a - b) = a^2 - b^2\n"
              "   - आसान उदाहरण: यदि a = 3 और b = 2 है ➔ (3 + 2)^2 = 5^2 = 25। सूत्र से देखें: 3^2 + 2^2 + 2*3*2 = 9 + 4 + 12 = 25!\n\n"
              "2️⃣ अंकगणित (BODMAS नियम):\n"
              "   - गणित का सवाल हल करने का सही क्रम: पहले कोष्ठक (Bracket) हल करें ➔ फिर भाग करें ➔ फिर गुणा करें ➔ फिर जोड़ें ➔ अंत में घटाएं।\n"
              "   - आसान उदाहरण: 20 - 2 * 5 + 3 को हल करें:\n"
              "     1. पहले गुणा करें: 2 * 5 = 10\n"
              "     2. अब सवाल बचा: 20 - 10 + 3\n"
              "     3. अब जोड़ें और घटाएं: 10 + 3 = 13।\n\n"
              "3️⃣ ज्यामिति (आकृतियाँ):\n"
              "   - आयत (Rectangle) का क्षेत्रफल = लंबाई * चौड़ाई।\n"
              "   - आसान उदाहरण: यदि किसी कमरे की लंबाई 5 मीटर और चौड़ाई 4 मीटर है, तो उसका क्षेत्रफल 5 * 4 = 20 वर्ग मीटर होगा।\n\n"
              "4️⃣ बीजगणित (समीकरण):\n"
              "   - आसान उदाहरण: x + 5 = 12 में x का मान निकालें। x को अकेला छोड़ें, 5 को दाईं ओर भेजें (तो वह माइनस हो जाएगा): x = 12 - 5 ➔ x = 7।";
        } else {
          aiResponse = "Mathematics Simple Academic Guide 📐:\n\n"
              "1️⃣ Core Algebraic Formulas:\n"
              "   - (a + b)^2 = a^2 + b^2 + 2ab\n"
              "   - (a - b)^2 = a^2 + b^2 - 2ab\n"
              "   - (a + b)(a - b) = a^2 - b^2\n"
              "   - Easy Example: If a = 3 and b = 2 ➔ (3 + 2)^2 = 5^2 = 25. Using formula: 3^2 + 2^2 + 2*3*2 = 9 + 4 + 12 = 25!\n\n"
              "2️⃣ BODMAS Rule (Order of Calculation):\n"
              "   - Solve in this order: Bracket ➔ Division ➔ Multiplication ➔ Addition ➔ Subtraction.\n"
              "   - Easy Example: Solve 20 - 2 * 5 + 3:\n"
              "     1. First perform multiplication: 2 * 5 = 10\n"
              "     2. The equation becomes: 20 - 10 + 3\n"
              "     3. Now add and subtract: 10 + 3 = 13.\n\n"
              "3️⃣ Geometry (Area Formulas):\n"
              "   - Rectangle Area = Length * Width.\n"
              "   - Easy Example: If a room is 5 meters long and 4 meters wide, the area is 5 * 4 = 20 square meters.\n\n"
              "4️⃣ Algebra (Solving for X):\n"
              "   - Easy Example: Find x in: x + 5 = 12. Move 5 to the right side (it changes to minus): x = 12 - 5 ➔ x = 7.";
        }
      }
      // 18. SUBJECT: Physics / Gravity
      else if (query.contains("physics") || query.contains("gravity") || query.contains("force") || query.contains("motion") || query.contains("light") || query.contains("electricity")) {
        if (isHindi) {
          aiResponse = "भौतिक विज्ञान गाइड (Physics Made Easy) ⚡:\n\n"
              "1️⃣ बल और गति (Force and Motion):\n"
              "   - बल (Force) का मतलब है किसी चीज़ को ढकेलना (push) या खींचना (pull)।\n"
              "   - सूत्र: F = m * a (बल = वजन * तेज़ी)।\n"
              "   - आसान उदाहरण: एक हल्की साइकिल को ढकेलना आसान है, लेकिन एक भारी कार को ढकेलने के लिए बहुत ज़्यादा बल की ज़रूरत होती है।\n\n"
              "2️⃣ गुरुत्वाकर्षण (Gravity):\n"
              "   - पृथ्वी का वह अदृश्य खिंचाव जो हर चीज़ को नीचे अपनी तरफ खींचता है।\n"
              "   - आसान उदाहरण: यदि आप अपने हाथ से एक पेंसिल छोड़ते हैं, तो वह हवा में ऊपर उड़ने के बजाय सीधे नीचे गिर जाती है क्योंकि गुरुत्वाकर्षण उसे खींच रहा है।\n\n"
              "3️⃣ प्रकाश का परावर्तन (Reflection of Light):\n"
              "   - जब रोशनी किसी आईने (mirror) से टकराकर वापस लौटती है, तो उसे परावर्तन कहते हैं। इसी वजह से हम आईने में अपना चेहरा देख पाते हैं।";
        } else {
          aiResponse = "Physics Concepts Made Super Easy ⚡:\n\n"
              "1️⃣ Force and Weight:\n"
              "   - A Force is simply a push or a pull on an object.\n"
              "   - Easy Example: Pushing a light plastic toy is very easy, but pushing a heavy wooden table requires a lot of force.\n\n"
              "2️⃣ Gravity (The Invisible Pull):\n"
              "   - Gravity is the Earth's invisible pull that pulls everything down to the ground.\n"
              "   - Easy Example: If you throw a ball high up in the air, it does not keep flying forever. It always falls back down to the grass because gravity pulls it.\n\n"
              "3️⃣ Light Reflection:\n"
              "   - When light bounces off a shiny surface like a mirror, it is called reflection. This is why you can see your face in the mirror!";
        }
      }
      // 19. SUBJECT: Chemistry
      else if (query.contains("chemistry") || query.contains("acid") || query.contains("base") || query.contains("element") || query.contains("atom") || query.contains("molecule")) {
        if (isHindi) {
          aiResponse = "रसायन विज्ञान (Chemistry Made Easy) 🧪:\n\n"
              "1️⃣ परमाणु और अणु (Atom & Molecule):\n"
              "   - परमाणु (Atom) दुनिया की सबसे छोटी चीज़ है जिससे सभी वस्तुएं बनी हैं (जैसे ईंटों से घर बनता है)।\n"
              "   - जब दो या दो से अधिक परमाणु आपस में मिलते हैं, तो उसे अणु (Molecule) कहते हैं।\n"
              "   - आसान उदाहरण: पानी का एक छोटा कण (अणु) हाइड्रोजन के दो और ऑक्सीजन के एक परमाणु से मिलकर बनता है (H2O)।\n\n"
              "2️⃣ अम्ल और क्षार (Acid & Base):\n"
              "   - अम्ल (Acid): खाने में खट्टा होता है। (जैसे नींबू का रस, इमली)।\n"
              "   - क्षार (Base): स्वाद में कड़वा और छूने में साबुन जैसा चिकना होता है। (जैसे कपड़े धोने का साबुन, बेकिंग सोडा)।\n"
              "   - उदासीन (Neutral): शुद्ध पानी न तो खट्टा होता है और न ही कड़वा।";
        } else {
          aiResponse = "Chemistry Concepts Made Super Easy 🧪:\n\n"
              "1️⃣ Atoms and Molecules (Building Blocks):\n"
              "   - An Atom is the tiniest building block of everything in the universe, just like bricks are building blocks for a wall.\n"
              "   - A Molecule is formed when two or more atoms join together.\n"
              "   - Easy Example: One drop of water is made of molecules, where each molecule has 2 Hydrogen atoms and 1 Oxygen atom joined together (H2O).\n\n"
              "2️⃣ Acids and Bases (Sour vs. Bitter):\n"
              "   - Acid: Things that taste sour. (Examples: Lemon juice, Vinegar).\n"
              "   - Base: Things that taste bitter and feel slippery like soap. (Examples: Baking soda, Bath soap).\n"
              "   - Neutral: Distilled water is neutral (neither sour nor bitter).";
        }
      }
      // 20. SUBJECT: Biology / Photosynthesis
      else if (query.contains("biology") || query.contains("cell") || query.contains("plant") || query.contains("photosynthesis") || query.contains("human body")) {
        if (isHindi) {
          aiResponse = "जीव विज्ञान गाइड (Biology Made Easy) 🧬:\n\n"
              "1️⃣ कोशिका (Cell):\n"
              "   - हमारा शरीर लाखों छोटी-छोटी जीवित इकाइयों से मिलकर बना है, जिन्हें कोशिका कहते हैं। जैसे एक मकान ईंटों को जोड़कर बनता है, वैसे ही हमारा शरीर कोशिकाओं से बना है।\n\n"
              "2️⃣ प्रकाश संश्लेषण (Photosynthesis):\n"
              "   - यह वह तरीका है जिससे पेड़-पौधे धूप का उपयोग करके अपना खाना खुद बनाते हैं। यह पौधों द्वारा दोपहर का भोजन पकाने जैसा है!\n"
              "   - आसान शब्दों में: कार्बन डाइऑक्साइड + पानी + धूप ➔ भोजन (ग्लूकोज) + ऑक्सीजन।\n"
              "   - पौधे हमारे लिए ऑक्सीजन छोड़ते हैं जिससे हम जीवित रहते हैं।\n\n"
              "3️⃣ मानव शरीर (हृदय):\n"
              "   - हमारा हृदय एक पंप की तरह है जो हमारे पूरे शरीर में खून और ऑक्सीजन पहुंचाने का काम करता है।";
        } else {
          aiResponse = "Biology Concepts Made Super Easy 🧬:\n\n"
              "1️⃣ The Cell (Building Block of Life):\n"
              "   - A cell is the smallest unit of life. Just like a house is made by putting bricks together, all plants, animals, and humans are made of millions of tiny cells.\n\n"
              "2️⃣ Photosynthesis (Plants Cooking Food):\n"
              "   - Photosynthesis is the way green plants cook their own food using sunlight. \n"
              "   - Simple Recipe: Carbon Dioxide + Water + Sunlight ➔ Food (sugar) + Oxygen.\n"
              "   - Plants release Oxygen into the air during this process, which we breathe to stay alive!\n\n"
              "3️⃣ The Heart (Pumping Machine):\n"
              "   - Your heart is like a strong pump that beats all day to send blood and oxygen to all parts of your body.";
        }
      }
      // 21. SUBJECT: Science general
      else if (query.contains("science")) {
        if (isHindi) {
          aiResponse = "विज्ञान क्या है? (What is Science?) 🔬:\n\n"
              "विज्ञान हमारे आस-पास की दुनिया को ध्यान से देखने और प्रयोगों (experiments) के माध्यम से समझने का आसान तरीका है। इसके तीन मुख्य भाग हैं:\n\n"
              "1️⃣ भौतिक विज्ञान (Physics): चीजें कैसे चलती हैं, रोशनी, गुरुत्वाकर्षण और बिजली का अध्ययन। (जैसे: गेंद ऊपर फेंकने पर नीचे क्यों आती है)।\n"
              "2️⃣ रसायन विज्ञान (Chemistry): चीजें किससे बनी हैं। (जैसे: पानी दो गैसों - हाइड्रोजन और ऑक्सीजन से मिलकर बनता है)।\n"
              "3️⃣ जीव विज्ञान (Biology): जीवित चीजों जैसे पौधों, जानवरों और हमारे शरीर का अध्ययन। (जैसे: पौधे धूप से अपना खाना कैसे बनाते हैं)।\n\n"
              "💡 आसान टिप: कोई भी टॉपिक जैसे 'gravity' या 'cell' टाइप करें और उसका आसान उत्तर पाएं!";
        } else {
          aiResponse = "What is Science? 🔬:\n\n"
              "Science is studying the world around us by observing things and doing experiments. It is divided into three main subjects:\n\n"
              "1️⃣ Physics: Studies how things move, light, gravity, and electricity. (E.g., why a ball falls down when thrown).\n"
              "2️⃣ Chemistry: Studies what things are made of. (E.g., how water is made of hydrogen and oxygen gases).\n"
              "3️⃣ Biology: Studies living things like plants, animals, and the human body. (E.g., how plants make food using sunlight).\n\n"
              "💡 Easy Tip: Type a topic like 'gravity' or 'cell' to get simple definitions and examples!";
        }
      }
      // 22. SUBJECT: Economics & Social Science
      else if (query.contains("economics") || query.contains("money") || query.contains("demand") || query.contains("supply") || query.contains("market") || query.contains("social science") || query.contains("political science") || query.contains("civics") || query.contains("constitution") || query.contains("government")) {
        if (isHindi) {
          aiResponse = "सामाजिक विज्ञान और नागरिक शास्त्र (Social & Political Science) 🏛️:\n\n"
              "1️⃣ भारत का संविधान (Constitution):\n"
              "   - यह हमारे देश को चलाने वाली नियमों की मुख्य पुस्तक है। इसे डॉ. भीमराव अंबेडकर जी के नेतृत्व में बनाया गया था।\n"
              "   - यह हमें मौलिक अधिकार (Fundamental Rights) जैसे पढ़ाई करने का अधिकार और आज़ादी से जीने का अधिकार देता है।\n\n"
              "2️⃣ लोकतंत्र (Democracy):\n"
              "   - लोकतंत्र का मतलब है जनता का शासन। इसमें लोग वोट (vote) डालकर अपनी पसंद के नेता (जैसे मुख्यमंत्री, प्रधानमंत्री) को चुनते हैं जो देश या राज्य चलाते हैं।\n\n"
              "3️⃣ मांग और आपूर्ति (Economics):\n"
              "   - जब किसी चीज़ की मांग बढ़ जाती है लेकिन स्टॉक कम होता है, तो उसकी कीमत बढ़ जाती है। जैसे गर्मी में अचानक ठंडी आइसक्रीम की कीमत बढ़ जाना।";
        } else {
          aiResponse = "Social and Political Science Made Super Easy 🏛️:\n\n"
              "1️⃣ What is the Constitution?:\n"
              "   - The Constitution is the supreme book of rules for running a country. India's constitution was guided by Dr. B. R. Ambedkar.\n"
              "   - It gives us Fundamental Rights, like the right to go to school and study (Right to Education).\n\n"
              "2️⃣ What is a Democracy?:\n"
              "   - Democracy means a government chosen by the people. Citizens vote to choose leaders (like Prime Ministers or Presidents) who make laws for the country.\n\n"
              "3️⃣ Economics (Demand & Supply):\n"
              "   - E.g. if 10 kids want to buy the last single cupcake in the store (high demand, low supply), the shopkeeper might raise its price!";
        }
      }
      // 23. SUBJECT: History general
      else if (query.contains("history") || query.contains("gandhi") || query.contains("independence") || query.contains("harappa") || query.contains("revolution")) {
        if (isHindi) {
          aiResponse = "इतिहास और स्वतंत्रता आंदोलन (History Made Easy) 📜:\n\n"
              "1️⃣ हड़प्पा सभ्यता (Indus Valley):\n"
              "   - यह हजारों साल पहले भारत में बसी एक बहुत पुरानी सभ्यता थी। यह लोग ईंटों के सुंदर पक्के घरों में रहते थे और इनके पास नालियों की बेहतरीन व्यवस्था थी।\n\n"
              "2️⃣ भारत की आज़ादी (1947):\n"
              "   - हमारा देश भारत पहले अंग्रेजों का गुलाम था। 15 अगस्त 1947 को भारत आज़ाद हुआ।\n"
              "   - महात्मा गांधी:\n"
              "     - इन्होंने बिना लड़ाई-झगड़े (अहिंसा) के सत्य की ताकत से अंग्रेज़ों को भारत छोड़ने पर मजबूर किया।\n"
              "     - इन्होंने असहयोग आंदोलन और नमक सत्याग्रह जैसे बड़े शांतिपूर्ण आंदोलनों का नेतृत्व किया।\n"
              "   - सुभाष चंद्र बोस: इन्होंने 'आजाद हिंद फौज' बनाई और प्रसिद्ध नारा दिया 'तुम मुझे खून दो, मैं तुम्हें आजादी दूंगा।';";
        } else {
          aiResponse = "History & Freedom Movements Made Simple 📜:\n\n"
              "1️⃣ Harappan Civilization:\n"
              "   - It was a very old city-based civilization that lived thousands of years ago near the Indus river. They built beautiful brick houses, straight roads, and clean drainage pipes.\n\n"
              "2️⃣ India's Independence (15th August 1947):\n"
              "   - India was ruled by the British for a long time. Many leaders fought together to make India free:\n"
              "     - Mahatma Gandhi: He used peace, truth, and non-violence to fight the British. He led the Salt March to protest unfair salt taxes.\n"
              "     - Subhash Chandra Bose: He created the Indian National Army (INA) and gave the famous slogan 'Give me blood, and I will give you freedom.'";
        }
      }
      // 24. SUBJECT: Geography
      else if (query.contains("geography") || query.contains("earth") || query.contains("map") || query.contains("continent") || query.contains("river") || query.contains("soil")) {
        if (isHindi) {
          aiResponse = "भूगोल क्या है? (Geography Made Easy) 🌍:\n\n"
              "1️⃣ पृथ्वी की तीन परतें (Layers of Earth):\n"
              "   - भूपर्पटी (Crust): पृथ्वी की सबसे ऊपरी परत जहाँ हम पैर रखते हैं और पेड़-पौधें उगते हैं।\n"
              "   - मेंटल (Mantle): बीच की परत जो पिघले हुए पत्थरों (लावा) से बनी है।\n"
              "   - क्रोड (Core): सबसे अंदरूनी हिस्सा जो बहुत गर्म है और लोहे से बना है।\n\n"
              "2️⃣ हवा की परतें (Atmosphere):\n"
              "   - क्षोभमंडल (Troposphere): सबसे निचली परत जहाँ बादल बनते हैं और बारिश होती है।\n"
              "   - समतापमंडल (Stratosphere): जहाँ हवाई जहाज़ उड़ते हैं। इसी में ओजोन परत होती है जो हमें सूरज की खतरनाक किरणों से बचाती है।\n\n"
              "3️⃣ जल चक्र (Water Cycle): धूप से नदी का पानी भाप बनकर उड़ता है ➔ ऊपर जाकर बादल बनता है ➔ फिर बारिश बनकर वापस नदी में आ जाता है।";
        } else {
          aiResponse = "Geography Concepts Made Super Easy 🌍:\n\n"
              "1️⃣ Layers of the Earth (Like a Boiled Egg):\n"
              "   - Crust: The outer hard shell where we build houses and grow trees.\n"
              "   - Mantle: The middle thick layer made of very hot, melted red rocks (magma).\n"
              "   - Core: The center of the Earth, which is extremely hot and made of solid iron.\n\n"
              "2️⃣ Atmosphere (Air Layers):\n"
              "   - Troposphere: The lowest air layer where clouds form, rain falls, and birds fly.\n"
              "   - Stratosphere: The higher layer where airplanes fly. It has the Ozone layer which acts like sunglasses for the Earth, blocking harmful rays.\n\n"
              "3️⃣ Water Cycle:\n"
              "   - Sun heats river water ➔ Water turns to vapor and goes up (Evaporation) ➔ Forms clouds (Condensation) ➔ Falls back as rain (Precipitation).";
        }
      }
      // 25. GRAMMAR: English & Basic Good English / Conversational Rules
      else if (query.contains("english") || query.contains("grammar") || query.contains("noun") || query.contains("verb") || query.contains("tense") || query.contains("speaking") || query.contains("good english") || query.contains("talk")) {
        if (isHindi) {
          aiResponse = "अंग्रेजी बोलना और व्याकरण (Good English Speaking & Grammar) 📝:\n\n"
              "1️⃣ बेसिक बातचीत के नियम (Daily Conversations):\n"
              "   - किसी से पहली बार मिलने पर: 'Hello, how are you?' (नमस्ते, आप कैसे हैं?)\n"
              "   - मदद के लिए पूछना: 'Could you please help me?' (क्या आप कृपया मेरी मदद करेंगे?)\n"
              "   - धन्यवाद देना: 'Thank you so much!' (आपका बहुत-बहुत धन्यवाद!)\n\n"
              "2️⃣ संज्ञा (Noun): किसी भी नाम वाले शब्द को संज्ञा कहते हैं (व्यक्ति, वस्तु, स्थान)।\n"
              "   - वाक्य: Aman is playing with a ball in Patna. (Aman, ball और Patna संज्ञा हैं)।\n\n"
              "3️⃣ क्रिया (Verb): काम दर्शाने वाले शब्द को क्रिया कहते हैं।\n"
              "   - वाक्य: Aman is running. (running क्रिया है)।\n\n"
              "4️⃣ काल (Tenses - समय):\n"
              "   - Present: I study. (मैं पढ़ता हूँ।)\n"
              "   - Past: I studied yesterday. (मैंने कल पढ़ाई की थी।)\n"
              "   - Future: I will study tomorrow. (मैं कल पढ़ाई करूँगा।)";
        } else {
          aiResponse = "English Grammar and Good Speaking Made Easy 📝:\n\n"
              "1️⃣ Polite Conversation Rules:\n"
              "   - Greeting: 'Hello! How are you today?'\n"
              "   - Requesting: 'Excuse me, could you help me please?'\n"
              "   - Expressing Gratitude: 'Thank you for your kind support.'\n\n"
              "2️⃣ Noun (Naming Words):\n"
              "   - A noun is the name of any person, place, or thing.\n"
              "   - Example: Aman is eating an apple in Patna. (Aman, apple, Patna are nouns).\n\n"
              "3️⃣ Verb (Doing Words):\n"
              "   - A verb shows an action.\n"
              "   - Example: The cat is jumping. (jumping is the verb).\n\n"
              "4️⃣ Tenses:\n"
              "   - Present: I play soccer.\n"
              "   - Past: I played soccer yesterday.\n"
              "   - Future: I will play soccer tomorrow.";
        }
      }
      // 26. GRAMMAR: Hindi (Specific grammar search, no general 'hindi' word collision)
      else if (query.contains("vyakaran") || query.contains("sangya") || query.contains("kriya") || query.contains("sarvnam") || query.contains("visheshan") || query.contains("hindi grammar") || query.contains("hindi vyakaran") || query == "hindi" || query.contains("hindi bhasha") || query.contains("hindi language")) {
        aiResponse = "हिंदी व्याकरण (Vyakaran Made Easy) ✍️:\n\n"
            "1️⃣ संज्ञा (Noun) - नाम वाले शब्द:\n"
            "   - किसी भी व्यक्ति, वस्तु, स्थान या भाव के नाम को संज्ञा कहते हैं।\n"
            "   - आसान उदाहरण: राम (व्यक्ति), पटना (स्थान), किताब (वस्तु), मिठास (भाव)।\n"
            "   - वाक्य: राम पटना में किताब पढ़ता है।\n\n"
            "2️⃣ क्रिया (Verb) - काम वाले शब्द:\n"
            "   - जिस शब्द से किसी काम के करने या होने का पता चले, उसे क्रिया कहते हैं।\n"
            "   - आसान उदाहरण: दौड़ना, रोना, पढ़ना, सोना।\n"
            "   - वाक्य: सीता गाना गा रही है।\n\n"
            "3️⃣ सर्वनाम (Pronoun) - संज्ञा की जगह आने वाले शब्द:\n"
            "   - जो शब्द संज्ञा (नाम) की जगह उपयोग किए जाते हैं ताकि नाम बार-बार न बोलना पड़े।\n"
            "   - उदाहरण: मैं, तुम, वह, हम। (जैसे: 'राम अच्छा लड़का है। वह रोज़ स्कूल जाता है।')";
      }
      // 27. GENERAL SCHOOL INFO: Admission/Register
      else if (query.contains("admission") || query.contains("join") || query.contains("fee") || query.contains("class") || query.contains("register")) {
        if (isHindi) {
          aiResponse = "स्वागत है! अग्रवाल नॉलेज हब (पटना शाखाओं) में प्रवेश खुले हैं। हम संकल्पनात्मक शिक्षा पर ध्यान केंद्रित करते हैं। पंजीकरण फॉर्म और मासिक शुल्क संबंधी प्रश्नों के लिए कार्यालय में डायरेक्टर अग्रवाल या सुश्री अंजलि वर्मा से संपर्क करें!";
        } else {
          aiResponse = "Welcome! Admissions are open at Agarwal Knowledge Hub (Patna branches) for Nursery to Class 7 and specialized Computer courses. We focus on conceptual learning and digital tools. For registration forms and monthly fee queries, please consult Director Agarwal or Ms. Anjali Verma at the admin cabin!";
        }
      }
      // 28. GENERAL SCHOOL INFO: Homework
      else if (query.contains("homework") || query.contains("assignment") || query.contains("due")) {
        if (isHindi) {
          aiResponse = "आप अपने पोर्टल में 'Homework' टैब के तहत सभी दिए गए होमवर्क शीट देख सकते हैं। आप पीडीएफ वर्कशीट डाउनलोड कर सकते हैं, उन्हें हल कर सकते हैं और सीधे 'Submit' स्क्रीन से स्नैपशॉट सबमिट कर सकते हैं। यदि आपके पास कोई विशिष्ट प्रश्न है, तो उसे यहाँ टाइप करें!";
        } else {
          aiResponse = "You can access all assigned homework sheets under the 'Homework' tab in your portal. You can download the PDF worksheets, solve them, and submit snapshots directly from the 'Submit' screen. If you have any specific query from a worksheet, type it here!";
        }
      }
      // 29. GENERAL CHAT: Hello/Hi
      else if (query.contains("hi") || query.contains("hello") || query.contains("hey") || query.contains("helo")) {
        if (isHindi) {
          aiResponse = "नमस्ते! मैं अग्रवाल नॉलेज हब में आपका एआई डाउट असिस्टेंट हूँ। मैं गणित, कंप्यूटर विज्ञान और सामान्य होमवर्क से जुड़े संदेहों को हल करने में आपकी मदद कर सकता हूँ। आज आप कौन सा विषय पढ़ रहे हैं?";
        } else {
          aiResponse = "Hello! I am your AI Doubt Assistant at Agarwal Knowledge Hub. I can help you solve doubts on Mathematics, Computer Science, and general classroom homework. What subject are you studying today?";
        }
      }
      // 30. GENERAL CHAT: Thank you
      else if (query.contains("thank") || query.contains("thanks")) {
        if (isHindi) {
          aiResponse = "आपका बहुत-बहुत स्वागत है! सीखना एक यात्रा है, और हमें आपकी सहायता करने में खुशी है। मुझे बताएं कि क्या आपके पास कोई अन्य प्रश्न हैं!";
        } else {
          aiResponse = "You're very welcome! Learning is a journey, and we are happy to support you. Let me know if you have any other questions!";
        }
      }
      // 31. FALLBACK (Default Answer)
      else {
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

  void _showSettingsDialog() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E2638) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.psychology, color: AppColors.secondaryOrange),
              const SizedBox(width: 10),
              const Text('Live AI Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your Google Gemini API Key to enable live ChatGPT-style answers for all subjects (Math, Science, Hindi, English, History, etc.):',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _apiKeyController,
                obscureText: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Gemini API Key',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  hintText: 'AIzaSy...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  if (kIsWeb) {
                    js.context.callMethod('open', ['https://aistudio.google.com/app/apikey']);
                  }
                },
                child: const Text(
                  '👉 Get a free Gemini API Key in 10 seconds (Click here)',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save Settings', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _saveApiKey(_apiKeyController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API Key saved successfully! Live AI Doubt Support is now active.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
        title: Row(
          children: [
            const Text('AI Doubt Support', style: TextStyle(fontWeight: FontWeight.bold)),
            if (_geminiApiKey.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 10),
                    SizedBox(width: 3),
                    Text('Live AI', style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ]
          ],
        ),
        actions: [
          // Live AI Configuration Settings button
          IconButton(
            icon: Icon(
              Icons.psychology_outlined,
              color: _geminiApiKey.isNotEmpty ? Colors.greenAccent : (isDark ? Colors.white70 : Colors.black87),
            ),
            tooltip: 'Configure Live AI Settings',
            onPressed: _showSettingsDialog,
          ),
          
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
                          color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
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
                            _cleanText(message.text),
                            style: TextStyle(
                              color: message.isUser
                                  ? Colors.white
                                  : (isDark ? Colors.white.withOpacity(0.9) : Colors.black87),
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
