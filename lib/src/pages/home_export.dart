import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import '../define.dart';
import '../util.dart';
import '../export.dart';
import './home_settings.dart';

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

class ExportStickerPage extends StatefulWidget {
  final String? sn;
  final String? qid;
  final String? hex;
  const ExportStickerPage({super.key, this.sn, this.qid, this.hex});

  State<ExportStickerPage> createState() => _ExportStickerPage();
}

class _ExportStickerPage extends State<ExportStickerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Uri _genExportLink() {
    var link = '${webappUrl}/api/ss?sn=${widget.sn}&qid=${widget.qid}&hex=${widget.hex}&cmd=export';
    return Uri.parse(link);
  }


  @override
  Widget build(BuildContext context) {
    final uri = _genExportLink();
    final StickerExport se;
    se = StickerExport(link: uri);

    void onPackBtnPressed(int i) {
      se.sendToWhatsApp(i);
    }

    List<Widget> genPacksButtons(int total) {
      var entries = <Widget>[];
      for (int i = 0; i< total; i++) {
        entries.add(
            CupertinoButton(
                child: Text('${AppLocalizations.of(context)!.pack} ${i+1}'),
                onPressed: () => onPackBtnPressed(i))
        );
        entries.add(SizedBox(width: 5));
      }
      return entries;
    }


    return FutureBuilder<int>(
        future: se.installFromRemote(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case -1:
                children = <Widget>[
                  const Icon(CupertinoIcons.xmark_circle,
                      color: CupertinoColors.destructiveRed),
                  const SizedBox(height: 10),
                ];
                break;
              case 0:
                log("rendered OK");
                children = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.check_mark_circled,
                          color: CupertinoColors.activeGreen),
                      Text("OK")
                    ],
                  )
                ];
                break;
              default:
                final entries = genPacksButtons(snapshot.data!);
                children = <Widget>[
                      const Icon(CupertinoIcons.question_circle,
                          color: CupertinoColors.activeBlue),
                      Flexible( child:
                      Text(AppLocalizations.of(context)!.chooseSplit, textAlign: TextAlign.center)
                      ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,children: entries)
                    ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(CupertinoIcons.xmark_circle,
                  color: CupertinoColors.destructiveRed),
              const SizedBox(height: 10),
              Text(snapshot.error.toString())
            ];
          } else {
            children = <Widget>[
              const CupertinoActivityIndicator(),
            ];
          }
          //Also show some details.
          children.addAll(<Widget>[
            const SizedBox(height: 10),
            Text('sn: ${widget.sn}'),
            const SizedBox(height: 10),
            Text('qid: ${widget.qid}')
          ]);

          return CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                middle: Text("Export to WhatsApp"),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              )));
        });
  }
}
