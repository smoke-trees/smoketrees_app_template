import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_progress_header.dart';

class StProgressHeaderParser extends StacParser<StProgressHeader> {
  @override
  String get type => 'st_progress_header';

  @override
  StProgressHeader getModel(Map<String, dynamic> json) =>
      StProgressHeader.fromJson(json);

  @override
  Widget parse(BuildContext context, StProgressHeader model) {
    final progress = model.total > 0 ? model.completed / model.total : 0.0;
    final bgColor = _parseColor(model.backgroundColor) ?? const Color(0xFF176B53);
    final progColor = _parseColor(model.progressColor) ?? const Color(0xFFFFC857);

    String message;
    if (model.completed == 0) {
      message = _pickMessage(model.zeroMessages, 'A fresh start is a good start.');
    } else if (model.completed >= model.total) {
      message = _pickMessage(model.completedMessages, 'A beautifully consistent day.');
    } else {
      message = _pickMessage(model.partialMessages, 'You are building a rhythm.');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white24,
                  color: progColor,
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.completed} of ${model.total} complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFD5EEE1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _pickMessage(List<String>? messages, String fallback) {
    if (messages == null || messages.isEmpty) return fallback;
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
