import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Service for interacting with Gemini AI for Hajj and Umrah guidance
class GeminiService {
  static const String _apiKey = 'AIzaSyAA6Fk28ENg6rUBdXUFh72b9XAA0HYR3Jc';

  late final GenerativeModel _model;
  ChatSession? _chatSession;
  final AppDatabase _database;
  final bool isArabic;
  int? _currentConversationId;

  /// System prompt restricts AI to Hajj/Umrah topics only,
  /// and instructs it to respond in the user's language.
  static const String _systemPrompt = '''
You are a knowledgeable Islamic scholar and guide specializing in Hajj and Umrah pilgrimages.
Your role is to provide accurate, helpful information ONLY about:
- Hajj rituals, rules, and procedures
- Umrah rituals, rules, and procedures
- Islamic practices related to pilgrimage
- Locations in Mecca and Medina (Kaaba, Masjid al-Haram, Masjid an-Nabawi, Mina, Arafat, Muzdalifah, etc.)
- Historical significance of holy sites
- Practical advice for pilgrims
- Duas and prayers related to Hajj/Umrah
- Ihram rules and requirements
- Tawaf, Sa'i, and other rituals

LANGUAGE INSTRUCTIONS (Very Important):
- Always detect the language the user is writing in.
- If the user writes in Arabic, respond ENTIRELY in Arabic.
- If the user writes in English, respond in English.
- Never mix languages in a single response.
- Match the user's language in every reply.

IMPORTANT RESTRICTIONS:
- If asked about topics unrelated to Hajj or Umrah, politely decline and remind the user you only assist with Hajj and Umrah questions
- Provide information based on authentic Islamic sources
- Be respectful and considerate of all Islamic schools of thought
- Keep responses clear, concise, and practical
- If you're unsure about something, acknowledge it

Response format:
- Use clear, simple language
- Break down complex rituals into steps
- Provide relevant context when needed
- Be encouraging and supportive
- Do NOT use markdown formatting (no ###, **, __, *, or other markdown symbols)
- Write responses in plain text format only
''';

  GeminiService(this._database, {this.isArabic = false}) {
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 4096,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  /// Start a new chat session
  void startNewChat() {
    _chatSession = _model.startChat(
      history: [
        Content.text(_systemPrompt),
        Content.model([
          TextPart(
            isArabic
                ? 'أفهم. سأجيب فقط على الأسئلة المتعلقة بالحج والعمرة. كيف يمكنني مساعدتك اليوم؟'
                : 'I understand. I will only answer questions about Hajj and Umrah pilgrimages. How can I help you today?',
          ),
        ]),
      ],
    );
  }

  /// Load chat session from database
  Future<void> loadChatFromDatabase(int conversationId) async {
    _currentConversationId = conversationId;
    final messages =
        await _database.getMessagesForConversation(conversationId);

    if (messages.isEmpty) {
      startNewChat();
      return;
    }

    final history = <Content>[
      Content.text(_systemPrompt),
      Content.model([
        TextPart(
          isArabic
              ? 'أفهم. سأجيب فقط على الأسئلة المتعلقة بالحج والعمرة. كيف يمكنني مساعدتك اليوم؟'
              : 'I understand. I will only answer questions about Hajj and Umrah pilgrimages. How can I help you today?',
        ),
      ]),
    ];

    for (final msg in messages) {
      if (msg.isUser) {
        history.add(Content.text(msg.content));
      } else {
        history.add(Content.model([TextPart(msg.content)]));
      }
    }

    _chatSession = _model.startChat(history: history);
  }

  /// Create a new conversation in database
  Future<int> createNewConversation(String title) async {
    final id = await _database.createConversation(title);
    _currentConversationId = id;
    startNewChat();

    // Save welcome message in the correct language
    await _database.insertMessage(
      ChatMessagesCompanion.insert(
        conversationId: id,
        content: isArabic
            ? 'السلام عليكم! أنا مساعدك الذكي للحج والعمرة. كيف يمكنني مساعدتك اليوم؟'
            : 'Assalamu Alaikum! I\'m your Hajj & Umrah AI assistant. How can I help you today?',
        isUser: false,
        timestamp: Value(DateTime.now()),
      ),
    );

    return id;
  }

  /// Send a message and get AI response
  Future<String> sendMessage(String message) async {
    try {
      if (_chatSession == null) {
        if (_currentConversationId == null) {
          await createNewConversation(
              isArabic ? 'محادثة جديدة' : 'New Chat');
        } else {
          await loadChatFromDatabase(_currentConversationId!);
        }
      }

      if (_currentConversationId != null) {
        await _database.insertMessage(
          ChatMessagesCompanion.insert(
            conversationId: _currentConversationId!,
            content: message,
            isUser: true,
            timestamp: Value(DateTime.now()),
          ),
        );
      }

      final response =
          await _chatSession!.sendMessage(Content.text(message));
      final responseText =
          response.text ?? (isArabic ? 'عذراً، لم أتمكن من توليد رد.' : 'Sorry, I could not generate a response.');

      if (_currentConversationId != null) {
        await _database.insertMessage(
          ChatMessagesCompanion.insert(
            conversationId: _currentConversationId!,
            content: responseText,
            isUser: false,
            timestamp: Value(DateTime.now()),
          ),
        );
      }

      return responseText;
    } catch (e) {
      if (e.toString().contains('SAFETY')) {
        return isArabic
            ? 'عذراً، لا يمكنني الرد على هذه الرسالة. يرجى طرح أسئلة تتعلق بالحج أو العمرة.'
            : 'I apologize, but I cannot respond to that message. Please ask questions related to Hajj or Umrah pilgrimages.';
      }
      return 'Error: ${e.toString()}';
    }
  }

  void clearHistory() {
    _chatSession = null;
    _currentConversationId = null;
  }

  Future<void> switchConversation(int conversationId) async {
    await loadChatFromDatabase(conversationId);
  }

  int? get currentConversationId => _currentConversationId;

  /// English sample questions
  List<String> getSampleHajjQuestions() {
    return [
      'What are the main steps of Hajj?',
      'When should I enter Ihram?',
      'What is the significance of Arafat?',
      'How many times should I perform Tawaf?',
      'What duas should I recite during Tawaf?',
      'What are the prohibited actions during Ihram?',
    ];
  }

  /// Arabic sample questions
  List<String> getSampleHajjQuestionsArabic() {
    return [
      'ما هي خطوات الحج الرئيسية؟',
      'متى يجب أن أدخل في الإحرام؟',
      'ما هي أهمية يوم عرفة؟',
      'كم مرة يجب أن أؤدي الطواف؟',
      'ما الأدعية التي يجب قراءتها أثناء الطواف؟',
      'ما هي المحظورات أثناء الإحرام؟',
    ];
  }

  List<String> getSampleUmrahQuestions() {
    return [
      'What are the steps of Umrah?',
      'How is Umrah different from Hajj?',
      'Can I perform Umrah anytime?',
      'What should I do after completing Sa\'i?',
      'How long does Umrah usually take?',
      'What are the Miqat boundaries?',
    ];
  }
}
