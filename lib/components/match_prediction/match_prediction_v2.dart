import 'package:flutter/material.dart';

import '../../screens/analysis_detail_screen.dart';

class MatchPredictionV2 extends StatelessWidget {
  const MatchPredictionV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            // rgba(16,185,129,.2)
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
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
                            borderRadius: BorderRadius.circular(8),
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
                            builder: (context) => const AnalysisDetailScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                    borderRadius: BorderRadius.circular(8),
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
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
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
                                  Image.network(
                                    'https://i.ibb.co/398wwWfm/bf58eb61dc1e97bc9968cba1bc036587.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Manchester United",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Image.network(
                                    'https://i.ibb.co/JFWF2v8s/da7ba366b7dbe06c4651bda15bad072c.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Barcelona",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF15222F),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0x802D4763), // rgba(45,71,99,.5)
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kick-off Date",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              "12/02/2025",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Add spacing between columns
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF15222F),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0x802D4763),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kick-off Time",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              "20:00",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // Explicit top alignment
                      children: [
                        const Text(
                          "Prediction",
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manchester United (To win either half)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )));
  }
}
