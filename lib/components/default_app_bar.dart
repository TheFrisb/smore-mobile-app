import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  static final Logger logger = Logger();

  const DefaultAppBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0xFFFFFFFF), // #FFF
              Color(0xFFB7C9DB), // #b7c9db
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: const Text(
          "SMORE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Base text color (required for gradient)
          ),
        ),
      ),
      actions: [
        // add avatar icon on right with InkResponse
        InkResponse(
          onTap: () {
            logger.i("Avatar icon tapped, opening end drawer");
            Scaffold.of(context).openEndDrawer();
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              child: Icon(
                Icons.account_circle_outlined,
                size: 32,
                color: Color(0xFFB7C9DB),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48 + 1),
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
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0BA5EC).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48 + 1);
}
