import 'dart:async';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// CHAT MESSAGE DATA MODEL
// -----------------------------------------------------------------------------

class ChatMessage {
  final String id;
  final String author;
  final String text;
  final String time;
  final String? fileName;
  final bool isYou;

  ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.time,
    this.fileName,
    required this.isYou,
  });
}

// -----------------------------------------------------------------------------
// STANDALONE CHAT ROOM SCREEN
// -----------------------------------------------------------------------------

class ChatScreen extends StatefulWidget {
  final String groupName;
  final String groupSubject;
  final String groupId;
  final List<String> members;
  final String currentUser;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ChatScreen({
    super.key,
    required this.groupName,
    required this.groupSubject,
    required this.groupId,
    required this.members,
    required this.currentUser,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  String? _attachedFileName;

  // Typing Indicator State
  String? _typingUser;
  Timer? _typingTimer;
  Timer? _simulationTimer;

  // In-Memory Chat Messages History
  late List<ChatMessage> _messages;

  // Vibrant Unique Member Color Palettes
  static const List<Color> _userColorPaletteLight = [
    Color(0xFF2563EB), // Vibrant Blue
    Color(0xFF7C3AED), // Purple
    Color(0xFF059669), // Emerald Green
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Crimson
    Color(0xFF0891B2), // Teal
    Color(0xFF4F46E5), // Indigo
    Color(0xFFE11D48), // Rose
  ];

  static const List<Color> _userColorPaletteDark = [
    Color(0xFF60A5FA), // Light Blue
    Color(0xFFA78BFA), // Light Purple
    Color(0xFF34D399), // Emerald Green
    Color(0xFFFBBF24), // Amber
    Color(0xFFF87171), // Coral Red
    Color(0xFF22D3EE), // Cyan / Teal
    Color(0xFF818CF8), // Indigo
    Color(0xFFFB7185), // Pink
  ];

  // Common Emojis
  static const List<String> _emojis = [
    "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇",
    "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚",
    "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩",
    "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😣",
    "👍", "🙌", "👏", "🤝", "🔥", "✨", "💯", "📚", "💡", "📝",
    "💻", "🚀", "🎉", "❤️", "⭐", "🎯", "⚡", "☕", "🧠", "🎓",
  ];

  @override
  void initState() {
    super.initState();
    _initMockMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    _simulationTimer?.cancel();
    super.dispose();
  }

  /// Get distinct, deterministic color for a person in the group
  Color _getMemberColor(String name, bool isDark) {
    final palette = isDark ? _userColorPaletteDark : _userColorPaletteLight;
    final index = widget.members.indexOf(name);

    if (index != -1) {
      return palette[index % palette.length];
    }

    final hash = name.codeUnits.fold(0, (sum, char) => sum + char);
    return palette[hash % palette.length];
  }

  void _initMockMessages() {
    _messages = [
      ChatMessage(
        id: "m1",
        author: "Sara Khan",
        text: "Hey everyone! Welcome to the study group chat for ${widget.groupName}.",
        time: "10:15 AM",
        isYou: false,
      ),
      ChatMessage(
        id: "m2",
        author: "Bilal Ahmed",
        text: "Hi Sara! Has anyone started reviewing chapter 4 past paper questions?",
        time: "10:18 AM",
        isYou: false,
      ),
      ChatMessage(
        id: "m3",
        author: widget.currentUser,
        text: "Yes, I uploaded the summary notes for usability heuristics earlier.",
        time: "10:22 AM",
        fileName: "HCI_Usability_Heuristics_Summary.pdf",
        isYou: true,
      ),
      ChatMessage(
        id: "m4",
        author: "Sara Khan",
        text: "Awesome! Thanks for sharing. Let's discuss the heuristics assignment at 4 PM today.",
        time: "10:25 AM",
        isYou: false,
      ),
    ];
  }

  void _onTextChanged(String text) {
    if (text.trim().isNotEmpty && _typingUser == null) {
      // User typing
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _attachedFileName == null) return;

    final now = DateTime.now();
    final timeStr =
        "${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    setState(() {
      _messages.add(
        ChatMessage(
          id: "m_${DateTime.now().millisecondsSinceEpoch}",
          author: widget.currentUser,
          text: text,
          time: timeStr,
          fileName: _attachedFileName,
          isYou: true,
        ),
      );
      _messageController.clear();
      _attachedFileName = null;
      _showEmojiPicker = false;
    });

    _scrollToBottom();

    // Trigger simulated typing indicator from another group member after sending
    _simulatePeerTypingAndReply();
  }

  void _simulatePeerTypingAndReply() {
    _simulationTimer?.cancel();
    _typingTimer?.cancel();

    // Pick another member in the group
    final peerName = widget.members.firstWhere(
      (m) => m != widget.currentUser,
      orElse: () => "Sara Khan",
    );

    // Show typing indicator after 1.5s
    _simulationTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _typingUser = peerName;
      });

      _scrollToBottom();

      // Peer stops typing and posts a reply after 2.5s
      _typingTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;

        final now = DateTime.now();
        final timeStr =
            "${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

        setState(() {
          _typingUser = null;
          _messages.add(
            ChatMessage(
              id: "m_reply_${DateTime.now().millisecondsSinceEpoch}",
              author: peerName,
              text: "Got it! Thanks for the update 👍",
              time: timeStr,
              isYou: false,
            ),
          );
        });

        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _attachFile() {
    setState(() {
      _attachedFileName = "Study_Notes_${DateTime.now().second}.pdf";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Attached file: $_attachedFileName"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedTheme(
      data: Theme.of(context),
      duration: const Duration(milliseconds: 200),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgCard,
          foregroundColor: textColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: "Back to Dashboard",
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.groupName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.groupSubject} • Group ID: ${widget.groupId}",
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFFA8A29E) : Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Text(isDark ? "☀️" : "🌙", style: const TextStyle(fontSize: 18)),
              onPressed: widget.onToggleTheme,
              tooltip: "Toggle Theme",
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 750;

              return Row(
                children: [
                  // MAIN CHAT AREA
                  Expanded(
                    child: Column(
                      children: [
                        // Messages Stream
                        Expanded(
                          child: _messages.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No messages yet. Start the conversation!",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    return _buildMessageBubble(_messages[index], isDark, textColor);
                                  },
                                ),
                        ),

                        // TYPING INDICATOR BANNER
                        if (_typingUser != null)
                          Builder(builder: (context) {
                            final typingColor = _getMemberColor(_typingUser!, isDark);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: typingColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "$_typingUser is typing...",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: typingColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                        // File Attachment Banner
                        if (_attachedFileName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf, size: 18, color: Color(0xFF2563EB)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _attachedFileName!,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _attachedFileName = null),
                                  child: const Icon(Icons.close, size: 16, color: Colors.red),
                                ),
                              ],
                            ),
                          ),

                        // Emoji Picker Sheet
                        if (_showEmojiPicker)
                          Container(
                            height: 180,
                            color: bgCard,
                            padding: const EdgeInsets.all(8),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                              ),
                              itemCount: _emojis.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _messageController.text += _emojis[index];
                                  },
                                  child: Center(
                                    child: Text(_emojis[index], style: const TextStyle(fontSize: 20)),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Input Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: bgCard,
                            border: Border(
                              top: BorderSide(
                                color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _showEmojiPicker ? Icons.keyboard : Icons.sentiment_satisfied_alt,
                                  color: isDark ? const Color(0xFFA8A29E) : Colors.grey[700],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showEmojiPicker = !_showEmojiPicker;
                                  });
                                },
                                tooltip: "Emoji Picker",
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.attach_file,
                                  color: isDark ? const Color(0xFFA8A29E) : Colors.grey[700],
                                ),
                                onPressed: _attachFile,
                                tooltip: "Attach File",
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  onChanged: _onTextChanged,
                                  onSubmitted: (_) => _sendMessage(),
                                  decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    filled: true,
                                    fillColor: isDark ? const Color(0xFF0C0A09) : const Color(0xFFF7F5F0),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: isDark ? const Color(0xFF292524) : const Color(0xFFD6D3CE),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor,
                                child: IconButton(
                                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                                  onPressed: _sendMessage,
                                  tooltip: "Send Message",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SIDEBAR: MEMBERS LIST (Desktop / Wide screen)
                  if (isWide)
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: bgCard,
                        border: Border(
                          left: BorderSide(
                            color: isDark ? const Color(0xFF292524) : const Color(0xFFE7E5E0),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people_alt, size: 18, color: Color(0xFF2563EB)),
                              const SizedBox(width: 8),
                              Text(
                                "Group Members (${widget.members.length})",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.members.length,
                              itemBuilder: (context, index) {
                                final member = widget.members[index];
                                final isYou = member == widget.currentUser;
                                final memberColor = _getMemberColor(member, isDark);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: memberColor,
                                            child: Text(
                                              member.substring(0, 1),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: bgCard, width: 1.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          isYou ? "$member (You)" : member,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: memberColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark, Color textColor) {
    final memberColor = _getMemberColor(msg.author, isDark);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: msg.isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // NAME ON TOP OF MESSAGE
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg.isYou ? "${msg.author} (You)" : msg.author,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: memberColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                msg.time,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? const Color(0xFFA8A29E) : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // MESSAGE BUBBLE & FILE ATTACHMENTS WITH UNIQUE MEMBER COLOR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: memberColor.withOpacity(isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: memberColor.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.text.isNotEmpty)
                  Text(
                    msg.text,
                    style: TextStyle(fontSize: 13, color: textColor),
                  ),
                if (msg.fileName != null) ...[
                  if (msg.text.isNotEmpty) const SizedBox(height: 8),

                  // FILE CARD WITH PERSON'S COLOR
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: memberColor.withOpacity(isDark ? 0.25 : 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: memberColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 18, color: memberColor),
                        const SizedBox(width: 8),
                        Text(
                          msg.fileName!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: memberColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
