import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackballTooltip extends StatelessWidget {
  const TrackballTooltip({
    required this.timestamp,
    required this.entries,
    super.key,
  });

  final DateTime timestamp;
  final List<({String name, num value, Color color})> entries;

  static String _formatValue(num value) => value is double
      ? NumberFormat('#,##0.000').format(value)
      : NumberFormat('#,##0').format(value);

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('MMM d yyyy HH:mm:ss').format(timestamp);
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF323232),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24, height: 8, thickness: 0.5),
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: entry.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.name} : ${_formatValue(entry.value)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
