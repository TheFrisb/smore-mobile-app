import 'dart:async';
import 'dart:io' show Platform; // Add this for platform check

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smore_mobile_app/providers/user_provider.dart';
import 'package:smore_mobile_app/utils/backend_logger.dart';

import '../../constants/constants.dart';

class AppleSignInButton extends StatefulWidget {
  const AppleSignInButton({super.key});

  @override
  State<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends State<AppleSignInButton> {
  bool _isLoading = false;
  static final Logger _logger = Logger();
  final BackendLogger _backendLogger = BackendLogger();

  @override
  void initState() {
    super.initState();
    _initializeAppleSignIn();
  }

  Future<void> _initializeAppleSignIn() async {
    try {
      _logger.i('Checking Apple Sign-In availability');
      _backendLogger.info('Checking Apple Sign-In availability', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'availability_check'
      });
      
      final isAvailable = await SignInWithApple.isAvailable();
      _logger.i('Apple Sign-In available: $isAvailable');
      _backendLogger.info('Apple Sign-In availability check completed', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'availability_check_result',
        'isAvailable': isAvailable
      });
    } catch (e, stackTrace) {
      _logger.e('Failed to check Apple Sign-In availability: $e');
      _backendLogger.errorWithException(
        'Failed to check Apple Sign-In availability',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'apple_sign_in_button',
          'operation': 'availability_check_failed'
        },
      );
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;

    _logger.i('Starting Apple Sign-In process');
    _backendLogger.info('Starting Apple Sign-In process', additionalData: {
      'component': 'apple_sign_in_button',
      'operation': 'sign_in_start'
    });
    
    setState(() {
      _isLoading = true;
    });

    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        _logger.e('Apple Sign-In not available on this platform');
        _backendLogger.error('Apple Sign-In not available on this platform', additionalData: {
          'component': 'apple_sign_in_button',
          'operation': 'sign_in_unavailable',
          'platform': Platform.operatingSystem
        });
        throw 'Apple Sign-In not available on this platform';
      }

      _logger.i('Authenticating with Apple');
      _backendLogger.info('Authenticating with Apple', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'apple_authentication',
        'platform': Platform.operatingSystem
      });
      
      final AuthorizationCredentialAppleID credential;
      if (Platform.isIOS) {
        // Native flow for iOS
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      } else {
        // Web flow for Android
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: Constants.appleSignInClientId,
            redirectUri: Uri.parse(Constants.appleSignInRedirectUri),
          ),
        );
      }
      _logger.i(credential);

      // if (credential.userIdentifier == null) {
      //   _logger.i('Apple Sign-In cancelled by user');
      //   return;
      // }

      _logger.i(
          'Apple authentication successful for user: ${credential.userIdentifier}');
      _backendLogger.info('Apple authentication successful', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'apple_authentication_success',
        'userIdentifier': credential.userIdentifier,
        'platform': Platform.operatingSystem
      });
      
      _logger.i('Getting ID token');

      final String? idToken = credential.identityToken;
      if (idToken == null) {
        _logger.e('Failed to get ID token');
        _backendLogger.error('Failed to get ID token from Apple', additionalData: {
          'component': 'apple_sign_in_button',
          'operation': 'id_token_retrieval_failed',
          'userIdentifier': credential.userIdentifier
        });
        throw 'Failed to get ID token';
      }

      _logger.i('ID token received, sending to backend');
      _backendLogger.info('ID token received, sending to backend', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'backend_sign_in',
        'userIdentifier': credential.userIdentifier
      });
      
      final userProvider = context.read<UserProvider>();
      await userProvider.signInWithApple(idToken);
      
      _logger.i('Apple Sign-In completed successfully');
      _backendLogger.info('Apple Sign-In completed successfully', additionalData: {
        'component': 'apple_sign_in_button',
        'operation': 'sign_in_complete',
        'userIdentifier': credential.userIdentifier
      });
    } catch (e, stackTrace) {
      _logger.e('Apple Sign-In error: $e');
      _backendLogger.errorWithException(
        'Apple Sign-In error',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'apple_sign_in_button',
          'operation': 'sign_in_failed',
          'platform': Platform.operatingSystem
        },
      );
      
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
    return SizedBox(
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
                size: 24,
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
    );
  }
}
