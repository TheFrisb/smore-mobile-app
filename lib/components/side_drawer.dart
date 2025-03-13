import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/screens/contact_us_screen.dart';
import 'package:smore_mobile_app/screens/faq_screen.dart';
import 'package:timezone/timezone.dart' as tz;

import '../providers/user_provider.dart';
import '../screens/manage_plan_screen.dart';
import '../screens/my_account_screen.dart';

class DrawerDestinationLink {
  const DrawerDestinationLink(this.label, this.icon, this.destination);

  final String label;
  final Widget icon;
  final Widget destination;
}

const List<DrawerDestinationLink> destinations = <DrawerDestinationLink>[
  DrawerDestinationLink(
      'My Account', Icon(Icons.account_circle_outlined), MyAccountScreen()),
  DrawerDestinationLink(
      'Manage Plan', Icon(Icons.manage_history_outlined), ManagePlanScreen()),
  DrawerDestinationLink(
      'Contact Us', Icon(Icons.question_answer_outlined), ContactUsScreen()),
  DrawerDestinationLink('FAQ', Icon(Icons.help_outline), FaqScreen()),
];

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // User info section
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 48, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'admin',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Subscription ends: March 1, 2025',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
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
                      MaterialPageRoute(
                        builder: (context) => destination.destination,
                      ),
                    );
                  },
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                ),
              );
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
              leading: const Icon(Icons.access_time),
              onTap: () {
                print(tz.timeZoneDatabase.locations.keys.toList());
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
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minLeadingWidth: 24,
              title: const Text('Logout'),
              leading: Icon(Icons.logout, color: Colors.red.withOpacity(0.6)),
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
}
