import 'package:flutter/material.dart';

class InstructionListTile extends StatelessWidget {
  final String instruction;
  final int step;

  const InstructionListTile({
    super.key,
    required this.instruction,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$step',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF303030),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 2.5,
            height: 24,
            color: const Color(0xFFFBC02D), // Gold color
            margin: const EdgeInsets.only(top: 4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                instruction,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF616161),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
