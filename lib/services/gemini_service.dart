import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Service for interacting with Gemini AI for Hajj and Umrah guidance
class GeminiService {
  static const String _apiKey = 'AIzaSyAA6Fk28ENg6rUBdXUFh72b9XAA0HYR3Jc';

  late final GenerativeModel _model;
  ChatSession? _chatSession;
  final AppDatabase _database;
  int? _currentConversationId;

  /// System prompt to restrict AI responses to Hajj and Umrah topics only
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

  GeminiService(this._database) {
    _initializeModel();
  }

  /// Initialize the Gemini model with safety settings
  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
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
            'I understand. I will only answer questions about Hajj and Umrah pilgrimages. How can I help you today?',
          ),
        ]),
      ],
    );
  }

  /// Load chat session from database
  Future<void> loadChatFromDatabase(int conversationId) async {
    _currentConversationId = conversationId;
    final messages = await _database.getMessagesForConversation(conversationId);

    if (messages.isEmpty) {
      startNewChat();
      return;
    }

    // Build chat history from saved messages
    final history = <Content>[
      Content.text(_systemPrompt),
      Content.model([
        TextPart(
          'I understand. I will only answer questions about Hajj and Umrah pilgrimages. How can I help you today?',
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

    // Save welcome message
    await _database.insertMessage(
      ChatMessagesCompanion.insert(
        conversationId: id,
        content:
            'Assalamu Alaikum! I\'m your Hajj & Umrah AI assistant. How can I help you today?',
        isUser: false,
        timestamp: Value(DateTime.now()),
      ),
    );

    return id;
  }

  /// Send a message and get AI response
  Future<String> sendMessage(String message) async {
    try {
      // Start a new chat if one doesn't exist
      if (_chatSession == null) {
        if (_currentConversationId == null) {
          await createNewConversation('New Chat');
        } else {
          await loadChatFromDatabase(_currentConversationId!);
        }
      }

      // Save user message
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

      final response = await _chatSession!.sendMessage(Content.text(message));
      final responseText =
          response.text ?? 'Sorry, I could not generate a response.';

      // Save AI response
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
        return 'I apologize, but I cannot respond to that message. Please ask questions related to Hajj or Umrah pilgrimages.';
      }
      return 'Error: ${e.toString()}';
    }
  }

  /// Get a one-time response without maintaining chat history
  Future<String> getOneTimeResponse(String prompt) async {
    try {
      final fullPrompt = '$_systemPrompt\n\nUser question: $prompt';
      final response = await _model.generateContent([Content.text(fullPrompt)]);

      return response.text ?? 'Sorry, I could not generate a response.';
    } catch (e) {
      if (e.toString().contains('SAFETY')) {
        return 'I apologize, but I cannot respond to that message. Please ask questions related to Hajj or Umrah pilgrimages.';
      }
      return 'Error: ${e.toString()}';
    }
  }

  /// Clear chat history and start fresh
  void clearHistory() {
    _chatSession = null;
    _currentConversationId = null;
  }

  /// Switch to a different conversation
  Future<void> switchConversation(int conversationId) async {
    await loadChatFromDatabase(conversationId);
  }

  /// Get current conversation ID
  int? get currentConversationId => _currentConversationId;

  /// Get sample questions for Hajj
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

  /// Get sample questions for Umrah
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
