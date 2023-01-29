import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/define.dart';
import 'package:msb_app/src/settings.dart';
import 'package:provider/provider.dart';
import 'src/pages/home_export.dart';
import 'src/pages/home_settings.dart';


void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => SettingsProvider(),
      child: const MyApp())
  );
}

final _router = GoRouter(
  initialLocation: '/export',
  routes: [
    GoRoute(
        path: '/export',
        builder: (context, state) => const MyHomePage(),
        routes: <RouteBase>[
          GoRoute(
              path: ':sn',
              builder: (BuildContext context, GoRouterState state) {
                return ExportStickerPage(
                    sn: state.params['sn'], qid: state.queryParams['qid'], hex: state.queryParams['hex']);
              })
        ]),
    GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
        routes: <RouteBase>[
          GoRoute(
            path: 'publisher',
            builder: (context, state) {
              return const PublisherPage();
            },
          ),
          GoRoute(
              path: 'about',
              builder: (BuildContext context, GoRouterState state) {
                return const AboutPage();
              }),
        ]),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initSettings();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CupertinoApp.router(
        theme: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light),
        routerConfig: _router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales);
  }
}
