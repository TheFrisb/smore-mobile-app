import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_colors.dart';
// import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static final Logger logger = Logger();

  Future<void> _launchUrl(String url) async {
    Uri uriResource = Uri.parse(url);
    if (!await launchUrl(uriResource, mode: LaunchMode.externalApplication)) {
      logger.e("Failed to launch url: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackButtonScreen(
      title: "Contact Us",
      body: Column(
        children: [
          ContactOption(
            icon: FontAwesomeIcons.whatsapp,
            title: "Contact us on WhatsApp",
            onTap: () => _launchUrl("https://wa.me/+359884108275"),
          ),
          const SizedBox(height: 16),
          ContactOption(
            icon: FontAwesomeIcons.telegram,
            title: "Contact us on Telegram",
            onTap: () => _launchUrl("https://t.me/smoreltd"),
          ),
          const SizedBox(height: 16),
          ContactOption(
            icon: Icons.email_outlined,
            title: "Send us an email",
            onTap: () => _launchUrl("mailto:smore1x2@gmail.com"),
          ),
        ],
      ),
    );
  }
}

class ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ContactOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D151E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.primary.shade800.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 1,
              )),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
