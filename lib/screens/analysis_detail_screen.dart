import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

class AnalysisDetailScreen extends StatelessWidget {
  const AnalysisDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackButtonScreen(
      title: "Match analysis",
      padding: const EdgeInsets.all(0),
      backgroundColor: Color(0xFF0D151E),
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
                          Image.network(
                            'https://i.ibb.co/ycMKNM1j/5184cb92d206f0f477f1da8bdfeceda2.png',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "EUROPE: Champions League",
                            style: TextStyle(
                              color: Color(0xFF00DEA2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        textAlign: TextAlign.center,
                        "12/02/2025 20:00 (GMT +1)",
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
                              Image.network(
                                'https://i.ibb.co/398wwWfm/bf58eb61dc1e97bc9968cba1bc036587.png',
                                width: 64,
                                height: 64,
                              ),
                              const Text(
                                "Manchester United",
                                style: TextStyle(
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
                                  Image.network(
                                    'https://i.ibb.co/JFWF2v8s/da7ba366b7dbe06c4651bda15bad072c.png',
                                    width: 64,
                                    height: 64,
                                  ),
                                  const Text(
                                    "Barcelona",
                                    style: TextStyle(
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
                    const Text(
                      "In the upcoming El Clásico, Real Madrid's recent acquisition of Kylian Mbappé and Endrick has bolstered their attacking prowess, making them formidable opponents. However, Barcelona's midfield, featuring talents like Pedri, Gavi, Dani Olmo, and Frenkie de Jong, is considered one of the strongest in La Liga, providing them with a strategic advantage in controlling the game's tempo. While Real Madrid's offensive strength is undeniable, Barcelona's cohesive midfield play and recent form suggest they have the upper hand. Therefore, I predict a closely contested match with Barcelona emerging victorious.",
                      style: TextStyle(
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
                    Text(
                      "Monaco (To win either half)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
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
