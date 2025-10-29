import 'package:flutter/material.dart';
import 'home.dart';
import 'theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationType { inAppPopup, headsUp }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 4;

  NotificationType _notificationType = NotificationType.inAppPopup;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _initNotifications();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('notification_type') ?? 0;
    setState(() {
      _notificationType = NotificationType.values[savedIndex];
    });
  }

  Future<void> _saveNotificationPreference(NotificationType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_type', type.index);
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showNotification() {
    if (_notificationType == NotificationType.inAppPopup) {
      _showInAppPopup();
    } else {
      _showHeadsUpNotification();
    }
  }

  void _showInAppPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification'),
        content: const Text('This is an in-app pop-up notification.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _showHeadsUpNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'heads_up_channel',
      'Heads Up Notifications',
      channelDescription: 'Channel for heads-up notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Heads-up Notification',
      'This is a heads-up notification.',
      notificationDetails,
    );
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: const Text('Choose Theme'),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: themeNotifier.value,
                onChanged: (mode) {
                  themeNotifier.setTheme(mode!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: themeNotifier.value,
                onChanged: (mode) {
                  themeNotifier.setTheme(mode!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: const Text('Choose Notification Type'),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: NotificationType.values.map((type) {
              return RadioListTile<NotificationType>(
                title: Text(
                  type == NotificationType.inAppPopup
                      ? 'In-app Pop-ups'
                      : 'Heads-up Notifications',
                ),
                value: type,
                groupValue: _notificationType,
                onChanged: (NotificationType? value) {
                  if (value != null) {
                    setState(() {
                      _notificationType = value;
                    });
                    _saveNotificationPreference(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark ? 'assets/dark_mode_background.png' : 'assets/image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: isDark ? Colors.white : Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.8)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSettingTile(
                              Icons.language,
                              'Language',
                              isDark,
                              extraText: 'English  |  Arabic',
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            GestureDetector(
                              onTap: _showThemeDialog,
                              child: _buildSettingTile(
                                  Icons.brightness_6, 'Theme', isDark),
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            GestureDetector(
                              onTap: _showNotificationTypeDialog,
                              child: _buildSettingTile(
                                  Icons.notifications, 'Notification Type', isDark,
                                  extraText: _notificationType == NotificationType.inAppPopup
                                      ? 'In-app Pop-ups'
                                      : 'Heads-up Notifications'),
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            _buildSettingTile(Icons.school, 'Tutorial', isDark),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: showNotification,
                              child: const Text('Test Notification'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, bool isDark,
      {String? extraText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: isDark ? Colors.white : Colors.black),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (extraText != null)
            Text(
              extraText,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
        ],
      ),
    );
  }
}

