import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'export_page.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

class ExportDonePage extends StatelessWidget {
  final String sn;
  final String err;
  final String res;
  const ExportDonePage(
      {super.key, required this.sn, required this.err, required this.res});

  @override
  Widget build(BuildContext context) {
    List<Widget> children;

    void onPackBtnPressed(int i) {
      se?.sendToWhatsApp(i);
    }

    List<Widget> genPacksButtons(int total) {
      var entries = <Widget>[];
      for (int i = 0; i < total; i++) {
        entries.add(CupertinoButton(
            child: Text('${AppLocalizations.of(context)!.pack} ${i + 1}'),
            onPressed: () => onPackBtnPressed(i)));
        entries.add(SizedBox(width: 5));
      }
      return entries;
    }

    if (err != "") {
      children = <Widget>[
        const Icon(CupertinoIcons.xmark_circle,
            color: CupertinoColors.destructiveRed),
        const SizedBox(height: 10),
        Text(err)
      ];
    } else {
      if (int.parse(res) == 0) {
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
      } else {
        final entries = genPacksButtons(int.parse(res));
        children = <Widget>[
          const Icon(CupertinoIcons.question_circle,
              color: CupertinoColors.activeBlue),
          Flexible(
              child: Text(AppLocalizations.of(context)!.chooseSplit,
                  textAlign: TextAlign.center)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: entries)
        ];
      }
    }

    children.addAll(<Widget>[
      const SizedBox(height: 10),
      Text('sn: $sn'),
    ]);

    if (Platform.isAndroid) {
      children.addAll(<Widget>[
        const SizedBox(height: 20),
        CupertinoButton(
            onPressed: WhatsappStickersExporter.launchWhatsApp,
            child: Text(AppLocalizations.of(context)!.openWhatsApp)),
      ]);
    }

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Export Done"),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min, children: children))));
  }
}
