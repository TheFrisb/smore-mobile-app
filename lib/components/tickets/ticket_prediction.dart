import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

class TicketPrediction extends StatelessWidget {
  static final Logger logger = Logger();

  const TicketPrediction({super.key});

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
            _buildTopRow(context),
            const SizedBox(height: 24),
            const BrandGradientLine(),
            const SizedBox(height: 24),
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
              'Soccer',
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
              '2.5',
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

  BorderSide _getBorderColor(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor.withOpacity(0.2);

    // switch (prediction.status) {
    //   case PredictionStatus.PENDING:
    //     borderColor = Theme.of(context).primaryColor.withOpacity(0.2);
    //     break;
    //   case PredictionStatus.WON:
    //     borderColor = const Color(0xB500DEA2).withOpacity(0.5);
    //     break;
    //   case PredictionStatus.LOST:
    //     borderColor = const Color(0xFFEF4444).withOpacity(0.5);
    //     break;
    //   default:
    //     borderColor = Theme.of(context).primaryColor.withOpacity(0.2);
    // }

    return BorderSide(
      color: borderColor,
      width: 1,
    );
  }

  Color? _getShadowColor(BuildContext context) {
    // switch (prediction.status) {
    //   case PredictionStatus.PENDING:
    //     return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
    //   case PredictionStatus.WON:
    //     return Theme.of(context).drawerTheme.backgroundColor;
    //   case PredictionStatus.LOST:
    //     return const Color(0xFFEF4444).withOpacity(0.1);
    //   default:
    //     return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
    // }

    return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
  }

  IconData _getProductIcon() {
    // switch (prediction.match.type) {
    //   case SportType.SOCCER:
    //     return Icons.sports_soccer;
    //   case SportType.BASKETBALL:
    //     return Icons.sports_basketball;
    //   case SportType.TENNIS:
    //     return Icons.sports_tennis;
    //   case SportType.NFL:
    //     return Icons.sports_football;
    //   case SportType.NHL:
    //     return Icons.sports_hockey;
    //   default:
    //     return Icons.sports;
    // }

    return Icons.sports;
  }
}
