import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hajj_companion/models/family_member.dart';

// Background message handler (top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool _isInitialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'family_safety_alerts',
      'Family Safety Alerts',
      description: 'Notifications for family member distance alerts',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Request notification permissions
    await _requestPermissions();

    // Configure FCM
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    _isInitialized = true;

    // Get and print FCM token for testing
    final fcmToken = await getFcmToken();
    print('================================================================================');
    print('🔔 FCM TOKEN FOR PUSH NOTIFICATIONS:');
    print(fcmToken ?? 'No token available');
    print('================================================================================');
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    // Request FCM permission
    final fcmSettings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Request local notification permission (Android 13+)
    final localPermission = await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return fcmSettings.authorizationStatus == AuthorizationStatus.authorized &&
        (localPermission ?? true);
  }

  /// Get FCM token for this device
  Future<String?> getFcmToken() async {
    return await _fcm.getToken();
  }

  /// Show distance alert notification
  Future<void> showDistanceAlert({
    required FamilyMember child,
    required double currentDistance,
    required double safeDistance,
  }) async {
    final distanceKm = (currentDistance / 1000).toStringAsFixed(2);
    final safeDistanceKm = (safeDistance / 1000).toStringAsFixed(2);

    final androidDetails = AndroidNotificationDetails(
      'family_safety_alerts',
      'Family Safety Alerts',
      channelDescription: 'Notifications for family member distance alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFFFF0000),
      playSound: true,
      enableVibration: true,
      styleInformation: const BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      child.deviceId.hashCode,
      '⚠️ ${child.displayName} is far away!',
      '${child.displayName} is $distanceKm km away (safe distance: $safeDistanceKm km)',
      notificationDetails,
      payload: 'distance_alert:${child.deviceId}',
    );
  }

  /// Show general family safety notification
  Future<void> showFamilySafetyNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'family_safety_alerts',
      'Family Safety Alerts',
      channelDescription: 'Notifications for family safety updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      showFamilySafetyNotification(
        title: message.notification!.title ?? 'Family Safety',
        body: message.notification!.body ?? '',
        payload: message.data['type'],
      );
    }
  }

  /// Handle notification tap when app is in background
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.data}');
    // TODO: Navigate to appropriate screen based on message.data
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      print('Notification tapped with payload: $payload');
      // TODO: Navigate to family members screen or specific child
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancel(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Subscribe to topic (for group notifications)
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }
}
