import 'package:flutter/material.dart';
import 'package:smore_mobile_app/app_colors.dart';
import 'package:smore_mobile_app/models/faq_item.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

import '../service/faq_service.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late final Future<List<FrequentlyAskedQuestion>> _faqFuture;

  @override
  void initState() {
    super.initState();
    _faqFuture = FaqService().getFaqItems();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackButtonScreen(
      title: "FAQ",
      body: FutureBuilder<List<FrequentlyAskedQuestion>>(
        future: _faqFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load FAQs.\nPlease check your internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 16,
                ),
              ),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No FAQs available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Data loaded state
          final faqItems = snapshot.data!;
          return ListView.builder(
            itemCount: faqItems.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FaqItem(frequentlyAskedQuestion: faqItems[index]),
            ),
          );
        },
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final FrequentlyAskedQuestion frequentlyAskedQuestion;

  const FaqItem({
    super.key,
    required this.frequentlyAskedQuestion,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D151E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.frequentlyAskedQuestion.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: _isExpanded ? 16 : 0,
                top: _isExpanded ? 16 : 0,
              ),
              child: Column(
                children: [
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                        widget.frequentlyAskedQuestion.answer,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                          height: 1.4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
