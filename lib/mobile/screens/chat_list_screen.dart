import 'package:flutter/material.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/gemini_service.dart';
import 'package:hajj_companion/core/utils/app_localizations.dart';
import 'package:hajj_companion/core/providers/language_provider.dart';
import 'ai_chatbot_screen.dart';

class ChatListScreen extends StatefulWidget {
  final AppDatabase database;
  final bool isArabic;

  const ChatListScreen({
    super.key,
    required this.database,
    this.isArabic = false,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;
    final isArabic = provider?.language == 'Arabic';

    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.aiChatHistory ?? 'AI Chat History'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showDeleteAllDialog(tr),
            tooltip: tr?.clearAllChats ?? 'Clear all chats',
          ),
        ],
      ),
      body: StreamBuilder<List<ChatConversation>>(
        stream: widget.database.watchAllConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final conversations = snapshot.data ?? [];

          if (conversations.isEmpty) {
            return _buildEmptyState(tr, isArabic);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _buildConversationCard(conversation, tr, isArabic);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewChat(tr, isArabic),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add_comment),
        label: Text(tr?.newChat ?? 'New Chat'),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations? tr, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            tr?.noConversationsYet ?? 'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'ابدأ محادثة جديدة للسؤال عن\nالحج والعمرة'
                : 'Start a new chat to ask about\nHajj and Umrah',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _createNewChat(tr, isArabic),
            icon: const Icon(Icons.add),
            label: Text(tr?.startFirstChat ?? 'Start First Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(
      ChatConversation conversation, AppLocalizations? tr, bool isArabic) {
    final formattedDate = _formatDate(conversation.updatedAt, tr, isArabic);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.chat, color: Colors.green.shade700),
        ),
        title: Text(
          conversation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          formattedDate,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'rename') {
              _showRenameDialog(conversation, tr);
            } else if (value == 'delete') {
              _showDeleteDialog(conversation, tr);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 20),
                  const SizedBox(width: 12),
                  Text(tr?.rename ?? 'Rename'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 20, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(
                    tr?.delete ?? 'Delete',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _openChat(conversation.id, isArabic),
      ),
    );
  }

  String _formatDate(
      DateTime date, AppLocalizations? tr, bool isArabic) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (difference.inDays == 0) {
      return '${tr?.todayAt ?? 'Today at'} $hour:$minute';
    } else if (difference.inDays == 1) {
      return tr?.yesterday ?? 'Yesterday';
    } else if (difference.inDays < 7) {
      return isArabic
          ? '${difference.inDays} ${tr?.daysAgoLabel ?? 'days ago'}'
          : '${difference.inDays} ${tr?.daysAgoLabel ?? 'days ago'}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _createNewChat(AppLocalizations? tr, bool isArabic) async {
    final controller =
        TextEditingController(text: tr?.newChat ?? 'New Chat');

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.newChat ?? 'New Chat'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: tr?.chatTitle ?? 'Chat Title',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(tr?.save ?? 'Create'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      final geminiService =
          GeminiService(widget.database, isArabic: isArabic);
      final conversationId =
          await geminiService.createNewConversation(result);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIChatbotScreen(
              database: widget.database,
              conversationId: conversationId,
              isArabic: isArabic,
            ),
          ),
        );
      }
    }
  }

  void _openChat(int conversationId, bool isArabic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIChatbotScreen(
          database: widget.database,
          conversationId: conversationId,
          isArabic: isArabic,
        ),
      ),
    );
  }

  void _showRenameDialog(ChatConversation conversation, AppLocalizations? tr) async {
    final controller = TextEditingController(text: conversation.title);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.renameChat ?? 'Rename Chat'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: tr?.chatTitle ?? 'Chat Title',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(tr?.rename ?? 'Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await widget.database.updateConversationTitle(conversation.id, result);
    }
  }

  void _showDeleteDialog(ChatConversation conversation, AppLocalizations? tr) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.deleteChat ?? 'Delete Chat'),
        content: Text(
          '"${conversation.title}"${tr?.deleteConversationConfirm != null ? '\n${tr!.deleteConversationConfirm}' : ' — Are you sure?'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await widget.database.deleteConversation(conversation.id);
    }
  }

  void _showDeleteAllDialog(AppLocalizations? tr) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.clearAllChats ?? 'Clear All Chats'),
        content: Text(
          tr?.clearAllConfirm ??
              'Are you sure you want to delete all conversations? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr?.clearAll ?? 'Clear All'),
          ),
        ],
      ),
    );

    if (result == true) {
      await widget.database.clearAllConversations();
    }
  }
}
