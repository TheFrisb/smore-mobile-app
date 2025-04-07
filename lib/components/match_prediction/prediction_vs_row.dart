import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smore_mobile_app/models/sport/prediction.dart';

import '../../app_colors.dart';
import '../../constants/constants.dart';

class PredictionVsRow extends StatelessWidget {
  final Prediction prediction;
  final double vsImageHeight;
  final double teamFontSize;
  final double teamLogoHeight;

  const PredictionVsRow({
    super.key,
    required this.prediction,
    this.vsImageHeight = 32,
    this.teamFontSize = 12,
    this.teamLogoHeight = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: prediction.match.homeTeam.logoUrl,
                  height: teamLogoHeight,
                ),
                const SizedBox(height: 8),
                Text(
                  prediction.match.homeTeam.name,
                  style: TextStyle(
                    color: AppColors.secondary.shade100,
                    fontSize: teamFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          _buildVersusRow(context),
          Expanded(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: prediction.match.awayTeam.logoUrl,
                  height: teamLogoHeight,
                ),
                const SizedBox(height: 8),
                Text(
                  prediction.match.awayTeam.name,
                  style: TextStyle(
                    color: AppColors.secondary.shade100,
                    fontSize: teamFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
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
              height: vsImageHeight,
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
              height: vsImageHeight,
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
}
