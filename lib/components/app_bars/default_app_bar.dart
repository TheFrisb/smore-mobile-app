import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/components/decoration/brand_logo.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/wrappers/authenticated_user_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final Logger logger = Logger();
  final bool showGradient;

  const DefaultAppBar({super.key, this.showGradient = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // Reset filters to ALL
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setSelectedProductName(null); // ALL sport types
          userProvider.setPredictionObjectFilter(null); // ALL object types
          
          // Navigate to the authenticated user screen (which shows home screen at index 0)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AuthenticatedUserScreen(),
            ),
            (route) => false,
          );
        },
        child: const BrandLogo(),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(FontAwesomeIcons.telegram,
            size: 32, color: Color(0xFFB7C9DB)),
        onPressed: () async {
          Uri url = Uri.parse("https://t.me/smoreinfo");
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            logger.e("Failed to launch Telegram URL");
          }
        },
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
              backgroundColor: Color(0xB50D151E),
              child: Icon(
                LucideIcons.user,
                size: 24,
                color: Color(0xFFB7C9DB),
              ),
            ),
          ),
        ),
      ],
      // if showGradient is true, add BrandGradientLine
      bottom: showGradient
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1.0), child: BrandGradientLine())
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
