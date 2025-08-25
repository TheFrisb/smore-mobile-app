import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smore_mobile_app/constants/constants.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

class AppleSignInButton extends StatefulWidget {
  const AppleSignInButton({super.key});

  @override
  State<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends State<AppleSignInButton> {
  bool _isLoading = false;
  static final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeAppleSignIn();
  }

  Future<void> _initializeAppleSignIn() async {
    try {
      _logger.i('Checking Apple Sign-In availability');
      final isAvailable = await SignInWithApple.isAvailable();
      _logger.i('Apple Sign-In available: $isAvailable');
    } catch (e) {
      _logger.e('Failed to check Apple Sign-In availability: $e');
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;

    _logger.i('Starting Apple Sign-In process');
    setState(() {
      _isLoading = true;
    });

    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        _logger.e('Apple Sign-In not available on this platform');
        throw 'Apple Sign-In not available on this platform';
      }

      _logger.i('Authenticating with Apple');
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Constants.appleSignInClientId,
          redirectUri: Uri.parse(Constants.appleSignInRedirectUri),
        ),
      );

      if (credential.userIdentifier == null) {
        _logger.i('Apple Sign-In cancelled by user');
        return;
      }

      _logger.i(
          'Apple authentication successful for user: ${credential.userIdentifier}');
      _logger.i('Getting ID token');

      final String? idToken = credential.identityToken;
      if (idToken == null) {
        _logger.e('Failed to get ID token');
        throw 'Failed to get ID token';
      }

      _logger.i('ID token received, sending to backend');
      final userProvider = context.read<UserProvider>();
      await userProvider.signInWithApple(idToken);
      _logger.i('Apple Sign-In completed successfully');
    } catch (e) {
      _logger.e('Apple Sign-In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF223548),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF223548),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleAppleSignIn,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF223548)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xFF15212E),
            ),
            icon: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.apple,
                    size: 20,
                    color: Colors.white,
                  ),
            label: Text(
              _isLoading ? 'Signing in...' : 'Sign in with Apple',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
