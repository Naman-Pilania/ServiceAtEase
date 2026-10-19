import 'package:flutter_test/flutter_test.dart';
import 'package:project_name/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('serviceAtEase smoke test loads SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const ServiceAtEaseApp());
    expect(find.text('serviceAtEase'), findsOneWidget);
  });
}
