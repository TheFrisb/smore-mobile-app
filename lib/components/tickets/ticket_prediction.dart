import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/app_colors.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/match_prediction/stake_display.dart';
import 'package:smore_mobile_app/components/tickets/ticket_locked_section.dart';
import 'package:smore_mobile_app/models/sport/bet_line.dart';
import 'package:smore_mobile_app/models/sport/ticket.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

import '../../models/product.dart';
import '../../utils/string_utils.dart';

class TicketPrediction extends StatelessWidget {
  static final Logger logger = Logger();
  final Ticket ticket;

  const TicketPrediction({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final canViewTicket = userProvider.canViewTicket(ticket);

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
            const SizedBox(height: 16),
            // TicketHeader(ticket: ticket, canViewTicket: canViewTicket),
            // const SizedBox(height: 24),
            const BrandGradientLine(),
            const SizedBox(height: 24),
            if (canViewTicket)
              _buildBetLines(context)
            else
              TicketLockedSection(ticketId: ticket.id),
            if (canViewTicket) ...[
              const SizedBox(height: 12),
            ],
            if (canViewTicket &&
                ticket.status == TicketStatus.PENDING &&
                ticket.stake > 0) ...[
              const BrandGradientLine(),
              const SizedBox(height: 16),
              _buildStakeAndOdds(context),
            ],
            if (canViewTicket && ticket.status != TicketStatus.PENDING) ...[
              const BrandGradientLine(),
              const SizedBox(height: 16),
              _buildTotalOddsOnly(context),
            ],
          ]),
        ));
  }

  Widget _buildTicketLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              StringUtils.capitalize(ticket.product.name.displayName),
              style: const TextStyle(color: Color(0xFFdbe4ed)),
            ),
          ],
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

  Widget _buildBetLines(BuildContext context) {
    return Column(
      children: ticket.betLines.asMap().entries.map((entry) {
        int index = entry.key;
        BetLine betLine = entry.value;
        bool hasConnectingLine = index < ticket.betLines.length - 1;
        bool isPending = betLine.status == BetLineStatus.PENDING;
        bool hasScores = !isPending &&
            (betLine.match.homeTeamScore.isNotEmpty ||
                betLine.match.awayTeamScore.isNotEmpty);
        return _buildBetLine(
            context,
            betLine.bet,
            betLine.betType,
            betLine.odds,
            betLine.status,
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
      BetLineStatus status,
      bool isPending,
      bool hasConnectingLine,
      bool hasScores,
      BetLine betLine) {
    return Stack(
      children: [
        // Connecting line (only if not the last bet line)
        if (hasConnectingLine)
          Positioned(
            left: 11,
            top: 24,
            bottom: 0,
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
              // Status Icon
              _buildPulsingIcon(status, betLine.match.isLive),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (betLine.match.homeTeam.logoUrl != null)
                    CachedNetworkImage(
                      imageUrl: betLine.match.homeTeam.logoUrl!,
                      height: 16,
                      width: 16,
                      fit: BoxFit.contain,
                    )
                  else
                    Icon(
                      LucideIcons.shieldAlert,
                      size: 16,
                      color: Colors.grey,
                    ),
                  const SizedBox(width: 8),
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
                      _formatMatchTime(betLine.match.kickoffDateTime, userProvider),
                      style: const TextStyle(
                        color: Color(0xFFdbe4ed),
                        fontSize: 10,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (betLine.match.awayTeam.logoUrl != null)
                    CachedNetworkImage(
                      imageUrl: betLine.match.awayTeam.logoUrl!,
                      height: 16,
                      width: 16,
                      fit: BoxFit.contain,
                    )
                  else
                    Icon(
                      LucideIcons.shieldAlert,
                      size: 16,
                      color: Colors.grey,
                    ),
                  const SizedBox(width: 8),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (betLine.match.league.country.logoUrl != null)
                      CachedNetworkImage(
                        imageUrl: betLine.match.league.country.logoUrl!,
                        height: 12,
                        width: 12,
                        fit: BoxFit.contain,
                      )
                    else
                      Icon(
                        LucideIcons.shieldAlert,
                        size: 12,
                        color: Colors.grey,
                      ),
                    const SizedBox(width: 6),
                    Text(
                      betLine.match.league.name,
                      style: const TextStyle(
                        color: Color(0xFFdbe4ed),
                        fontSize: 10,
                      ),
                    ),
                  ],
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

  Widget _buildStakeAndOdds(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stake on the left
          Expanded(
            child: Center(
              child: StakeDisplay(
                stake: ticket.stake,
                fontSize: 14,
                displayIcon: false,
              ),
            ),
          ),
          const SizedBox(width: 114),
          // Total odds on the right
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Total Odds:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFdbe4ed),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTotalOddsOnly(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Total Odds",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFdbe4ed),
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
    );
  }

  IconData _getStatusIcon(BetLineStatus status, bool isLive) {
    switch (status) {
      case BetLineStatus.WON:
        return LucideIcons.circleCheck;
      case BetLineStatus.LOST:
        return LucideIcons.circleX;
      case BetLineStatus.PENDING:
        return isLive ? LucideIcons.circleDot : LucideIcons.circle;
    }
  }

  Color _getStatusColor(BetLineStatus status) {
    switch (status) {
      case BetLineStatus.WON:
        return Colors.green;
      case BetLineStatus.LOST:
        return Colors.red;
      case BetLineStatus.PENDING:
        return AppColors.secondary;
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

  Color _getConnectingLineColor(BetLineStatus status) {
    switch (status) {
      case BetLineStatus.WON:
        return Colors.green.withOpacity(0.3);
      case BetLineStatus.LOST:
        return Colors.red.withOpacity(0.3);
      case BetLineStatus.PENDING:
        return AppColors.secondary.shade400.withOpacity(0.3);
    }
  }

  String _formatMatchTime(DateTime utcDateTime, UserProvider userProvider) {
    final localDateTime = userProvider.convertToUserTimezone(utcDateTime);
    
    // Get month abbreviations
    const monthAbbreviations = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final month = monthAbbreviations[localDateTime.month - 1];
    final day = localDateTime.day.toString().padLeft(2, '0');
    final hour = localDateTime.hour.toString().padLeft(2, '0');
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    
    return '$month $day, $hour:$minute';
  }

  Widget _buildPulsingIcon(BetLineStatus status, bool isLive) {
    final isLivePending = status == BetLineStatus.PENDING && isLive;

    if (!isLivePending) {
      // Return static icon for non-live pending, won, or lost status
      return Icon(
        _getStatusIcon(status, isLive),
        color: _getStatusColor(status),
        size: 24,
      );
    }

    // Return pulsing icon for live pending matches
    return _PulsingIcon(
      icon: _getStatusIcon(status, isLive),
      color: _getStatusColor(status),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _PulsingIcon({
    required this.icon,
    required this.color,
  });

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: 24,
          ),
        );
      },
    );
  }
}
