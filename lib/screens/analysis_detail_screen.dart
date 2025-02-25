import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../models/sport/prediction.dart';

class AnalysisDetailScreen extends StatelessWidget {
  final Prediction prediction;
  static final Logger logger = Logger();

  const AnalysisDetailScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
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

                  // decoration: const BoxDecoration(
                  //   gradient: RadialGradient(
                  //     center: Alignment.topLeft,
                  //     colors: [
                  //       Color(0xFF121D2D),
                  //       Color(0xFF04142A),
                  //     ],
                  //   ),
                  // ),
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
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: CachedNetworkImageProvider(
                                    prediction.match.homeTeam.logoUrl),
                                width: 64,
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
                              Text(
                                prediction.match.homeTeam.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(width: 8),
                          Center(
                              child: Column(
                            children: [
                              Image.network(
                                'https://i.ibb.co/20hL0F9P/vs.png',
                                height: 32,
                              )
                            ],
                          )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: CachedNetworkImageProvider(
                                        prediction.match.awayTeam.logoUrl),
                                    width: 64,
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
                                  Text(
                                    prediction.match.awayTeam.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 24),
                      // Text(
                      //   "Prediction",
                      //   style: TextStyle(
                      //     color: Colors.grey.shade400,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   "Monaco (To win either half)",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const BrandGradientLine(),
              ],
            ),
          ),
          // Analysis Content Section
          Expanded(
            child: Container(
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
                    Text(
                      prediction.detailedAnalysis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const BrandGradientLine(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF080D13),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prediction",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    // if match status won ro lost dispaly checkamrk or close icon

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          prediction.prediction,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: prediction.status == 'WON'
                                ? const Color(0xFF00DEA2)
                                : prediction.status == 'LOST'
                                    ? const Color(0xFFEF4444)
                                    : Theme.of(context).primaryColor,
                          ),
                        ),
                        if (prediction.status != 'PENDING')
                          const SizedBox(width: 8),
                        if (prediction.status != 'PENDING')
                          Icon(
                            prediction.status == 'WON'
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: prediction.status == 'WON'
                                ? const Color(0xFF00DEA2)
                                : const Color(0xFFEF4444),
                          ),
                      ],
                    )
                  ],
                ),
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
            ),
          ),
        ],
      ),
    );
  }
}
