import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TitleAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
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
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
