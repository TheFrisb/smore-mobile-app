import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/constants/constants.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;
  static final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      _logger.i('Initializing Google Sign-In');
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        clientId: Constants.googleSignInClientId,
        serverClientId: Constants.googleSignInServerClientId,
      );
      _logger.i('Google Sign-In initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    _logger.i('Starting Google Sign-In process');
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      if (!signIn.supportsAuthenticate()) {
        _logger.e('Google Sign-In not supported on this platform');
        throw 'Google Sign-In not supported on this platform';
      }

      _logger.i('Authenticating with Google');
      final GoogleSignInAccount? user = await signIn.authenticate();
      if (user == null) {
        _logger.i('Google Sign-In cancelled by user');
        return;
      }

      _logger.i('Google authentication successful for user: ${user.email}');
      _logger.i('Getting ID token');
      final GoogleSignInAuthentication auth = await user.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        _logger.e('Failed to get ID token');
        throw 'Failed to get ID token';
      }

      _logger.i('ID token received, sending to backend');
      final userProvider = context.read<UserProvider>();
      await userProvider.signInWithGoogle(idToken);
      _logger.i('Google Sign-In completed successfully');
    } catch (e) {
      _logger.e('Google Sign-In error: $e');
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
            onPressed: _isLoading ? null : _handleGoogleSignIn,
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
                : Image.asset(
                    'assets/google_logo.png',
                    height: 20,
                    width: 20,
                  ),
            label: Text(
              _isLoading ? 'Signing in...' : 'Sign in with Google',
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
