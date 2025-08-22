import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StakeDisplay extends StatelessWidget {
  final double stake;

  const StakeDisplay({super.key, required this.stake});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Stake: ${stake.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showStakeInfoModal(context),
          child: Icon(
            LucideIcons.info,
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
        ),
      ],
    );
  }

  void _showStakeInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D151E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🎯 Introducing STAKE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your Smartest Betting Strategy! 🎯',
                    style: TextStyle(
                      color: Color(0xFF00DEA2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // What is Stake section
              const Text(
                '❓ What is Stake ❓',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'In SMORE, Stake refers to the amount of money you invest in a particular bet based on your total betting budget. Instead of betting randomly, we recommend a strategic percentage of your bankroll to help you manage risk and maximize long-term success 📈',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // How Does Stake Work section
              const Text(
                'How Does Stake Work? ⚖️',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your total betting budget (bankroll) should be a fixed amount you\'re comfortable investing over time. SMORE suggests bets based on a percentage of that budget, which we call your Stake.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Examples section
              const Text(
                '🔍 Examples:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Example 1
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF15212E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💎 Example 1: Conservative Betting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• You have a bankroll of €1,000.\n• We recommend a ${stake.toStringAsFixed(0)}% Stake on a match.\n• You place €${(1000 * stake / 100).toStringAsFixed(0)} on the bet (${stake.toStringAsFixed(0)}% of €1,000).',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Example 2
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF15212E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💎 Example 2: Aggressive Betting 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Your bankroll is €5,000.\n• We suggest a ${stake.toStringAsFixed(0)}% Stake for a high-confidence bet.\n• You place €${(5000 * stake / 100).toStringAsFixed(0)} on that match.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Why Use Stake section
              const Text(
                '❓ Why Use Stake ❓',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '➡️ Risk Management – Protect your bankroll from sudden losses.\n➡️ Long-Term Success – Helps you stay disciplined instead of betting emotionally.\n➡️ Adaptability – As your bankroll grows, your Stakes adjust accordingly.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Conclusion
              const Text(
                '🎯 By following SMORE\'s Stake recommendations, you ensure a smart, structured approach to sports betting instead of gambling blindly 🏆',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
