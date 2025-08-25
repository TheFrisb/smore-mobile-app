import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/screens/notifications_screen.dart';
import 'package:smore_mobile_app/screens/wrappers/authenticated_user_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LogoAppBar extends StatefulWidget implements PreferredSizeWidget {
  static final Logger logger = Logger();
  final bool showGradient;
  final int? currentScreenIndex;
  final Function(int)? onNavigateToIndex;

  const LogoAppBar({
    super.key,
    this.showGradient = false,
    this.currentScreenIndex,
    this.onNavigateToIndex,
  });

  @override
  State<LogoAppBar> createState() => _LogoAppBarState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(60 + 1.0); // Updated to match toolbarHeight
}

class _LogoAppBarState extends State<LogoAppBar>
    with SingleTickerProviderStateMixin {
  static final Logger logger = Logger();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleLogoTap(BuildContext context) {
    logger.i("Logo tapped");
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // If we're already on the predictions screen (index 0), just shake the logo
    if (widget.currentScreenIndex == 0) {
      logger.i("Already on predictions screen, shaking logo");
      _shakeController.forward().then((_) {
        _shakeController.reverse();
        logger.d("Shake animation completed");
      });
      HapticFeedback.mediumImpact();
      logger.d("Haptic feedback triggered");
      return;
    }

    logger.i("Navigating to predictions screen");
    logger.d(
        "Current screen index: ${widget.currentScreenIndex}, Filters - Product: ${userProvider.selectedProductName}, Filter: ${userProvider.predictionObjectFilter}");

    userProvider.setSelectedProductName(null); // ALL sport types
    userProvider.setPredictionObjectFilter(null); // ALL object types
    logger.d("Filters reset to default");

    // Use the navigation callback if available, otherwise fall back to old navigation
    if (widget.onNavigateToIndex != null) {
      logger.i("Using navigation callback to navigate to index 0");
      widget.onNavigateToIndex!(0);
    } else {
      logger.i("No navigation callback available, using old navigation method");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const AuthenticatedUserScreen(),
        ),
        (route) => false,
      );
    }
    logger.i("Navigation to predictions screen completed");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 60,
      title: GestureDetector(
        onTap: () {
          _handleLogoTap(context);
        },
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                _shakeAnimation.value * 10 * (_shakeAnimation.value - 0.5) * 2,
                -4,
              ),
              child: Image.asset(
                'assets/brand/logo.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
      centerTitle: true,
      leading: Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: const Icon(FontAwesomeIcons.telegram,
              size: 32, color: Color(0xFFB7C9DB)),
          onPressed: () async {
            logger.i("Telegram icon tapped");
            Uri url = Uri.parse("https://t.me/smoreinfo");
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              logger.e("Failed to launch Telegram URL");
            } else {
              logger.d("Telegram URL launched successfully");
            }
          },
        ),
      ),
      actions: [
        // Bell icon for notifications with count badge
        Container(
          alignment: Alignment.center,
          child: InkResponse(
            onTap: () {
              logger.i("Bell icon tapped, navigating to notifications");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
              logger.d("Navigated to notifications screen");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xB50D151E),
                    child: Icon(
                      LucideIcons.bell,
                      size: 20,
                      color: Color(0xFFB7C9DB),
                    ),
                  ),
                  // Notification count badge
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4AA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF0D151E),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: const TextStyle(
                            color: Color(0xFF0D151E),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Avatar icon on right with InkResponse
        Container(
          alignment: Alignment.center,
          child: InkResponse(
            onTap: () {
              logger.i("Avatar icon tapped, opening end drawer");
              Scaffold.of(context).openEndDrawer();
              logger.d("End drawer opened");
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xB50D151E),
                child: Icon(
                  LucideIcons.user,
                  size: 22,
                  color: Color(0xFFB7C9DB),
                ),
              ),
            ),
          ),
        ),
      ],
      // if showGradient is true, add BrandGradientLine
      bottom: widget.showGradient
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1.0), child: BrandGradientLine())
          : null,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60 + 1.0); // Updated to match toolbarHeight
}
