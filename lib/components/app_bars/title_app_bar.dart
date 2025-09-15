import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smore_mobile_app/screens/contact_us_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showContactActions;

  const TitleAppBar({
    super.key,
    required this.title,
    this.showContactActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        centerTitle: true,
        leadingWidth: showContactActions ? 88 : null,
        leading: showContactActions
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkResponse(
                      onTap: () async {
                        final Uri url = Uri.parse('https://t.me/smoreinfo');
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      },
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xB50D151E),
                          child: _TelegramIcon(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        actions: showContactActions
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ContactUsScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xB50D151E),
                      child: Icon(
                        LucideIcons.messageSquare,
                        size: 20,
                        color: Color(0xFFB7C9DB),
                      ),
                    ),
                  ),
                )
              ]
            : null,
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

class _TelegramIcon extends StatelessWidget {
  const _TelegramIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/telegram.svg',
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(
        Color(0xFFB7C9DB),
        BlendMode.srcIn,
      ),
    );
  }
}
