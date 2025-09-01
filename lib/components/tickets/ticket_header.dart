import 'package:flutter/material.dart';
import 'package:smore_mobile_app/models/product.dart';
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
    // Always show left-aligned product icon and name
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xB50D151E),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(5),
          child: Icon(_getProductIcon()),
        ),
        const SizedBox(width: 10),
        Text(
          ticket.product.name.displayName,
          style: const TextStyle(color: Color(0xFFdbe4ed)),
        ),
      ],
    );
  }

  IconData _getProductIcon() {
    switch (ticket.product.name) {
      case ProductName.SOCCER:
        return Icons.sports_soccer;
      case ProductName.BASKETBALL:
        return Icons.sports_basketball;
      case ProductName.TENNIS:
        return Icons.sports_tennis;
      case ProductName.NFL_NHL:
        return Icons.sports_football;
      case ProductName.AI_ANALYST:
        return Icons.psychology;
      default:
        return Icons.sports;
    }
  }
}
