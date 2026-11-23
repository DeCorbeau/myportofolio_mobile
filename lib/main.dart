import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    // MultiProvider injects the API client and auth state into the widget tree.
    return MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.bgMain,
          colorScheme:
              ColorScheme.fromSeed(
                seedColor: AppColors.accentPurple,
                brightness: Brightness.dark,
              ).copyWith(
                primary: AppColors.accentPurple,
                secondary: AppColors.accentCyan,
                surface: AppColors.bgMain,
              ),
          fontFamily: 'SpaceGrotesk',
        ),
        home: MyHomePage(),
      ),
    );
  }
}
