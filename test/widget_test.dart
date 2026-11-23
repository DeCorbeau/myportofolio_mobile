import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('home page shows the portfolio menu', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    expect(find.text('PORTFOLIO MENU'), findsOneWidget);
    expect(find.text('View Skills'), findsOneWidget);
    expect(find.text('Add Skill'), findsOneWidget);
  });
}