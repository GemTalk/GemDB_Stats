import 'package:flutter/material.dart';

class CurrentToolDisplay extends StatelessWidget {
  const CurrentToolDisplay({
    required this.toolActivity,
    super.key,
  });

  final String? toolActivity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: const Color(0xFFF5F5F5),
      child: Text(
        '${toolActivity!}…',
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}
