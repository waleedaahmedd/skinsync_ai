import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpChatOption {
  final String id;
  final String label;
  final String? nextQuestionId;
  final void Function(BuildContext context, WidgetRef ref)? action;

  HelpChatOption({
    required this.id,
    required this.label,
    this.nextQuestionId,
    this.action,
  });
}

class HelpChatQuestion {
  final String id;
  final String text;
  final List<HelpChatOption> options;

  HelpChatQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
}

class HelpChatMessage {
  final String id;
  final String text;
  final bool isAssistant;
  final List<HelpChatOption> options;
  final DateTime timestamp;
  final bool isTyping;

  HelpChatMessage({
    required this.id,
    required this.text,
    required this.isAssistant,
    this.options = const [],
    DateTime? timestamp,
    this.isTyping = false,
  }) : timestamp = timestamp ?? DateTime.now();

  HelpChatMessage copyWith({
    String? id,
    String? text,
    bool? isAssistant,
    List<HelpChatOption>? options,
    DateTime? timestamp,
    bool? isTyping,
  }) {
    return HelpChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isAssistant: isAssistant ?? this.isAssistant,
      options: options ?? this.options,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
