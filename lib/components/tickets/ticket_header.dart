import 'package:flutter/material.dart';
import 'package:smore_mobile_app/models/sport/ticket.dart';

class TicketHeader extends StatelessWidget {
  final Ticket ticket;
  final bool canViewTicket;

  const TicketHeader({
    super.key, 
    required this.ticket,
    required this.canViewTicket,
  });

  @override
  Widget build(BuildContext context) {
    // Show diamond icon and "Parlay X" label without background
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.diamond,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          ticket.label,
          style: const TextStyle(
            color: Color(0xFFdbe4ed),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
