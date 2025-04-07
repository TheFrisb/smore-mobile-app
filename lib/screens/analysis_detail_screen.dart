import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/match_prediction/prediction_text.dart';
import 'package:smore_mobile_app/components/match_prediction/prediction_vs_row.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../app_colors.dart';
import '../models/sport/prediction.dart';
import '../providers/user_provider.dart';

class AnalysisDetailScreen extends StatelessWidget {
  final Prediction prediction;
  static final Logger logger = Logger();

  const AnalysisDetailScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return BaseBackButtonScreen(
      title: "Match analysis",
      padding: const EdgeInsets.all(0),
      backgroundColor: const Color(0xFF0D151E),
      body: Column(
        children: [
          // Header Section
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF080D13),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkSVGImage(
                            prediction.match.league.country.logoUrl,
                            width: 16,
                            fadeDuration: const Duration(milliseconds: 0),
                            placeholder: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                            errorWidget: const Icon(Icons.error),
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            prediction.match.league.name,
                            style: const TextStyle(
                              color: Color(0xFF00DEA2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        textAlign: TextAlign.center,
                        prediction.match.kickoffDateTime
                            .toLocal()
                            .toString()
                            .substring(0, 16),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PredictionVsRow(
                        prediction: prediction,
                        teamFontSize: 14,
                        teamLogoHeight: 64,
                        vsImageHeight: 32,
                      ),
                    ],
                  ),
                ),
                const BrandGradientLine(),
              ],
            ),
          ),
          // Analysis Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Match Analysis",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const BrandGradientLine(),
                  const SizedBox(height: 16),
                  if (userProvider.canViewPrediction(prediction))
                    Html(data: prediction.detailedAnalysis)
                  else
                    _buildPredictionLocked(context),

                  // Text(
                  //   prediction.detailedAnalysis,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 14,
                  //     height: 1.5,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          const BrandGradientLine(),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF080D13),
              ),
              child: _buildBottomBar(
                  context, userProvider.canViewPrediction(prediction))),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool canViewPrediction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // start
          children: [
            if (canViewPrediction)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prediction",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary.shade400,
                      )),
                  PredictionText(
                      predictionText: prediction.prediction,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      textAlign: TextAlign.left),
                ],
              )
            else
              const Row(
                children: [
                  Icon(
                    Icons.lock_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Prediction locked",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
          ],
        ),
        if (canViewPrediction)
          const Row(
            children: [
              Icon(
                Icons.arrow_drop_up,
                color: Color(0xFF00DEA2),
              ),
              Text(
                "Odds",
              ),
              // add spacing between text and icon
              SizedBox(width: 4),
              Text(
                "1.66",
                style: TextStyle(
                  color: Color(0xFF00DEA2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPredictionLocked(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.lock_outlined,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Premium Prediction",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const BrandGradientLine(),
            const SizedBox(
              height: 16,
            ),
            Text(
              textAlign: TextAlign.center,
              "Subscribe to access our expert predictions for upcoming matches, featuring detailed analysis and insights.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade200),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Daily Expert Predictions",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "92%+ Success Rate",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "High odds",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildPredictionLockedSection(context)
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionLockedSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Subscribe Button
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF14202D).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF1E3A5A).withOpacity(0.5),
            ),
          ),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Subscribe',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Access text
        Text(
          'to access all predictions',
          style: TextStyle(
            color: AppColors.secondary.shade100,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        // OR Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0xFF64748B).withOpacity(0.2),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: const Color(0xFF64748B).withOpacity(0.2),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Unlock Button
        Container(
          decoration: BoxDecoration(
            color: const Color(0xB50D151E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {},
            child: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unlock',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.lock_open,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Price text
        RichText(
          text: TextSpan(
            text: 'this prediction for ',
            style: TextStyle(
              color: AppColors.secondary.shade100,
              fontSize: 12,
            ),
            children: [
              TextSpan(
                text: '\$9.99',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
