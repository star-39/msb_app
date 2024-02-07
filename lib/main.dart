
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/define.dart';
import 'package:msb_app/src/export.dart';
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
    GoRoute(path: '/export', builder: (context, state) => const MyHomePage(), routes: <RouteBase>[
      GoRoute(
          path: 'done',
          builder: (BuildContext context, GoRouterState state) {
            final se = state.extra as StickerExport;
            return ExportDonePage(se: se);
          }),
      GoRoute(
          path: ':sn',
          builder: (BuildContext context, GoRouterState state) {
            return ExportStickerPage(
                sn: state.pathParameters['sn'] ?? "", qid: state.uri.queryParameters['qid'] ?? "", hex: state.uri.queryParameters['hex'] ?? "",
                dn: state.uri.queryParameters['dn'] ?? defaultWebappDomainName);
          }),
    ]),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsPage(), routes: <RouteBase>[
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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addObserver(this);
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initSettings(Provider.of<SettingsProvider>(context, listen: false));
    bool isDarkMode = _brightness == Brightness.dark;
    return CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(brightness: isDarkMode ? Brightness.dark : Brightness.light),
        routerConfig: _router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales);
  }
}
