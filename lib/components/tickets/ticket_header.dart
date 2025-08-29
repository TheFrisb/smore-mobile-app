import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/match_prediction/stake_display.dart';
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
    final isPendingWithStake = ticket.status == TicketStatus.PENDING && ticket.stake > 0;
    final shouldShowStakeAndOdds = canViewTicket && isPendingWithStake;

    if (shouldShowStakeAndOdds) {
      // Product name centered, stake and total odds below
      return Column(
        children: [
          // Product name centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          const SizedBox(height: 12),
          // Stake and total odds row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stake on the left
              StakeDisplay(
                stake: ticket.stake,
                fontSize: 14,
                displayIcon: false,
              ),
              // Total odds on the right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Odds",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ticket.totalOdds.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Color(0xFF00DEA2),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      // Original layout - only show product name and total odds if can view ticket
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          ),
          // Total odds - only show if can view ticket
          if (canViewTicket)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Odds',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ticket.totalOdds.toStringAsFixed(2),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      );
    }
  }

  IconData _getProductIcon() {
    switch (ticket.product.name) {
      case ProductName.SOCCER:
        return Icons.sports_soccer;
      case ProductName.BASKETBALL:
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
  }
}
