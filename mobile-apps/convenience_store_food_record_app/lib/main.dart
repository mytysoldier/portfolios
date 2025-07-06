import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/screen/history_screen.dart';
import 'package:convenience_store_food_record_app/screen/record_screen.dart';
import 'package:convenience_store_food_record_app/screen/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HistoryScreen();
      },
    ),
    GoRoute(
      path: '/record',
      builder: (BuildContext context, GoRouterState state) {
        return RecordScreen();
      },
    ),
    GoRoute(
      path: '/statistic',
      builder: (BuildContext context, GoRouterState state) {
        return StatisticScreen();
      },
    ),
  ],
);

void main() {
  MaterialApp.router(
    routerConfig: _router,
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       localizationsDelegates: L10n.localizationsDelegates,
//       supportedLocales: L10n.supportedLocales,
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
