import 'package:flutter/material.dart';

class DrawerDestinationLink {
  const DrawerDestinationLink(this.label, this.icon);

  final String label;
  final Widget icon;
}

const List<DrawerDestinationLink> destinations = <DrawerDestinationLink>[
  DrawerDestinationLink('My Account', Icon(Icons.account_circle_outlined)),
  DrawerDestinationLink('Manage Plan', Icon(Icons.manage_history_outlined)),
  DrawerDestinationLink('Contact Us', Icon(Icons.question_answer_outlined)),
  DrawerDestinationLink('FAQ', Icon(Icons.help_outline)),
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
                const Text(
                  'admin',
                  style: TextStyle(
                    color: Color(0xFFB7C9DB),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Subscription ends: Jan 1, 2025',
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
                  onTap: () {},
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                ),
              );
            },
          ).expand((widget) => [widget, const SizedBox(height: 8)]),

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
              leading: const Icon(Icons.logout, color: Colors.grey),
              onTap: () {},
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}
