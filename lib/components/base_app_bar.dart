import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/components/decoration/brand_logo.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final Logger logger = Logger();

  const BaseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const SafeArea(child: BrandLogo()),
      actions: [
        InkResponse(
          onTap: () {
            logger.i("Avatar icon tapped, opening end drawer");
            Scaffold.of(context).openEndDrawer();
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xB50D151E),
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
  Size get preferredSize => const Size.fromHeight(54 + 1);
}
