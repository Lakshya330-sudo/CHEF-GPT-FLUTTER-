import 'package:flutter_test/flutter_test.dart';
import 'package:chefgpt/main.dart';

void main() {
  testWidgets('Starting screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ChefGPTApp());
    expect(find.text('ChefGPT'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
