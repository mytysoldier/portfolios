import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:convenience_store_food_record_app/screen/history/history_screen.dart';
import 'package:convenience_store_food_record_app/screen/record/record_screen.dart';
import 'package:convenience_store_food_record_app/screen/statistic/statistic_screen.dart';
import 'package:convenience_store_food_record_app/screen/account/account_screen.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    postgrestOptions: PostgrestClientOptions(
      schema: 'conv_food_record_app', // デフォルトスキーマを指定
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // TODO: ユーザーIDの取得方法は適宜修正
    Future.microtask(() async {
      try {
        await ref.read(userProvider.notifier).fetchUser();
      } catch (e) {
        // ユーザー情報未登録の場合は、デバイスIDで登録
        await ref.read(userProvider.notifier).insertUserWithDeviceId();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: mainThemeData,
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

  static const _routes = ['/', '/record', '/statistic', '/account'];

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
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            context.go(_routes[index]);
          }
        },
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.black),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black),
            label: '記録',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            label: '統計',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black),
            label: 'アカウント',
          ),
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
        if (state.fullPath == '/account') index = 3;
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
        GoRoute(
          path: '/account',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const AccountScreen(),
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
