import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:conflictsense/screens/ai_research/models/research_models.dart';

class ResearchSessionSnapshot {
  const ResearchSessionSnapshot({
    required this.selectedTopic,
    required this.messages,
  });

  final String selectedTopic;
  final List<ChatMessage> messages;
}

class ResearchSessionStore {
  ResearchSessionStore({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const String _usersCollection = 'users';
  static const String _sessionCollection = 'ai_research';
  static const String _sessionDocId = 'default_session';

  Future<ResearchSessionSnapshot?> loadSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_sessionCollection)
          .doc(_sessionDocId)
          .get();

      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        return null;
      }

      final selectedTopic = (data['selectedTopic'] as String?)?.trim() ?? '';
      final messages = _parseMessages(data['messages']);

      return ResearchSessionSnapshot(
        selectedTopic: selectedTopic,
        messages: messages,
      );
    } catch (error) {
      debugPrint('ResearchSessionStore.loadSession failed: $error');
      return null;
    }
  }

  Future<void> saveSession({
    required String selectedTopic,
    required List<ChatMessage> messages,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final safeTopic = selectedTopic.trim();
    final safeMessages = messages.length > 40
        ? messages.sublist(messages.length - 40)
        : List<ChatMessage>.from(messages);

    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_sessionCollection)
          .doc(_sessionDocId)
          .set(
        {
          'selectedTopic': safeTopic,
          'messages': safeMessages.map(_chatMessageToMap).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      debugPrint('ResearchSessionStore.saveSession failed: $error');
    }
  }

  List<ChatMessage> _parseMessages(dynamic rawMessages) {
    if (rawMessages is! List) {
      return const [];
    }

    final parsed = <ChatMessage>[];

    for (final entry in rawMessages) {
      if (entry is! Map) {
        continue;
      }

      final messageMap = Map<String, dynamic>.from(entry);
      final isUser = messageMap['isUser'] == true;

      if (isUser) {
        final text = (messageMap['text'] as String?)?.trim() ?? '';
        if (text.isNotEmpty) {
          parsed.add(ChatMessage(isUser: true, text: text));
        }
        continue;
      }

      final rawBlocks = messageMap['blocks'];
      final blocks = <AiResponseBlock>[];

      if (rawBlocks is List) {
        for (var i = 0; i < rawBlocks.length; i++) {
          final block = rawBlocks[i];
          if (block is! Map) {
            continue;
          }

          blocks.add(
            AiResponseBlock.fromMap(
              Map<String, dynamic>.from(block),
              index: i,
            ),
          );
        }
      }

      if (blocks.isNotEmpty) {
        parsed.add(ChatMessage(isUser: false, blocks: blocks));
      }
    }

    return parsed;
  }

  Map<String, dynamic> _chatMessageToMap(ChatMessage message) {
    if (message.isUser) {
      return {
        'isUser': true,
        'text': message.text.trim(),
      };
    }

    return {
      'isUser': false,
      'blocks': message.blocks.map(_blockToMap).toList(),
    };
  }

  Map<String, dynamic> _blockToMap(AiResponseBlock block) {
    return {
      'type': _blockTypeToRaw(block.type),
      'title': block.title,
      'content': block.text,
      'ideas': block.ideas,
      'scenarios': block.scenarios
          .map(
            (scenario) => {
              'title': scenario.title,
              'outcome': scenario.outcome,
              'pros': scenario.pros,
              'cons': scenario.cons,
            },
          )
          .toList(),
      'items': block.feedItems
          .map(
            (item) => {
              'image': item.image,
              'headline': item.headline,
              'preview': item.preview,
              'content': item.content,
              'category': item.category,
            },
          )
          .toList(),
    };
  }

  String _blockTypeToRaw(AiBlockType type) {
    switch (type) {
      case AiBlockType.highlight:
        return 'highlight';
      case AiBlockType.brainstorm:
        return 'brainstorm';
      case AiBlockType.simulation:
        return 'simulation';
      case AiBlockType.feed:
        return 'feed';
      case AiBlockType.expandable:
        return 'expandable';
      case AiBlockType.text:
        return 'text';
    }
  }
}
