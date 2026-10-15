import 'package:flutter_test/flutter_test.dart';
import 'package:project_name/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('UrbanGo smoke test loads SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const UrbanGoApp());
    expect(find.text('UrbanGo'), findsOneWidget);
  });
}
