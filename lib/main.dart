import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// App pages
import 'settings_page.dart';
import 'home.dart';
import 'gallery.dart';
import 'map_picker_page.dart';
import 'welcome.dart';

// Theme management
import 'theme_notifier.dart';
import 'themed_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EcoBiteApp());
}

class EcoBiteApp extends StatelessWidget {
  const EcoBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return ScreenUtilInit(
          designSize: const Size(384, 854),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'EcoBite',
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.green,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.green,
              ),
              themeMode: currentMode,
              home: const WelcomePage(),
            );
          },
        );
      },
    );
  }
}

// Bottom Navigation
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  late CameraDescription cameraDescription;
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;
  bool cameraIsAvailable = Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPages();
    });
  }

  Future<void> initPages() async {
    _widgetOptions = [
      const HomePage(key: Key('take_shot_page')),
      const GalleryScreen(key: Key('gallery_tab')),
      const MapPickerPage(key: Key('map_tab')),
      const SettingsPage(key: Key('settings_tab')),
    ];
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoBite'),
        actions: [
          IconButton(
            key: const Key('theme_toggle_button'),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: ThemedBackground(
        child: Center(
          child: _widgetOptions == null
              ? const CircularProgressIndicator()
              : _widgetOptions!.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12.w),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD2E3C8),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
            unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, key: Key('take_shot_tab')),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo, key: Key('gallery_tab_icon')),
                label: 'Gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map, key: Key('map_tab_icon')),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, key: Key('settings_tab_icon')),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}