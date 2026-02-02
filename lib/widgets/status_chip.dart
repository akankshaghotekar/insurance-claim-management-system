import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case 'Approved':
        return Colors.green.shade100;
      case 'Rejected':
        return Colors.red.shade100;
      case 'Submitted':
        return Colors.blue.shade100;
      case 'Partially Settled':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'Approved':
        return Colors.green.shade800;
      case 'Rejected':
        return Colors.red.shade800;
      case 'Submitted':
        return Colors.blue.shade800;
      case 'Partially Settled':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
