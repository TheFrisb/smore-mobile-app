import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app_colors.dart';

class StakeDisplay extends StatelessWidget {
  final double stake;
  final double fontSize;
  final bool displayIcon;

  const StakeDisplay({
    super.key,
    required this.stake,
    this.fontSize = 16,
    this.displayIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final stakeText = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Stake: ',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '${stake.toStringAsFixed(0)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );

    if (!displayIcon) {
      return GestureDetector(
        onTap: () => _showStakeInfoModal(context),
        child: stakeText,
      );
    }

    return GestureDetector(
      onTap: () => _showStakeInfoModal(context),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        stakeText,
        const SizedBox(width: 6),
        Icon(
          LucideIcons.info,
          color: AppColors.secondary.shade400,
          size: fontSize,
        ),
      ]),
    );
  }

  void _showStakeInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: const Color(0xFF0D151E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced handle bar
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Enhanced Title with gradient background
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         AppColors.secondary.shade400.withOpacity(0.1),
                //         AppColors.secondary.shade400.withOpacity(0.05),
                //       ],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     borderRadius: BorderRadius.circular(16),
                //     border: Border.all(
                //       color: AppColors.secondary.shade400.withOpacity(0.2),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Container(
                //         padding: const EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //           color: AppColors.secondary.shade400.withOpacity(0.2),
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Icon(
                //           LucideIcons.trophy,
                //           color: AppColors.secondary.shade400,
                //           size: 28,
                //         ),
                //       ),
                //       const SizedBox(height: 16),
                //       const Text(
                //         'Introducing STAKE',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 24,
                //           fontWeight: FontWeight.bold,
                //           letterSpacing: 1.2,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //       const SizedBox(height: 8),
                //       const Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             'Your Smartest Betting Strategy!',
                //             style: TextStyle(
                //               color: Color(0xFF00DEA2),
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600,
                //               letterSpacing: 0.5,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //           SizedBox(width: 8),
                //           Icon(
                //             LucideIcons.target,
                //             color: Color(0xFF00DEA2),
                //             size: 20,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 32),

                // What is Stake section
                _buildSectionHeader(
                  icon: LucideIcons.info,
                  title: 'What is Stake',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15212E).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.shade400.withOpacity(0.1),
                    ),
                  ),
                  child: const Text(
                    'In SMORE, Stake refers to the amount of money you invest in a particular bet based on your total betting budget. Instead of betting randomly, we recommend a strategic percentage of your bankroll to help you manage risk and maximize long-term success.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // How Does Stake Work section
                _buildSectionHeader(
                  icon: LucideIcons.scale,
                  title: 'How Does Stake Work?',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15212E).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.shade400.withOpacity(0.1),
                    ),
                  ),
                  child: const Text(
                    'Your total betting budget (bankroll) should be a fixed amount you\'re comfortable investing over time. SMORE suggests bets based on a percentage of that budget, which we call your Stake.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Examples section
                _buildSectionHeader(
                  icon: LucideIcons.search,
                  title: 'Examples',
                ),
                const SizedBox(height: 16),

                // Example 1
                _buildExampleCard(
                  context: context,
                  title: '💎 Conservative Betting',
                  description:
                      '• You have a bankroll of €1,000.\n• We recommend a ${stake.toStringAsFixed(0)}% Stake on a prediction.\n• You place €${(1000 * stake / 100).toStringAsFixed(0)} on the bet (${stake.toStringAsFixed(0)}% of €1,000).',
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.shade400.withOpacity(0.1),
                      AppColors.secondary.shade400.withOpacity(0.05),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Example 2
                _buildExampleCard(
                  context: context,
                  title: '🚀 Aggressive Betting',
                  description:
                      '• Your bankroll is €5,000.\n• We suggest a ${stake.toStringAsFixed(0)}% Stake for a high-confidence bet.\n• You place €${(5000 * stake / 100).toStringAsFixed(0)} on that prediction.',
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00DEA2).withOpacity(0.1),
                      const Color(0xFF00DEA2).withOpacity(0.05),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.secondary.shade400.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.shade400.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary.shade400,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildExampleCard({
    required BuildContext context,
    required String title,
    required String description,
    required Gradient gradient,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.shade400.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
                letterSpacing: 0.3,
              ),
              children: _parseDescriptionWithColors(description),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseDescriptionWithColors(String description) {
    List<TextSpan> spans = [];
    RegExp regex = RegExp(r'(\d+(?:,\d+)*%|\€\d+(?:,\d+)*)');
    int lastIndex = 0;

    for (Match match in regex.allMatches(description)) {
      // Add text before the match
      if (match.start > lastIndex) {
        spans
            .add(TextSpan(text: description.substring(lastIndex, match.start)));
      }

      // Add colored text
      String matchedText = match.group(0)!;
      Color color = matchedText.contains('%')
          ? AppColors.secondary.shade400
          : const Color(0xFF00DEA2);

      spans.add(TextSpan(
        text: matchedText,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < description.length) {
      spans.add(TextSpan(text: description.substring(lastIndex)));
    }

    return spans;
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15212E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.shade400.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.shade400.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary.shade400,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
