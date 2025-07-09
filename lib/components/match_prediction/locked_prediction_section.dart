import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LockedPredictionSection extends StatelessWidget {
  static final Logger logger = Logger();
  final int predictionId;

  const LockedPredictionSection({super.key, required this.predictionId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Subscribe Button
        // Container(
        //   width: 200,
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF14202D).withOpacity(0.5),
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(
        //       color: const Color(0xFF1E3A5A).withOpacity(0.5),
        //     ),
        //   ),
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => const ManagePlanScreen(),
        //         ),
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             'Subscribe',
        //             style: TextStyle(
        //               color: Theme.of(context).primaryColor,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //           const SizedBox(width: 8),
        //           Icon(
        //             Icons.arrow_forward,
        //             color: Theme.of(context).primaryColor,
        //             size: 20,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 8),
        Text(
          'You can obtain prediction access from our website',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
        // const SizedBox(height: 16),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Divider(
        //         color: const Color(0xFF64748B).withOpacity(0.2),
        //         thickness: 1,
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       child: Text(
        //         'OR',
        //         style: TextStyle(
        //           color: Theme.of(context).primaryColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Divider(
        //         color: const Color(0xFF64748B).withOpacity(0.2),
        //         thickness: 1,
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 16),
        // // Unlock Button with Loading Spinner
        // Consumer<PurchaseProvider>(
        //   builder: (context, purchaseProvider, child) {
        //     if (purchaseProvider.isLoading) {
        //       return CircularProgressIndicator(
        //         valueColor: AlwaysStoppedAnimation<Color>(
        //           Theme.of(context).primaryColor,
        //         ),
        //       );
        //     }
        //     return Container(
        //       decoration: BoxDecoration(
        //         color: const Color(0xB50D151E),
        //         borderRadius: BorderRadius.circular(8),
        //         border: Border.all(
        //           color: Theme.of(context).primaryColor.withOpacity(0.5),
        //           width: 1,
        //         ),
        //       ),
        //       child: InkWell(
        //         onTap: () {
        //           purchaseProvider.buyPrediction(predictionId);
        //         },
        //         child: Container(
        //           width: 200,
        //           padding:
        //               const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        //           child: const Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 'Unlock',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //               SizedBox(width: 8),
        //               Icon(
        //                 Icons.lock_open,
        //                 color: Colors.white,
        //                 size: 20,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // const SizedBox(height: 8),
        // RichText(
        //   text: TextSpan(
        //     text: 'this prediction for ',
        //     style: TextStyle(
        //       color: AppColors.secondary.shade100,
        //       fontSize: 12,
        //     ),
        //     children: [
        //       TextSpan(
        //         text: '\$9.99',
        //         style: TextStyle(
        //           color: Theme.of(context).primaryColor,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
