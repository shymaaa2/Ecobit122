import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eco/map_picker_page.dart';
import 'package:eco/themed_background.dart';
import 'package:eco/theme_notifier.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MapPickerPage E2E and Theme Switching', () {
    testWidgets('MapPickerPage E2E test', (WidgetTester tester) async {
      // Wrap with ValueListenableBuilder to listen to theme changes
      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentTheme, _) {
            return MaterialApp(
              themeMode: currentTheme,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: MapPickerPage(
                testPermissionGranted: true,
                useFakeMap: true, // Use fake map for testing
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Check that GoogleMap or FakeMap exists
      expect(find.byKey(const Key('google_map')), findsNothing);
      expect(find.byKey(const Key('fake_map')), findsOneWidget);

      // Check search field
      expect(find.byKey(const Key('map_search_field')), findsOneWidget);

      // Check location button
      expect(find.byKey(const Key('current_location_button')), findsOneWidget);
    });

    testWidgets('MapPickerPage E2E test with theme switching', (WidgetTester tester) async {
      // Start with light theme
      themeNotifier.setTheme(ThemeMode.light);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentTheme, _) {
            return MaterialApp(
              themeMode: currentTheme,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: ThemedBackground(
                child: MapPickerPage(
                  testPermissionGranted: true,
                  useFakeMap: true,
                ),
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      // Light mode background check
      expect(find.byKey(const Key('light_background')), findsOneWidget);

      // Switch to dark theme
      themeNotifier.setTheme(ThemeMode.dark);
      await tester.pumpAndSettle();

      // Dark mode background check
      expect(find.byKey(const Key('dark_background')), findsOneWidget);
    });
  });
}
