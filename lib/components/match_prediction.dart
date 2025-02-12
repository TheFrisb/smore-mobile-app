import 'package:flutter/material.dart';

class MatchPrediction extends StatelessWidget {
  const MatchPrediction({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Text("Match",
                        style: TextStyle(
                          color: Color(0xFFdbe4ed),
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D151E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "EUROPE: Champions League",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Monaco",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A384E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "vs",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Manchester City",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Prediction", textAlign: TextAlign.left),
                          Text("Monaco (To win either half)",
                              textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Odds",
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "1.66",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
