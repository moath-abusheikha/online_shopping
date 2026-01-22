import 'package:flutter_test/flutter_test.dart';
import 'package:online_shopping/main.dart';
import 'package:online_shopping/repository/auth_repository.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 1. Create a dummy/real repository for the test
    final authRepository = AuthRepository();

    // 2. Pass the repository to your app constructor
    await tester.pumpWidget(OnlineShopping(authRepository: authRepository));

    // 3. (Optional) Basic test to see if the app loads
    // Since you are using AuthGate, the app will likely start on a Loading screen
    expect(find.byType(OnlineShopping), findsOneWidget);
  });
}