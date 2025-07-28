import 'package:smore_mobile_app/models/product.dart';
import 'package:smore_mobile_app/models/sport/bet_line.dart';

enum TicketStatus { WON, LOST, PENDING }

class Ticket {
  final int id;
  final TicketStatus status;
  final Product product;
  final DateTime startsAt;
  final String label;
  final double totalOdds;
  final List<BetLine> betLines;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.status,
    required this.product,
    required this.startsAt,
    required this.label,
    required this.totalOdds,
    required this.betLines,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Ticket(id: $id, status: $status, product: $product, startsAt: $startsAt, label: $label, totalOdds: $totalOdds, betLines: $betLines, createdAt: $createdAt)';
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      status: TicketStatus.values
          .firstWhere((e) => e.toString() == 'TicketStatus.${json['status']}'),
      product: Product.fromJson(json['product']),
      startsAt: DateTime.parse(json['starts_at']),
      label: json['label'],
      totalOdds: (json['total_odds'] as num).toDouble(),
      betLines: (json['bet_lines'] as List)
          .map((betLine) => BetLine.fromJson(betLine))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
