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
                    // Text(
                    //   prediction.detailedAnalysis,
                    //   style: const TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 14,
                    //     height: 1.5,
                    //   ),
                    // ),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
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
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade200),
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
                                Text(
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
                                Text(
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
                                Text(
                                  "High odds",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextButton(
                              onPressed: () {
                                // Add navigation to subscription plans screen
                                Navigator.pushNamed(
                                    context, '/subscription-plans');
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("View Plans"),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios, size: 14),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(
                                        0x802D4763), // Use existing border color
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(
                                        0x802D4763), // Match left side
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Purchase just this prediction for ",
                                  ),
                                  TextSpan(
                                    text: "\$9.99",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                  width: 1,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color(0xFF14202D),
                              ),
                              child: const Stack(
                                children: [
                                  // Center the text in the button
                                  Center(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Purchase prediction',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.check_circle,
                                          size: 20,
                                          color: const Color(0xFF00DEA2)),
                                    ],
                                  )),
                                  // Align the image to the left, vertically centered
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // start
                  children: [
                    const Icon(
                      Icons.lock_outlined,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Prediction locked",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       prediction.prediction,
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         color: prediction.status == 'WON'
                    //             ? const Color(0xFF00DEA2)
                    //             : prediction.status == 'LOST'
                    //                 ? const Color(0xFFEF4444)
                    //                 : Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //     if (prediction.status != 'PENDING')
                    //       const SizedBox(width: 8),
                    //     if (prediction.status != 'PENDING')
                    //       Icon(
                    //         prediction.status == 'WON'
                    //             ? Icons.check_circle
                    //             : Icons.cancel,
                    //         color: prediction.status == 'WON'
                    //             ? const Color(0xFF00DEA2)
                    //             : const Color(0xFFEF4444),
                    //       ),
                    //   ],
                    // )
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
