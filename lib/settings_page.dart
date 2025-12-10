import 'package:eco/streams/general_stream.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco/l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'tutorial_video_page.dart';

enum NotificationType { inAppPopup, headsUp }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Locale appLocale = const Locale('en');
  int _currentIndex = 4;

  NotificationType _notificationType = NotificationType.inAppPopup;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _loadLanguagePreference();
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

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'en';
    setState(() {
      appLocale = Locale(savedLocale);
    });
  }

  Future<void> _saveLanguagePreference(String chosenLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', chosenLang);
  }


  Future<void> _toggleLanguage() async {
    final newLang = appLocale.languageCode == 'en' ? 'ar' : 'en';

    await _saveLanguagePreference(newLang);

    setState(() {
      appLocale = Locale(newLang);
    });


    GeneralStreams.updateLanguage(Locale(newLang));
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
            child: Text(AppLocalizations.of(context)!.ok),
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

  void _openTutorial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TutorialVideoPage()),
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
                        AppLocalizations.of(context)!.settings,
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
                            TextButton(
                              child: const Text("تغيير اللغة | Change Language"),
                              onPressed: _toggleLanguage,
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            GestureDetector(
                              onTap: () {},
                              child: _buildSettingTile(
                                  Icons.brightness_6, 'Theme', isDark),
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            GestureDetector(
                              onTap: () {},
                              child: _buildSettingTile(
                                  Icons.notifications,
                                  AppLocalizations.of(context)!.notifType,
                                  isDark,
                                  extraText: _notificationType == NotificationType.inAppPopup
                                      ? 'Pop-ups'
                                      : 'Heads-up'),
                            ),
                            Divider(color: isDark ? Colors.white30 : Colors.black26),
                            GestureDetector(
                              onTap: _openTutorial,
                              child: _buildSettingTile(
                                  Icons.school,
                                  AppLocalizations.of(context)!.tutorial,
                                  isDark),
                            ),
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
