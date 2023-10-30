import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:msb_app/src/settings.dart';
import 'package:provider/provider.dart';
import '../define.dart';
import '../update.dart';
import '../util.dart';
import './home_settings.dart';

var updateDialogShowed = false;

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.share), label: AppLocalizations.of(context)!.export),
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.settings), label: AppLocalizations.of(context)!.about)
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
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Show a alert if update is available.
    //On iOS, build is occasionally called, which will result in multiple alerts,
    //only show once.
    //It is actually a good thing if a user never terminate the app.
    Future.microtask(() => checkUpdate(Provider.of<SettingsProvider>(context, listen: false)).then((value) {
          if (value && !updateDialogShowed) {
            updateDialogShowed = true;
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(AppLocalizations.of(context)!.updateAvailable),
                    content: Text(AppLocalizations.of(context)!.goToDownloadUpdate),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () {
                          context.pop();
                        },
                      )
                    ],
                  );
                });
          }
        }));
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(appName),
      ),
      child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          AppLocalizations.of(context)!.exportTGToWA,
        ),
        const SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.launchFrom(botName)),
        const SizedBox(height: 10),
        CupertinoButton.filled(
          onPressed: launchTGBot,
          child: Text(AppLocalizations.of(context)!.openBot(botName)),
        )
      ])),
    );
  }
}
