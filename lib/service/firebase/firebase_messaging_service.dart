import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/backend_logger.dart';
import '../user_service.dart';
import 'local_notifications_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  // Backend logger instance
  final BackendLogger _logger = BackendLogger();
  
  // User service for backend operations
  final UserService _userService = UserService();
  
  // Callback function to refresh notifications
  Future<void> Function()? _onNotificationReceivedCallback;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({
    required LocalNotificationsService localNotificationsService,
    Future<void> Function()? onNotificationReceived,
  }) async {
    _logger.info('Initializing Firebase Messaging Service', additionalData: {
      'component': 'firebase_messaging_service',
      'operation': 'initialization'
    });

    try {
      // Init local notifications service
      _localNotificationsService = localNotificationsService;
      
      // Set notification received callback
      _onNotificationReceivedCallback = onNotificationReceived;

      // Handle FCM token
      _handlePushNotificationsToken();

      // Request user permission for notifications
      _requestPermission();

      // Register handler for background messages (app terminated)
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Listen for messages when the app is in foreground
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // Listen for notification taps when the app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      // Check for initial message that opened the app from terminated state
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _logger.info('App opened from terminated state by notification',
            additionalData: {
              'component': 'firebase_messaging_service',
              'operation': 'app_opened_by_notification',
              'messageId': initialMessage.messageId,
              'data': initialMessage.data
            });
        _onMessageOpenedApp(initialMessage);
      }

      _logger.info('Firebase Messaging Service initialized successfully',
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'initialization_complete'
          });
    } catch (e, stackTrace) {
      _logger.errorWithException(
        'Failed to initialize Firebase Messaging Service',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'initialization_failed'
        },
      );
      rethrow;
    }
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    try {
      // Get the FCM token for the device
      final token = await FirebaseMessaging.instance.getToken();
      _logger.info('Push notifications token retrieved', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'token_retrieval',
        'token': token
      });

      // Send initial token to backend
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // Listen for token refresh events
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        _logger.info('FCM token refreshed', additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'token_refresh',
          'newToken': fcmToken
        });
        
        // Send refreshed token to backend
        _sendTokenToBackend(fcmToken);
      }).onError((error) {
        // Handle errors during token refresh
        _logger.errorWithException(
          'Error refreshing FCM token',
          error: error,
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'token_refresh_error'
          },
        );
      });
    } catch (e, stackTrace) {
      _logger.errorWithException(
        'Failed to handle push notifications token',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'token_handling_failed'
        },
      );
    }
  }

  /// Sends FCM token to backend with error handling
  Future<void> _sendTokenToBackend(String token) async {
    try {
      _logger.info('Sending FCM token to backend', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'send_token_to_backend',
        'token': token
      });

      await _userService.sendFcmTokenToBackend(token);

      _logger.info('FCM token successfully sent to backend', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'send_token_to_backend_success',
        'token': token
      });
    } catch (e, stackTrace) {
      _logger.errorWithException(
        'Failed to send FCM token to backend',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'send_token_to_backend_failed',
          'token': token
        },
      );
      // Don't rethrow - we don't want token sending failures to break the app
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    try {
      // Request permission for alerts, badges, and sounds
      final result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Log the user's permission decision
      _logger.info('User notification permission requested', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'permission_request',
        'authorizationStatus': result.authorizationStatus.toString(),
        'alert': result.alert.toString(),
        'badge': result.badge.toString(),
        'sound': result.sound.toString(),
      });
    } catch (e, stackTrace) {
      _logger.errorWithException(
        'Failed to request notification permission',
        error: e,
        stackTrace: stackTrace,
        additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'permission_request_failed'
        },
      );
    }
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    _logger.info('Foreground message received', additionalData: {
      'component': 'firebase_messaging_service',
      'operation': 'foreground_message',
      'messageId': message.messageId,
      'data': message.data,
      'from': message.from,
      'sentTime': message.sentTime?.toIso8601String()
    });

    final notificationData = message.notification;
    if (notificationData != null) {
      _logger.info('Displaying foreground notification', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'foreground_notification_display',
        'title': notificationData.title,
        'body': notificationData.body,
        'messageId': message.messageId
      });

      // Display a local notification using the service
      _localNotificationsService?.showNotification(notificationData.title,
          notificationData.body, message.data.toString());
    } else {
      _logger.warning(
          'Foreground message received but no notification data found',
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'foreground_message_no_notification',
            'messageId': message.messageId,
            'data': message.data
          });
    }
    
    // Refresh notifications in the provider
    _refreshNotifications('foreground_message');
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    _logger.info('Notification caused the app to open', additionalData: {
      'component': 'firebase_messaging_service',
      'operation': 'notification_tap',
      'messageId': message.messageId,
      'data': message.data,
      'from': message.from,
      'sentTime': message.sentTime?.toIso8601String()
    });
    
    // Refresh notifications in the provider
    _refreshNotifications('notification_tap');
    // TODO: Add navigation or specific handling based on message data
  }

  /// Refreshes notifications in the provider
  Future<void> _refreshNotifications(String trigger) async {
    if (_onNotificationReceivedCallback != null) {
      try {
        _logger.info('Refreshing notifications due to $trigger', additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'refresh_notifications',
          'trigger': trigger
        });
        
        await _onNotificationReceivedCallback!();
        
        _logger.info('Notifications refreshed successfully', additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'refresh_notifications_success',
          'trigger': trigger
        });
      } catch (e, stackTrace) {
        _logger.errorWithException(
          'Failed to refresh notifications',
          error: e,
          stackTrace: stackTrace,
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'refresh_notifications_failed',
            'trigger': trigger
          },
        );
      }
    } else {
      _logger.warning('No notification refresh callback set', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'refresh_notifications_no_callback',
        'trigger': trigger
      });
    }
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final BackendLogger logger = BackendLogger();
  logger.info('Background message received', additionalData: {
    'component': 'firebase_messaging_service',
    'operation': 'background_message',
    'messageId': message.messageId,
    'data': message.data,
    'from': message.from,
    'sentTime': message.sentTime?.toIso8601String()
  });

  try {
    // Initialize Firebase if not already done
    await Firebase.initializeApp();
    logger.info('Firebase initialized in background handler', additionalData: {
      'component': 'firebase_messaging_service',
      'operation': 'background_firebase_init'
    });

    // Initialize local notifications service
    final localNotificationsService = LocalNotificationsService.instance();
    await localNotificationsService.init();
    logger.info('Local notifications service initialized in background handler',
        additionalData: {
          'component': 'firebase_messaging_service',
          'operation': 'background_notifications_init'
        });

    // Display the notification
    final notificationData = message.notification;
    if (notificationData != null) {
      logger.info('Displaying background notification', additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'background_notification_display',
        'title': notificationData.title,
        'body': notificationData.body,
        'messageId': message.messageId
      });

      await localNotificationsService.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );

      logger.info('Background notification displayed successfully',
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'background_notification_success',
            'messageId': message.messageId
          });
    } else {
      logger.warning(
          'Background message received but no notification data found',
          additionalData: {
            'component': 'firebase_messaging_service',
            'operation': 'background_message_no_notification',
            'messageId': message.messageId,
            'data': message.data
          });
    }
  } catch (e, stackTrace) {
    logger.errorWithException(
      'Error handling background message',
      error: e,
      stackTrace: stackTrace,
      additionalData: {
        'component': 'firebase_messaging_service',
        'operation': 'background_message_error',
        'messageId': message.messageId
      },
    );
  }
}
