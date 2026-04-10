import 'dart:async';

import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/data/research_mock_data.dart';
import 'package:conflictsense/screens/ai_research/models/research_models.dart';
import 'package:conflictsense/screens/ai_research/research_detail_page.dart';
import 'package:conflictsense/screens/ai_research/services/gemini_research_service.dart';
import 'package:conflictsense/screens/ai_research/services/research_session_store.dart';
import 'package:conflictsense/screens/ai_research/widgets/brainstorm_grid.dart';
import 'package:conflictsense/screens/ai_research/widgets/chat_bubble.dart';
import 'package:conflictsense/screens/ai_research/widgets/feed_card.dart';
import 'package:conflictsense/screens/ai_research/widgets/prompt_chips.dart';
import 'package:conflictsense/screens/ai_research/widgets/simulation_card.dart';
import 'package:conflictsense/screens/feed_screen.dart';
import 'package:conflictsense/screens/profile_screen.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class AIResearchScreen extends StatefulWidget {
  const AIResearchScreen({
    super.key,
    this.initialPrompt,
    this.initialTopic,
  });

  final String? initialPrompt;
  final String? initialTopic;

  @override
  State<AIResearchScreen> createState() => _AIResearchScreenState();
}

class _AIResearchScreenState extends State<AIResearchScreen> {
  final GeminiResearchService _geminiService = GeminiResearchService();
  final ResearchSessionStore _sessionStore = ResearchSessionStore();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<String>? _responseSubscription;

  late String _selectedSavedTopic;
  int _visibleFeedCount = 3;

  bool _isSending = false;
  bool _didCancelResponse = false;
  bool _sessionReady = false;
  bool _hasUserInteracted = false;
  String _streamingPreview = '';

  static const List<ChatMessage> _defaultMessages = [
    ChatMessage(
      isUser: false,
      blocks: [
        AiResponseBlock(
          type: AiBlockType.highlight,
          title: 'AI Research Lab Ready',
          text:
              'Ask complex questions, compare technologies, run simulations, and generate structured outputs instantly.',
        ),
      ],
    ),
  ];

  List<ChatMessage> _messages = _defaultMessages;

  static const List<_BottomTabData> _bottomTabs = [
    _BottomTabData(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _BottomTabData(
      label: 'Bookmark',
      icon: Icons.bookmark_border_rounded,
      selectedIcon: Icons.bookmark_rounded,
    ),
    _BottomTabData(
      label: 'AI Research',
      icon: Icons.psychology_alt_outlined,
      selectedIcon: Icons.psychology_alt_rounded,
    ),
    _BottomTabData(
      label: 'Trends',
      icon: Icons.local_fire_department_outlined,
      selectedIcon: Icons.local_fire_department_rounded,
    ),
    _BottomTabData(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSavedTopic = kSavedResearchTopics.first;

    final initialTopic = widget.initialTopic?.trim() ?? '';
    if (initialTopic.isNotEmpty &&
        kSavedResearchTopics.contains(initialTopic)) {
      _selectedSavedTopic = initialTopic;
      _hasUserInteracted = true;
    }

    final initialPrompt = widget.initialPrompt?.trim() ?? '';
    if (initialPrompt.isNotEmpty) {
      _inputController.text = initialPrompt;
      _inputController.selection = TextSelection.collapsed(
        offset: initialPrompt.length,
      );
      _hasUserInteracted = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToBottom();
        }
      });
    }

    unawaited(_restoreSession());
  }

  @override
  void dispose() {
    unawaited(_persistSession());
    unawaited(_responseSubscription?.cancel());
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _restoreSession() async {
    final snapshot = await _sessionStore.loadSession();
    if (!mounted) {
      return;
    }

    final restoredMessages = snapshot?.messages ?? const <ChatMessage>[];

    setState(() {
      _sessionReady = true;

      final restoredTopic = snapshot?.selectedTopic.trim() ?? '';
      if (!_hasUserInteracted &&
          restoredTopic.isNotEmpty &&
          kSavedResearchTopics.contains(restoredTopic)) {
        _selectedSavedTopic = restoredTopic;
      }

      if (!_hasUserInteracted && restoredMessages.isNotEmpty) {
        _messages = restoredMessages;
      }
    });
  }

  Future<void> _persistSession() async {
    if (!_sessionReady) {
      return;
    }

    await _sessionStore.saveSession(
      selectedTopic: _selectedSavedTopic,
      messages: _messages,
    );
  }

  void _applyPromptChip(String value) {
    _inputController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
  }

  void _applyMiniTool(MiniToolData tool) {
    final text = '${tool.seedPrompt}$_selectedSavedTopic';
    _inputController
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
  }

  Future<void> _showSavedTopicsSelector() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Saved Research Topics',
                  style: TextStyle(
                    color: Color(0xFF242A33),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ...kSavedResearchTopics.map(
                  (topic) => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      topic == _selectedSavedTopic
                          ? Icons.check_circle_rounded
                          : Icons.bookmark_outline_rounded,
                      color: topic == _selectedSavedTopic
                          ? const Color(0xFF3F7E5A)
                          : const Color(0xFF8A919D),
                    ),
                    title: Text(
                      topic,
                      style: const TextStyle(
                        color: Color(0xFF262D37),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _hasUserInteracted = true;
                      setState(() {
                        _selectedSavedTopic = topic;
                      });
                      unawaited(_persistSession());
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetail(ResearchFeedItem item, String heroTag) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ResearchDetailPage(
              item: item,
              heroTag: heroTag,
            ),
          );
        },
      ),
    );
  }

  void _loadMoreFeed() {
    if (_visibleFeedCount >= kSuggestedResearchFeed.length) {
      return;
    }

    setState(() {
      _visibleFeedCount = (_visibleFeedCount + 3).clamp(
        0,
        kSuggestedResearchFeed.length,
      );
    });
  }

  List<ChatContextTurn> _buildHistoryContext() {
    final recent = _messages.reversed.take(8).toList().reversed;

    return recent.map((message) {
      if (message.isUser) {
        return ChatContextTurn(role: 'user', text: message.text);
      }

      final blockText = message.blocks
          .map((block) {
            final title = block.title.trim();
            final text = block.text.trim();
            if (title.isNotEmpty && text.isNotEmpty) {
              return '$title: $text';
            }
            if (text.isNotEmpty) {
              return text;
            }
            return title;
          })
          .where((part) => part.trim().isNotEmpty)
          .join(' | ');

      return ChatContextTurn(
        role: 'assistant',
        text: blockText.isNotEmpty ? blockText : 'Structured AI response',
      );
    }).toList();
  }

  Future<void> _sendQuery() async {
    final query = _inputController.text.trim();
    if (query.isEmpty || _isSending) {
      return;
    }

    _hasUserInteracted = true;

    setState(() {
      _messages = [
        ..._messages,
        ChatMessage(isUser: true, text: query),
      ];
      _isSending = true;
      _streamingPreview = '';
    });
    unawaited(_persistSession());

    _inputController.clear();
    _scrollToBottom();

    String finalRaw = '';
    _didCancelResponse = false;

    try {
      final responseStream = await _geminiService.streamStructuredResponse(
        userPrompt: query,
        history: _buildHistoryContext(),
        savedTopic: _selectedSavedTopic,
      );

      final streamDone = Completer<void>();

      _responseSubscription = responseStream.listen(
        (partial) {
          finalRaw = partial;
          if (!mounted) {
            return;
          }

          setState(() {
            _streamingPreview = partial;
          });
          _scrollToBottom();
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!mounted) {
            if (!streamDone.isCompleted) {
              streamDone.complete();
            }
            return;
          }

          if (_didCancelResponse) {
            if (!streamDone.isCompleted) {
              streamDone.complete();
            }
            return;
          }

          setState(() {
            _messages = [
              ..._messages,
              ChatMessage(
                isUser: false,
                blocks: [
                  const AiResponseBlock(
                    type: AiBlockType.highlight,
                    title: 'AI Connection Error',
                    text:
                        'Unable to complete the Gemini request right now. Check API key in .env and network connectivity.',
                  ),
                  AiResponseBlock(
                    type: AiBlockType.expandable,
                    title: 'Technical Details',
                    text: error.toString(),
                  ),
                ],
              ),
            ];
            _streamingPreview = '';
            _isSending = false;
          });
          unawaited(_persistSession());

          if (!streamDone.isCompleted) {
            streamDone.complete();
          }
        },
        onDone: () {
          if (!mounted) {
            if (!streamDone.isCompleted) {
              streamDone.complete();
            }
            return;
          }

          if (_didCancelResponse) {
            if (!streamDone.isCompleted) {
              streamDone.complete();
            }
            return;
          }

          final blocks = _geminiService.parseStructuredBlocks(finalRaw);
          setState(() {
            _messages = [
              ..._messages,
              ChatMessage(isUser: false, blocks: blocks),
            ];
            _streamingPreview = '';
            _isSending = false;
          });
          unawaited(_persistSession());

          if (!streamDone.isCompleted) {
            streamDone.complete();
          }
        },
        cancelOnError: true,
      );

      await streamDone.future;
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _messages = [
          ..._messages,
          ChatMessage(
            isUser: false,
            blocks: [
              const AiResponseBlock(
                type: AiBlockType.highlight,
                title: 'AI Connection Error',
                text:
                    'Unable to complete the Gemini request right now. Check API key in .env and network connectivity.',
              ),
              AiResponseBlock(
                type: AiBlockType.expandable,
                title: 'Technical Details',
                text: error.toString(),
              ),
            ],
          ),
        ];
        _streamingPreview = '';
        _isSending = false;
      });
      unawaited(_persistSession());
    } finally {
      await _responseSubscription?.cancel();
      _responseSubscription = null;
    }

    _scrollToBottom();
  }

  Future<void> _cancelStreaming() async {
    if (!_isSending) {
      return;
    }

    _didCancelResponse = true;
    await _responseSubscription?.cancel();
    _responseSubscription = null;

    if (!mounted) {
      return;
    }

    setState(() {
      _isSending = false;
      _streamingPreview = '';
      _messages = [
        ..._messages,
        const ChatMessage(
          isUser: false,
          blocks: [
            AiResponseBlock(
              type: AiBlockType.highlight,
              title: 'Generation Stopped',
              text:
                  'Response generation was stopped. You can send a new prompt.',
            ),
          ],
        ),
      ];
    });
    unawaited(_persistSession());
    _scrollToBottom();
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 2) {
      return;
    }

    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const FeedScreen(),
        ),
      );
      return;
    }

    if (index == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const UserProfileScreen(),
        ),
      );
      return;
    }

    final label = _bottomTabs[index].label;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label section is coming soon.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleFeed = kSuggestedResearchFeed.take(_visibleFeedCount).toList();

    return Scaffold(
      backgroundColor: AppVisualTheme.canvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppVisualTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              const _ResearchTopBar(),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  children: [
                    Text(
                      'Ask anything, analyze deeply, and simulate outcomes using AI.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppVisualTheme.mutedInk,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 12),
                    PromptChips(
                      prompts: kSmartPrompts,
                      onPromptTap: _applyPromptChip,
                    ),
                    const SizedBox(height: 14),
                    _SavedTopicSelector(
                      selectedTopic: _selectedSavedTopic,
                      onTap: _showSavedTopicsSelector,
                    ),
                    const SizedBox(height: 14),
                    _MiniToolsGrid(
                      tools: kMiniTools,
                      onTap: _applyMiniTool,
                    ),
                    const SizedBox(height: 20),
                    const _SectionTitle(title: 'AI Suggested Feed'),
                    const SizedBox(height: 10),
                    ...visibleFeed.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FeedCard(
                              item: entry.value,
                              heroTag: 'research-feed-${entry.key}',
                              onTap: () => _openDetail(
                                entry.value,
                                'research-feed-${entry.key}',
                              ),
                            ),
                          ),
                        ),
                    if (_visibleFeedCount < kSuggestedResearchFeed.length)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: _loadMoreFeed,
                          icon: const Icon(Icons.expand_more_rounded),
                          label: const Text('Load More Research'),
                        ),
                      ),
                    const SizedBox(height: 14),
                    const _SectionTitle(title: 'Research Chat'),
                    const SizedBox(height: 10),
                    ..._messages.map(_buildMessage),
                    if (_isSending)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _TypingPreviewCard(
                          text: _streamingPreview,
                          onStop: _cancelStreaming,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            border: const Border(
              top: BorderSide(color: AppVisualTheme.cardStroke),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputComposer(
                controller: _inputController,
                onSend: _sendQuery,
                onStop: _cancelStreaming,
                onMic: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Microphone input will be added next.'),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                },
                isSending: _isSending,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
                child: Row(
                  children: List.generate(
                    _bottomTabs.length,
                    (index) => Expanded(
                      child: _BottomNavItem(
                        data: _bottomTabs[index],
                        isSelected: index == 2,
                        onTap: () => _onBottomNavTap(index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: ChatBubble(
            text: message.text,
            isUser: true,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: message.blocks.map(_buildAiBlock).toList(),
        ),
      ),
    );
  }

  Widget _buildAiBlock(AiResponseBlock block) {
    switch (block.type) {
      case AiBlockType.highlight:
        return _InsightBox(
          title: block.title,
          text: block.text,
        );
      case AiBlockType.brainstorm:
        return BrainstormGrid(
          title: block.title,
          ideas: block.ideas,
        );
      case AiBlockType.simulation:
        if (block.scenarios.isEmpty) {
          return ChatBubble(
            text: block.text,
            isUser: false,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.title.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  block.title,
                  style: const TextStyle(
                    color: Color(0xFF303743),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ...block.scenarios.map(
              (scenario) => SimulationCard(scenario: scenario),
            ),
          ],
        );
      case AiBlockType.feed:
        if (block.feedItems.isEmpty) {
          return ChatBubble(
            text: block.text,
            isUser: false,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.title.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  block.title,
                  style: const TextStyle(
                    color: Color(0xFF303743),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ...block.feedItems.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FeedCard(
                      item: entry.value,
                      heroTag:
                          'chat-feed-${entry.key}-${entry.value.headline.hashCode}',
                      onTap: () => _openDetail(
                        entry.value,
                        'chat-feed-${entry.key}-${entry.value.headline.hashCode}',
                      ),
                    ),
                  ),
                ),
          ],
        );
      case AiBlockType.expandable:
        return _ExpandableResponseCard(
          title: block.title,
          text: block.text,
        );
      case AiBlockType.text:
        final text = block.title.trim().isNotEmpty
            ? '${block.title}\n${block.text}'
            : block.text;
        return ChatBubble(
          text: text,
          isUser: false,
        );
    }
  }
}

class _ResearchTopBar extends StatelessWidget {
  const _ResearchTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppVisualTheme.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              children: [
                _AppLogo(),
                Spacer(),
                _ProfileAvatar(),
              ],
            ),
            Text(
              'AI Chat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppVisualTheme.ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppVisualTheme.brandBlue,
                AppVisualTheme.brandTeal,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 19,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'IntelNova',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFC8D6F1)),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppVisualTheme.brandBlue,
      ),
    );
  }
}

class _SavedTopicSelector extends StatelessWidget {
  const _SavedTopicSelector({
    required this.selectedTopic,
    required this.onTap,
  });

  final String selectedTopic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppVisualTheme.cardStroke),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.bookmark_rounded,
                size: 17,
                color: AppVisualTheme.brandBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedTopic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppVisualTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppVisualTheme.mutedInk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniToolsGrid extends StatelessWidget {
  const _MiniToolsGrid({
    required this.tools,
    required this.onTap,
  });

  final List<MiniToolData> tools;
  final ValueChanged<MiniToolData> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Mini Tools'),
        const SizedBox(height: 10),
        GridView.builder(
          itemCount: tools.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return _MiniToolCard(
              tool: tool,
              onTap: () => onTap(tool),
            );
          },
        ),
      ],
    );
  }
}

class _MiniToolCard extends StatelessWidget {
  const _MiniToolCard({
    required this.tool,
    required this.onTap,
  });

  final MiniToolData tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppVisualTheme.cardStroke),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tool.icon,
                  size: 18,
                  color: AppVisualTheme.brandBlue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tool.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppVisualTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppVisualTheme.ink,
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DEF7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                color: AppVisualTheme.brandBlue,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          if (title.trim().isNotEmpty) const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppVisualTheme.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableResponseCard extends StatefulWidget {
  const _ExpandableResponseCard({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  State<_ExpandableResponseCard> createState() =>
      _ExpandableResponseCardState();
}

class _ExpandableResponseCardState extends State<_ExpandableResponseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = _expanded ? null : 4;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppVisualTheme.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.trim().isNotEmpty)
            Text(
              widget.title,
              style: const TextStyle(
                color: AppVisualTheme.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (widget.title.trim().isNotEmpty) const SizedBox(height: 6),
          Text(
            widget.text,
            maxLines: maxLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppVisualTheme.mutedInk,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Read Less' : 'Read More / Expand'),
          ),
        ],
      ),
    );
  }
}

class _TypingPreviewCard extends StatelessWidget {
  const _TypingPreviewCard({
    required this.text,
    required this.onStop,
  });

  final String text;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final preview = text.trim().isEmpty ? 'Thinking...' : text.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppVisualTheme.cardStroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              preview,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppVisualTheme.mutedInk,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: onStop,
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}

class _InputComposer extends StatelessWidget {
  const _InputComposer({
    required this.controller,
    required this.onSend,
    required this.onStop,
    required this.onMic,
    required this.isSending,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final VoidCallback onMic;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppVisualTheme.cardStroke),
              ),
              child: TextField(
                controller: controller,
                enabled: !isSending,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText:
                      'Ask anything about research, ideas, or simulations...',
                  hintStyle: TextStyle(fontSize: 13),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Voice input',
            onPressed: isSending ? null : onMic,
            icon: const Icon(Icons.mic_none_rounded),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppVisualTheme.brandBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isSending ? onStop : onSend,
              icon: isSending
                  ? const Icon(Icons.stop_rounded, color: Colors.white)
                  : const Icon(Icons.arrow_upward_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _BottomTabData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isSelected ? AppVisualTheme.brandBlue : const Color(0xFF8B929E);
    final textColor =
        isSelected ? AppVisualTheme.brandBlue : const Color(0xFF8B929E);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppVisualTheme.brandBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? data.selectedIcon : data.icon,
                size: 21,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTabData {
  const _BottomTabData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
