import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';

class SportTabBar extends StatelessWidget {
  final TabController tabController;

  const SportTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xff0B1F31),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.sports_soccer),
                  text: "Soccer",
                ),
                Tab(
                  icon: Icon(Icons.sports_basketball),
                  text: "Basketball",
                ),
                Tab(
                  icon: Icon(Icons.sports_football),
                  text: "Football",
                ),
              ],
              dividerColor: Colors.transparent,
            ),
            const BrandGradientLine()
          ],
        ));
  }
}
