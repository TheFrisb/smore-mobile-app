import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/app_colors.dart';
import 'package:smore_mobile_app/components/match_prediction/locked_prediction_section.dart';
import 'package:smore_mobile_app/components/match_prediction/prediction_text.dart';
import 'package:smore_mobile_app/components/match_prediction/prediction_vs_row.dart';
import 'package:smore_mobile_app/models/sport/sport_type.dart';
import 'package:smore_mobile_app/utils/string_utils.dart';

import '../../constants/constants.dart';
import '../../models/sport/prediction.dart';
import '../../providers/user_provider.dart'; // Adjust import based on your structure
import '../../screens/analysis_detail_screen.dart';
import '../decoration/brand_gradient_line.dart';

class MatchPrediction extends StatelessWidget {
  final Prediction prediction;
  static final Logger logger = Logger();

  MatchPrediction({super.key, required this.prediction});

  bool hasPurchased = false;

  @override
  Widget build(BuildContext context) {
    // Access providers
    final userProvider = Provider.of<UserProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: _getBorderColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      shadowColor: _getShadowColor(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTopRow(context),
            const SizedBox(height: 24),
            _buildSecondaryRow(
                context, userProvider.canViewPrediction(prediction)),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D151E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0x802D4763),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkSVGImage(
                        prediction.match.league.country.logoUrl,
                        height: 16,
                        fadeDuration: const Duration(milliseconds: 50),
                        placeholder:
                            const CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: const Icon(LucideIcons.shieldAlert),
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        prediction.match.league.name,
                        style: const TextStyle(
                          color: Color(0xB500DEA2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const BrandGradientLine(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          final userProvider =
                              Provider.of<UserProvider>(context);
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Date, Time: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: userProvider
                                      .formatDateTimeForDetailedDisplay(
                                          prediction.match.kickoffDateTime),
                                  style: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PredictionVsRow(prediction: prediction),
                  if (userProvider.canViewPrediction(prediction)) _buildOdds()
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (userProvider.canViewPrediction(prediction))
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Prediction",
                    style: TextStyle(
                      color: AppColors.secondary.shade100,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PredictionText(
                      predictionText: prediction.prediction,
                      fontSize: 16,
                      color: _getPredictionColor(context),
                      textAlign: TextAlign.center),
                  // Text(
                  //   prediction.prediction,
                  //   style: TextStyle(
                  //     color: _getPredictionColor(context),
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              )
            else
              LockedPredictionSection(predictionId: prediction.id)
          ],
        ),
      ),
    );
  }

  Widget _buildVersusRow(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prediction.status == PredictionStatus.PENDING)
            CachedNetworkImage(
              imageUrl: "${Constants.staticFilesBaseUrl}/assets/images/vs.png",
              height: 32,
            )
          else ...[
            Text(
              prediction.match.homeTeamScore,
              style: TextStyle(
                color: AppColors.secondary.shade100,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 16),
            CachedNetworkImage(
              imageUrl: "${Constants.staticFilesBaseUrl}/assets/images/vs.png",
              height: 32,
            ),
            const SizedBox(width: 16),
            Text(
              prediction.match.awayTeamScore,
              style: TextStyle(
                color: AppColors.primary.shade100,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOdds() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const BrandGradientLine(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.chevronUp,
              color: Color(0xFF00DEA2),
            ),
            const Text("Odds"),
            const SizedBox(width: 4),
            Text(
              prediction.odds.toString(),
              style: const TextStyle(
                color: Color(0xFF00DEA2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  bool showDetailedAnalysis() {
    return prediction.status == PredictionStatus.PENDING &&
        prediction.hasDetailedAnalysis == true;
  }

  Color? _getShadowColor(BuildContext context) {
    switch (prediction.status) {
      case PredictionStatus.PENDING:
        return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
      case PredictionStatus.WON:
        return Theme.of(context).drawerTheme.backgroundColor;
      case PredictionStatus.LOST:
        return const Color(0xFFEF4444).withOpacity(0.1);
      default:
        return Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5);
    }
  }

  Widget _buildSecondaryRow(BuildContext context, bool canViewPrediction) {
    if (canViewPrediction && prediction.status == PredictionStatus.PENDING) {
      return const SizedBox.shrink();
    }

    if (!canViewPrediction) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.lock,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            "Prediction locked",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    Color color = _getPredictionColor(context) ?? Colors.white;
    Icon icon = Icon(
      prediction.status == PredictionStatus.WON
          ? LucideIcons.circleCheck
          : LucideIcons.circleX,
      color: color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          prediction.status.name,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        icon,
      ],
    );
  }

  Color _getPredictionColor(BuildContext context) {
    switch (prediction.status) {
      case PredictionStatus.PENDING:
        return Theme.of(context).primaryColor;
      case PredictionStatus.WON:
        return const Color(0xFF00DEA2);
      case PredictionStatus.LOST:
        return const Color(0xFFEF4444);
      default:
        return Theme.of(context).primaryColor;
    }
  }

  BorderSide _getBorderColor(BuildContext context) {
    Color borderColor;

    switch (prediction.status) {
      case PredictionStatus.PENDING:
        borderColor = Theme.of(context).primaryColor.withOpacity(0.2);
        break;
      case PredictionStatus.WON:
        borderColor = const Color(0xB500DEA2).withOpacity(0.5);
        break;
      case PredictionStatus.LOST:
        borderColor = const Color(0xFFEF4444).withOpacity(0.5);
        break;
      default:
        borderColor = Theme.of(context).primaryColor.withOpacity(0.2);
    }

    return BorderSide(
      color: borderColor,
      width: 1,
    );
  }

  Widget _buildTopRow(BuildContext context) {
    if (showDetailedAnalysis()) {
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
                StringUtils.capitalize(prediction.match.type.name),
                style: const TextStyle(color: Color(0xFFdbe4ed)),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalysisDetailScreen(
                    prediction: prediction,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text("View analysis"),
          ),
        ],
      );
    } else {
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
                StringUtils.capitalize(prediction.match.type.name),
                style: const TextStyle(color: Color(0xFFdbe4ed)),
              ),
            ],
          ),
        ],
      );
    }
  }

  IconData _getProductIcon() {
    switch (prediction.match.type) {
      case SportType.SOCCER:
        return Icons.sports_soccer;
      case SportType.BASKETBALL:
        return Icons.sports_basketball;
      case SportType.TENNIS:
        return Icons.sports_tennis;
      case SportType.NFL:
        return Icons.sports_football;
      case SportType.NHL:
        return Icons.sports_hockey;
      default:
        return LucideIcons.trophy;
    }
  }
}
