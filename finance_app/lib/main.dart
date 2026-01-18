import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/navigation/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupServiceLocator(seedDatabase: true);

  runApp(const NetWorthTrackerApp());
}

class NetWorthTrackerApp extends StatelessWidget {
  const NetWorthTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      title: 'Net Worth Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      routerConfig: appRouter.router,
    );
  }
}
