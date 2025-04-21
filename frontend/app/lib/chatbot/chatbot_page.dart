import 'package:dash_chat_2/dash_chat_2.dart' as dc2;
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:print_ia_chat_bot/app/custom_theme.dart';
import 'package:print_ia_chat_bot/app/models/app_state.dart';
import 'package:print_ia_chat_bot/services/chatbot_service.dart';
import 'package:provider/provider.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

/// Advanced example of Flutter Gen AI Chat UI demonstrating all features
class AdvancedChatScreen extends StatefulWidget {
  const AdvancedChatScreen({super.key});

  @override
  State<AdvancedChatScreen> createState() => _AdvancedChatScreenState();
}

class _AdvancedChatScreenState extends State<AdvancedChatScreen> {
  // Controller for managing chat messages
  final _chatController = ChatMessagesController();

  late final WaveformRecorderController _waveController =
      WaveformRecorderController(
    config: const RecordConfig(encoder: AudioEncoder.wav),
  );

  // User definitions with avatars
  final _currentUser = const ChatUser(
    id: 'user123',
    firstName: 'You',
    avatar: 'https://ui-avatars.com/api/?name=User&background=6366f1&color=fff',
  );

  final _aiUser = const ChatUser(
    id: 'ai123',
    firstName: 'Insight AI',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=10b981&color=fff',
  );

  bool _isGenerating = false;

  // Scroll controller for managing scroll position
  final ScrollController _scrollController = ScrollController();

  var _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _chatController.addMessage(
      ChatMessage(
        text: 'test',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    _chatController.addMessage(
      ChatMessage(
        text: 'test',
        user: _currentUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    // Set up the chat controller to use our scroll controller
    _chatController.setScrollController(_scrollController);
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _waveController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Handle sending a message with support for streaming
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Add the user's message to the chat
    _chatController.addMessage(message);

    // Non-streaming approach with loading indicator
    setState(() => _isGenerating = true);

    try {
      // Generate response with delay
      final response = await askBot(
        message.text,
      ).onError(
        (error, stackTrace) {
          throw Exception(error);
        },
      );

      // Add complete response
      _chatController.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        ),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Gradient background
      body: AdvancedThemeProvider(
        child: Builder(
          builder: (context) {
            final advancedTheme = AdvancedTheme.of(context);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    advancedTheme.gradientStart,
                    advancedTheme.gradientEnd,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Information Provider Chat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              switch (appState.themeMode) {
                                ThemeMode.system => Icons.auto_mode_rounded,
                                ThemeMode.light => Icons.light_mode_rounded,
                                ThemeMode.dark => Icons.dark_mode_rounded,
                              },
                              color: colorScheme.primary,
                            ),
                            onPressed: appState.toggleTheme,
                          ),
                        ],
                      ),
                    ),

                    // Chat widget
                    Expanded(
                      child: AiChatWidget(
                        currentUser: _currentUser,
                        aiUser: _aiUser,
                        controller: _chatController,
                        aiName: 'Print AI',
                        onSendMessage: _handleSendMessage,
                        scrollController: _scrollController,

                        // Message styling
                        messageOptions: MessageOptions(
                          userNameStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          timeTextStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: isDark ? Colors.white54 : Colors.black38,
                              ),
                          bubbleStyle: BubbleStyle(
                            userBubbleColor: advancedTheme.userBubbleColor,
                            aiBubbleColor: advancedTheme.aiBubbleColor,
                            userNameColor: advancedTheme.userTextColor,
                            aiNameColor: advancedTheme.aiTextColor,
                            copyIconColor: advancedTheme.aiTextColor,
                            userBubbleTopLeftRadius:
                                appState.messageBorderRadius,
                            userBubbleTopRightRadius: 4,
                            aiBubbleTopLeftRadius: 4,
                            aiBubbleTopRightRadius:
                                appState.messageBorderRadius,
                            bottomLeftRadius: appState.messageBorderRadius,
                            bottomRightRadius: appState.messageBorderRadius,
                          ),
                          timeFormat: (dateTime) =>
                              '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                          markdownStyleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: appState.fontSize,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            code: TextStyle(
                              fontFamily: 'monospace',
                              backgroundColor: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: advancedTheme.codeBlockBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            codeblockPadding: const EdgeInsets.all(12),
                          ),
                        ),

                        // Loading configuration
                        loadingConfig: LoadingConfig(
                          isLoading: _isGenerating,
                          typingIndicatorColor: colorScheme.primary,
                        ),

                        // Example questions
                        exampleQuestions: [
                          ExampleQuestion(
                            question: "¿Cuales son tus capacidades?",
                            config: ExampleQuestionConfig(
                              textStyle: const TextStyle(),
                              iconData: Icons.psychology,
                              iconColor: isDark ? Colors.white : Colors.black87,
                              trailingIconColor:
                                  (isDark ? Colors.white : Colors.black87)
                                      .withOpacity(0.4),
                              containerDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.withOpacity(0.1),
                                    Colors.blue.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          ExampleQuestion(
                            question:
                                "¡¡¡Me encantan los libros de Economía!!!",
                            config: ExampleQuestionConfig(
                              iconData: Icons.insights,
                              iconColor: isDark ? Colors.white : Colors.black87,
                              trailingIconColor:
                                  (isDark ? Colors.white : Colors.black87)
                                      .withOpacity(0.4),
                              textStyle: const TextStyle(),
                              containerDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.withOpacity(0.1),
                                    Colors.orange.withOpacity(0.1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          ExampleQuestion(
                            question: "¿Qué hay de nuevo en Hacker News?",
                            config: ExampleQuestionConfig(
                              textStyle: const TextStyle(),
                              iconData: Icons.category,
                              iconColor: isDark ? Colors.white : Colors.black87,
                              trailingIconColor:
                                  (isDark ? Colors.white : Colors.black87)
                                      .withOpacity(0.4),
                              containerDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.withOpacity(0.1),
                                    Colors.red.withOpacity(0.1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ],
                        persistentExampleQuestions:
                            appState.persistentExampleQuestions,

                        // Width constraint
                        maxWidth: appState.chatMaxWidth,

                        // Input customization
                        inputOptions: InputOptions(
                          materialShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          textController: _textController,
                          sendButtonBuilder: (onSend) {
                            if (_textController.text.isEmpty) {
                              return IconButton(
                                icon: Icon(
                                  Icons.mic,
                                  color: colorScheme.primary,
                                ),
                                onPressed: () async {
                                  if (_waveController.isRecording) return;
                                  await _waveController.startRecording();
                                  showBottomSheet(
                                    context: context,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(),
                                    constraints: const BoxConstraints(),
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return AnimatedBuilder(
                                        animation: _waveController,
                                        builder: (context, child) {
                                          if (_waveController.isRecording) {
                                            return CustomRecorder(
                                              waveController: _waveController,
                                              onRecordStopped: () async {
                                                final file =
                                                    _waveController.file;

                                                if (file != null) {
                                                  _chatController.addMessage(
                                                    ChatMessage(
                                                      text: '*Audio*',
                                                      isMarkdown: true,
                                                      user: _currentUser,
                                                      createdAt: DateTime.now(),
                                                      media: [
                                                        ChatMedia(
                                                          url: file.path,
                                                          type: ChatMediaType
                                                              .audio,
                                                        )
                                                      ],
                                                    ),
                                                  );

// Non-streaming approach with loading indicator
                                                  setState(() =>
                                                      _isGenerating = true);

                                                  try {
                                                    // Generate response with delay
                                                    final response =
                                                        await askBot(
                                                      null,
                                                      await file.readAsBytes(),
                                                    ).onError(
                                                      (error, stackTrace) {
                                                        throw Exception(error);
                                                      },
                                                    );

                                                    // Add complete response
                                                    _chatController.addMessage(
                                                      ChatMessage(
                                                        text: response,
                                                        user: _aiUser,
                                                        createdAt:
                                                            DateTime.now(),
                                                        isMarkdown: true,
                                                      ),
                                                    );
                                                  } finally {
                                                    setState(() =>
                                                        _isGenerating = false);
                                                  }
                                                }
                                              },
                                            );
                                          }
                                          return const LinearProgressIndicator();
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            }

                            return IconButton(
                              icon: Icon(
                                Icons.send_rounded,
                                color: colorScheme.primary,
                              ),
                              onPressed: onSend,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: advancedTheme.inputBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          textStyle: TextStyle(
                            fontSize: appState.fontSize,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),

                        // Animation settings
                        enableAnimation: appState.enableAnimation,
                        enableMarkdownStreaming: appState.isStreaming,
                        streamingDuration: const Duration(milliseconds: 15),

                        // Pagination configuration
                        paginationConfig: const PaginationConfig(
                          enabled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // endDrawer: const AdvancedSettingsDrawer(),
    );
  }
}

class CustomRecorder extends StatelessWidget {
  const CustomRecorder({
    required WaveformRecorderController waveController,
    required this.onRecordStopped,
    super.key,
  }) : _waveController = waveController;

  final WaveformRecorderController _waveController;
  final VoidCallback onRecordStopped;

  @override
  Widget build(BuildContext context) {
    return AdvancedThemeProvider(
      child: Builder(
        builder: (context) {
          final advancedTheme = AdvancedTheme.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final colorScheme = Theme.of(context).colorScheme;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: advancedTheme.aiBubbleColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                spacing: 10,
                children: [
                  const AnimatedRecorderIndicator(),
                  Expanded(
                    child: WaveformRecorder(
                      height: 50,
                      controller: _waveController,
                      waveColor: advancedTheme.aiTextColor,
                      onRecordingStopped: () {
                        Navigator.of(context).pop();
                        onRecordStopped();
                      },
                      durationTextStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ) ??
                              const TextStyle(
                                color: Color(0xFF000000),
                              ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: colorScheme.primary,
                    ),
                    onPressed: _waveController.stopRecording,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _waveController.cancelRecording();
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedRecorderIndicator extends StatefulWidget {
  const AnimatedRecorderIndicator({super.key});

  @override
  State<AnimatedRecorderIndicator> createState() =>
      _AnimatedRecorderIndicatorState();
}

class _AnimatedRecorderIndicatorState extends State<AnimatedRecorderIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: const Badge(
        smallSize: 8,
      ),
    );
  }
}
