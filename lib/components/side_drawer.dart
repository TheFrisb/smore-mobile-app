import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:smore_mobile_app/screens/contact_us_screen.dart';
import 'package:smore_mobile_app/screens/faq_screen.dart';
import 'package:timezone/timezone.dart' as tz;

import '../providers/user_provider.dart';
import '../screens/manage_plan_screen.dart';
import '../screens/my_account_screen.dart';
import 'timezone_picker_dialog.dart';

class DrawerDestinationLink {
  const DrawerDestinationLink(this.label, this.icon, this.destination);

  final String label;
  final Widget icon;
  final Widget destination;
}

const List<DrawerDestinationLink> destinations = <DrawerDestinationLink>[
  DrawerDestinationLink(
      'My Account', Icon(LucideIcons.user), MyAccountScreen()),
  DrawerDestinationLink(
      'Manage Plan', Icon(Icons.manage_history_outlined), ManagePlanScreen()),
  DrawerDestinationLink(
      'Contact Us', Icon(LucideIcons.messageSquare), ContactUsScreen()),
  DrawerDestinationLink(
      'FAQ', Icon(LucideIcons.circleQuestionMark), FaqScreen()),
];

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isGuest = userProvider.user == null;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // User info section
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 80, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProvider.user?.username ?? (isGuest ? 'Guest' : ''),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 6),
                // _buildSubscriptionEndDate(context),
                const SizedBox(height: 12),
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

          // List items with spacing
          ...destinations.map(
            (DrawerDestinationLink destination) {
              if ((destination.label == 'My Account' && isGuest) ||
                  (destination.label == 'Manage Plan' && isGuest)) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    title: Row(
                      children: [
                        Text(destination.label),
                        const SizedBox(width: 8),
                        Icon(LucideIcons.lock,
                            size: 18, color: Colors.red.withOpacity(0.5)),
                      ],
                    ),
                    leading: destination.icon,
                    enabled: false,
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    title: Text(destination.label),
                    leading: destination.icon,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        SlideFadePageRoute(page: destination.destination),
                      );
                    },
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                  ),
                );
              }
            },
          ).expand((widget) => [widget, const SizedBox(height: 8)]),

          // Timezone item
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 24,
              title: Text(
                  'Timezone: ${context.watch<UserProvider>().userTimezone ?? 'Not set'}'),
              leading: const Icon(LucideIcons.clock9),
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (context) => TimezonePickerDialog(
                    initialValue: context.read<UserProvider>().userTimezone,
                  ),
                );
                if (selected != null && selected.isNotEmpty) {
                  // Update provider
                  await context.read<UserProvider>().setUserTimezone(selected);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Timezone changed to $selected'),
                      backgroundColor: const Color(0xFF0BA5EC),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
            ),
          ),
          const SizedBox(height: 8),

          const Spacer(),

          // Divider and Logout
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 12),
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
            child: isGuest
                ? ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    title: const Text('Sign in'),
                    leading: Icon(LucideIcons.logIn,
                        color: Theme.of(context).primaryColor),
                    onTap: () {
                      userProvider.isGuest = false; // Set guest to false
                    },
                    dense: true,
                  )
                : ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    title: const Text('Logout'),
                    leading: Icon(LucideIcons.logOut,
                        color: Colors.red.withOpacity(0.6)),
                    onTap: () {
                      context.read<UserProvider>().logout();
                    },
                    dense: true,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionEndDate(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    UserSubscription? userSubscription = userProvider.userSubscription;

    String text;
    if (userSubscription == null) {
      text = 'No active subscription';
    } else if (userSubscription.isInactive) {
      text =
          'Subscription expired on ${DateFormat('dd MMM yyyy').format(userSubscription.endDate)}';
    } else {
      text =
          'Subscription ends on ${DateFormat('dd MMM yyyy').format(userSubscription.endDate)}';
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
    );
  }
}

// Custom slide+fade transition
class SlideFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetTween =
                Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOutCubic));
            final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOutCubic));
            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}


