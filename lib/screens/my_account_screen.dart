import 'package:flutter/material.dart';
import 'package:smore_mobile_app/components/decoration/brand_gradient_line.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "My Account",
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              // add border radius
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF0D151E),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle_outlined,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text("Username",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("admin", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              // add border radius
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF0D151E),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text("Email",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("admin@yahoo.com", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              // add border radius
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF0D151E),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text("Full Name",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Aleksandar Bedjovski", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const BrandGradientLine(
              height: 2,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Text("Current plan",
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Spacer(),
                Text("Manage Plan",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor))
              ],
            ),
            Row(
              children: [
                Text("Expires in 30 days",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400))
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.sports_soccer_outlined,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text("Soccer", style: TextStyle(fontSize: 18)),
                Spacer(),
                Text("\$69.99/month",
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 32),
            const BrandGradientLine(
              height: 2,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Password change instructions sent to your email'),
                      duration: const Duration(seconds: 5),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
