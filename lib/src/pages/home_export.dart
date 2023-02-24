import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../define.dart';
import '../util.dart';
import '../export.dart';
import './home_settings.dart';
import './export_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.share),
              label: AppLocalizations.of(context)!.export),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.settings),
              label: AppLocalizations.of(context)!.about)
        ]),
        tabBuilder: (context, index) {
          late final CupertinoTabView returnValue;
          switch (index) {
            case 0:
              returnValue = CupertinoTabView(builder: (context) {
                return const ExportPage();
              });
              break;
            case 1:
              returnValue = CupertinoTabView(builder: (context) {
                return const SettingsPage();
              });
          }
          return returnValue;
        });
  }
}

class ExportPage extends StatelessWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(appName),
        ),
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(AppLocalizations.of(context)!.launchFrom(botName)),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                onPressed: launchTGBot,
                child: Text(AppLocalizations.of(context)!.openBot(botName)),
              )
            ])));
  }
}
