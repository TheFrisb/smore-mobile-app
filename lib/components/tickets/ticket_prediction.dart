import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/bet_line.dart';
import 'package:smore_mobile_app/models/sport/ticket.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

class TicketPrediction extends StatelessWidget {
  static final Logger logger = Logger();
  final Ticket ticket;

  const TicketPrediction({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: _getBorderColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        shadowColor: _getShadowColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            _buildTicketLabel(context),
            const SizedBox(height: 24),
            _buildTopRow(context),
            const SizedBox(height: 24),
            const BrandGradientLine(),
            const SizedBox(height: 24),
            _buildBetLines(context),
          ]),
        ));
  }

  Widget _buildTopRow(BuildContext context) {
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
        // container with Total odds on top, and odds below
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

  Widget _buildTicketLabel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D151E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.diamond,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            ticket.label,
            style: TextStyle(
              color: const Color(0xFFdbe4ed),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetLines(BuildContext context) {
    return Column(
      children: ticket.betLines.asMap().entries.map((entry) {
        int index = entry.key;
        BetLine betLine = entry.value;
        bool hasConnectingLine = index < ticket.betLines.length - 1;
        bool isPending = betLine.status == BetLineStatus.PENDING;
        bool hasScores = !isPending &&
            (betLine.match.homeTeamScore != null &&
                    betLine.match.homeTeamScore.isNotEmpty ||
                betLine.match.awayTeamScore != null &&
                    betLine.match.awayTeamScore.isNotEmpty);
        return _buildBetLine(
            context,
            betLine.bet,
            betLine.betType,
            betLine.odds,
            betLine.status.toString().split('.').last,
            isPending,
            hasConnectingLine,
            hasScores,
            betLine);
      }).toList(),
    );
  }

  Widget _buildBetLine(
      BuildContext context,
      String bet,
      String betType,
      double odds,
      String status,
      bool isPending,
      bool hasConnectingLine,
      bool hasScores,
      BetLine betLine) {
    return Stack(
      children: [
        // Connecting line (only if not the last bet line)
        if (hasConnectingLine)
          Positioned(
            left: 15,
            top: 16,
            bottom: 16,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: _getConnectingLineColor(status),
              ),
            ),
          ),
        // Bet line content
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Icon with background
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getStatusColor(status),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Bet Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bet,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                betType,
                                style: const TextStyle(
                                  color: Color(0xFFdbe4ed),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            odds.toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isPending || hasScores) ...[
                      const SizedBox(height: 12),
                      _buildMatchDetails(
                          context, isPending, hasScores, betLine),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchDetails(
      BuildContext context, bool isPending, bool hasScores, BetLine betLine) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D151E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Home Team
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // <-- Fix: shrink-wrap children
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(_getProductIcon(), size: 12, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  // Fix: Remove Flexible, just use Text
                  Text(
                    betLine.match.homeTeam.name,
                    style: const TextStyle(
                      color: Color(0xFFdbe4ed),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (isPending)
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Text(
                      userProvider.formatDateTimeForDisplay(
                          betLine.match.kickoffDateTime),
                      style: const TextStyle(
                        color: Color(0xFFdbe4ed),
                        fontSize: 12,
                      ),
                    );
                  },
                )
              else if (betLine.match.homeTeamScore.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    betLine.match.homeTeamScore,
                    style: const TextStyle(
                      color: Color(0xFFdbe4ed),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Away Team
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // <-- Fix: shrink-wrap children
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(_getProductIcon(), size: 12, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  // Fix: Remove Flexible, just use Text
                  Text(
                    betLine.match.awayTeam.name,
                    style: const TextStyle(
                      color: Color(0xFFdbe4ed),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (isPending)
                Text(
                  betLine.match.league.name,
                  style: const TextStyle(
                    color: Color(0xFFdbe4ed),
                    fontSize: 12,
                  ),
                )
              else if (betLine.match.awayTeamScore.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    betLine.match.awayTeamScore,
                    style: const TextStyle(
                      color: Color(0xFFdbe4ed),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'WON':
        return Icons.check;
      case 'LOST':
        return Icons.close;
      case 'PENDING':
      default:
        return Icons.radio_button_unchecked;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'WON':
        return Colors.green;
      case 'LOST':
        return Colors.red;
      case 'PENDING':
      default:
        return const Color(0xFFdbe4ed);
    }
  }

  BorderSide _getBorderColor(BuildContext context) {
    Color borderColor;

    switch (ticket.status) {
      case TicketStatus.PENDING:
        borderColor = Theme.of(context).primaryColor.withOpacity(0.2);
        break;
      case TicketStatus.WON:
        borderColor = Colors.green.withOpacity(0.5);
        break;
      case TicketStatus.LOST:
        borderColor = Colors.red.withOpacity(0.5);
        break;
    }

    return BorderSide(
      color: borderColor,
      width: 1,
    );
  }

  Color? _getShadowColor(BuildContext context) {
    switch (ticket.status) {
      case TicketStatus.PENDING:
        return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
      case TicketStatus.WON:
        return Colors.green.withOpacity(0.1);
      case TicketStatus.LOST:
        return Colors.red.withOpacity(0.1);
    }
  }

  IconData _getProductIcon() {
    switch (ticket.product.name) {
      case ProductName.SOCCER:
        return Icons.sports_soccer;
      case ProductName.BASKETBALL:
        return Icons.sports_basketball;

      default:
        return LucideIcons.trophy;
    }
  }

  Color _getConnectingLineColor(String status) {
    switch (status) {
      case 'WON':
        return Colors.green.withOpacity(0.3);
      case 'LOST':
        return Colors.red.withOpacity(0.3);
      case 'PENDING':
      default:
        return const Color(0xFFdbe4ed).withOpacity(0.3);
    }
  }
}
