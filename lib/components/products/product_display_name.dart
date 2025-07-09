import 'package:flutter/material.dart';
import 'package:smore_mobile_app/models/product.dart';

class ProductDisplayName extends StatelessWidget {
  final Product product;
  final double titleFontSize;
  final double iconSize;

  const ProductDisplayName({
    super.key,
    required this.product,
    this.titleFontSize = 16,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (product.name == ProductName.NFL_NHL) {
      return _buildNFLNHLNCAA(context);
    }

    return _buildSimpleProduct(context);
  }

  Widget _buildNFLNHLNCAA(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.sports_football_outlined,
        size: iconSize,
        color: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 4),
      Text(
        "NFL,   ",
        style: TextStyle(
          fontSize: titleFontSize,
          color: Colors.white,
        ),
      ),
      Icon(
        Icons.sports_hockey_outlined,
        size: iconSize,
        color: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 4),
      Text(
        "NHL,   ",
        style: TextStyle(
          fontSize: titleFontSize,
          color: Colors.white,
        ),
      ),
      Icon(
        Icons.sports_basketball_outlined,
        size: iconSize,
        color: Theme.of(context).primaryColor,
      ),
      const SizedBox(width: 4),
      Text(
        "NCAA,   ",
        style: TextStyle(
          fontSize: titleFontSize,
          color: Colors.white,
        ),
      ),
    ]);
  }

  Widget _buildSimpleProduct(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getSimpleProductIcon(),
          size: iconSize,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          product.displayName,
          style: TextStyle(
            fontSize: titleFontSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  IconData _getSimpleProductIcon() {
    switch (product.name) {
      case ProductName.SOCCER:
        return Icons.sports_soccer_outlined;
      case ProductName.BASKETBALL:
        return Icons.sports_basketball_outlined;
      case ProductName.TENNIS:
        return Icons.sports_tennis_outlined;
      case ProductName.AI_ANALYST:
        return Icons.sports_football_outlined;
      default:
        return Icons.sports_outlined;
    }
  }
}
