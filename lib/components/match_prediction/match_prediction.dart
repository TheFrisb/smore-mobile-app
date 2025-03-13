import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../models/sport/prediction.dart';
import '../../screens/analysis_detail_screen.dart';
import '../decoration/brand_gradient_line.dart';

class MatchPrediction extends StatelessWidget {
  final Prediction prediction;
  static final Logger logger = Logger();

  const MatchPrediction({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            // rgba(16,185,129,.2)
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        shadowColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side group
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xB50D151E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(Icons.sports_soccer),
                        ),
                        const SizedBox(width: 10),
                        const Text('Soccer',
                            style: TextStyle(
                              color: Color(0xFFdbe4ed),
                            )),
                      ],
                    ),
                    // Right side button
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
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Text("Match",
                        style: TextStyle(
                          color: Color(0xFFdbe4ed),
                        )),
                    Spacer(),
                    Row(
                      children: [],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D151E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0x802D4763), // rgba(45,71,99,.5)
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
                              color: Color(0xB500DEA2),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      const BrandGradientLine(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left team aligned to start
                              Row(
                                children: [
                                  Image(
                                    image: CachedNetworkImageProvider(
                                        prediction.match.homeTeam.logoUrl),
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      logger.e(error);
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    prediction.match.homeTeam.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Image(
                                    image: CachedNetworkImageProvider(
                                        prediction.match.awayTeam.logoUrl),
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      logger.e(error);
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    prediction.match.awayTeam.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_drop_up,
                                color: Color(0xFF00DEA2),
                              ),
                              const Text(
                                "Odds",
                              ),
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
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Date: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: prediction.match.kickoffDateTime
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Explicit top alignment
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock_outlined,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.center,
                      "Prediction locked",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const BrandGradientLine(),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Subscribe to access our expert predictions",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade200),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // Add navigation to subscription plans screen
                        Navigator.pushNamed(context, '/subscription-plans');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("View Plans"),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            )));
  }
}
