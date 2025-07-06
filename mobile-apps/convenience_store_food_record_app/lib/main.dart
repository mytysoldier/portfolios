import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/screen/history_screen.dart';
import 'package:convenience_store_food_record_app/screen/record_screen.dart';
import 'package:convenience_store_food_record_app/screen/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  const MainScaffold({
    required this.child,
    required this.currentIndex,
    super.key,
  });

  static const _routes = ['/', '/record', '/statistic'];

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.screen_title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(padding: const EdgeInsets.all(16), child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            context.go(_routes[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '記録'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '統計'),
        ],
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        int index = 0;
        if (state.fullPath == '/record') index = 1;
        if (state.fullPath == '/statistic') index = 2;
        return MainScaffold(currentIndex: index, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const HistoryScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: '/record',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const RecordScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
        GoRoute(
          path: '/statistic',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const StatisticScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        ),
      ],
    ),
  ],
);
