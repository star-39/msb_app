import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/settings.dart';
import 'package:provider/provider.dart';
import 'src/pages/home_export.dart';
import 'src/pages/home_settings.dart';
import 'src/pages/export_page.dart';
import 'src/pages/export_done_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ChangeNotifierProvider(create: (context) => ProgressProvider()),
    ],
    child: const MyApp(),
  ));
}

final _router = GoRouter(
  initialLocation: '/export',
  routes: [
    GoRoute(
        path: '/export',
        builder: (context, state) => const MyHomePage(),
        routes: <RouteBase>[
          GoRoute(
              path: 'done',
              builder: (BuildContext context, GoRouterState state) {
                return ExportDonePage(
                    sn: state.queryParams['sn'] ?? "",
                    err: state.queryParams['err'] ?? "",
                    res: state.queryParams['res'] ?? "");
              }),
          GoRoute(
              path: ':sn',
              builder: (BuildContext context, GoRouterState state) {
                return ExportStickerPage(
                    sn: state.params['sn'] ?? "",
                    qid: state.queryParams['qid'] ?? "",
                    hex: state.queryParams['hex'] ?? "");
              }),
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance?.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance?.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initSettings();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = _brightness == Brightness.dark;
    // return Consumer<SettingsProvider>(
    //   builder: (context, provider, child) {
    return CupertinoApp.router(
        theme: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light),
        routerConfig: _router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales);
    // },
    // );
  }
}
