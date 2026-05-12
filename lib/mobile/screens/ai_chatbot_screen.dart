import 'package:flutter/material.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/gemini_service.dart';
import 'package:hajj_companion/core/utils/app_localizations.dart';
import 'package:hajj_companion/core/providers/language_provider.dart';

class AIChatbotScreen extends StatefulWidget {
  final AppDatabase database;
  final int? conversationId;
  final bool isArabic;

  const AIChatbotScreen({
    super.key,
    required this.database,
    this.conversationId,
    this.isArabic = false,
  });

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  late GeminiService _geminiService;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showSampleQuestions = false;
  int? _currentConversationId;
  String _conversationTitle = 'AI Assistant';

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(widget.database, isArabic: widget.isArabic);
    _initializeConversation();
  }

  Future<void> _initializeConversation() async {
    if (widget.conversationId != null) {
      _currentConversationId = widget.conversationId;
      await _geminiService.loadChatFromDatabase(widget.conversationId!);
      final conv =
          await widget.database.getConversation(widget.conversationId!);
      if (conv != null && mounted) {
        setState(() {
          _conversationTitle = conv.title;
        });
      }
    } else {
      _currentConversationId = await _geminiService.createNewConversation(
        widget.isArabic ? 'محادثة جديدة' : 'New Chat',
      );
      setState(() {
        _showSampleQuestions = true;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _currentConversationId == null) return;

    setState(() {
      _isLoading = true;
      _showSampleQuestions = false;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      await _geminiService.sendMessage(text);
      setState(() => _isLoading = false);
      _scrollToBottom();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat(AppLocalizations? tr) {
    if (_currentConversationId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.deleteChat ?? 'Delete Chat'),
        content: Text(
          tr?.deleteConversationConfirm ??
              'Are you sure you want to delete this conversation? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await widget.database
                  .deleteConversation(_currentConversationId!);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              tr?.delete ?? 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;
    final isArabic = provider?.language == 'Arabic';

    if (_currentConversationId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_conversationTitle),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _clearChat(tr),
            tooltip: tr?.deleteChat ?? 'Delete chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info banner
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade50,
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr?.askMeAnything ??
                        'Ask me anything about Hajj and Umrah!',
                    style: TextStyle(
                        color: Colors.green.shade700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: widget.database
                  .watchMessagesForConversation(_currentConversationId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return _buildEmptyState(tr, isArabic);
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index], isArabic);
                  },
                );
              },
            ),
          ),

          // Sample questions
          if (_showSampleQuestions && !_isLoading)
            _buildSampleQuestions(tr, isArabic),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    tr?.thinking ?? 'Thinking...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

          // Input field
          _buildInputField(tr),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations? tr, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            tr?.startConversation ?? 'Start a conversation',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'اسألني عن الحج أو العمرة'
                : 'Ask me about Hajj or Umrah',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isArabic) {
    // Detect if message content is Arabic for RTL alignment
    final isContentArabic = _isArabicText(message.content);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: isContentArabic
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
              textAlign: isContentArabic ? TextAlign.right : TextAlign.left,
              textDirection: isContentArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if text contains Arabic characters
  bool _isArabicText(String text) {
    return text.runes.any((rune) => rune >= 0x0600 && rune <= 0x06FF);
  }

  Widget _buildSampleQuestions(AppLocalizations? tr, bool isArabic) {
    final questions = isArabic
        ? _geminiService.getSampleHajjQuestionsArabic()
        : _geminiService.getSampleHajjQuestions();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr?.sampleQuestionsLabel ?? 'Sample Questions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: questions
                .take(3)
                .map((q) => _buildSampleQuestionChip(q))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleQuestionChip(String question) {
    return InkWell(
      onTap: () => _sendMessage(question),
      child: Chip(
        label: Text(question, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget _buildInputField(AppLocalizations? tr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: tr?.askAboutHajjUmrah ?? 'Ask about Hajj or Umrah...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.green,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
