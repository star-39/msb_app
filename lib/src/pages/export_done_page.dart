import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/export.dart';
import 'export_page.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

class ExportDonePage extends StatelessWidget {
  final StickerExport se;
  const ExportDonePage({super.key, required this.se});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    void onPackBtnPressed(int i) {
      se.sendToWhatsApp(i);
    }

    List<Widget> genPacksButtons(int total) {
      var entries = <Widget>[];
      for (int i = 0; i < total; i++) {
        entries.add(CupertinoButton(
            child: Text('${AppLocalizations.of(context)!.pack} ${i + 1}'), onPressed: () => onPackBtnPressed(i)));
        entries.add(const SizedBox(width: 5));
      }
      return entries;
    }

    if (se.err != null) {
      children = <Widget>[
        const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.destructiveRed),
        const SizedBox(height: 10),
        Text(se.err.toString())
      ];
    } else {
      if (se.amount < se.ssFiles.length) {
        children.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.info_circle, color: CupertinoColors.activeBlue),
            Text("${se.ssFiles.length - se.amount} sticker ignored due to size limit.")
          ],
        ));
      }
      if (se.stickerPacks.length == 1) {
        children.addAll(<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(CupertinoIcons.check_mark_circled, color: CupertinoColors.activeGreen), Text("OK")],
          )
        ]);
      } else {
        final entries = genPacksButtons(se.stickerPacks.length);
        children.addAll(<Widget>[
          const Icon(CupertinoIcons.info_circle, color: CupertinoColors.activeBlue),
          Flexible(child: Text(AppLocalizations.of(context)!.chooseSplit, textAlign: TextAlign.center)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: entries)
        ]);
      }
    }

    if (se.wss != null) {
      children.addAll(<Widget>[
        const SizedBox(height: 10),
        Text(
          se.wss!.ssname,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 5),
        Text(se.wss!.sstitle),
      ]);
    } else {
      children.addAll(<Widget>[
        const SizedBox(height: 10),
        const Text('ID:'),
        Text(se.sn),
      ]);
    }

    if (Platform.isAndroid) {
      children.addAll(<Widget>[
        const SizedBox(height: 20),
        CupertinoButton(
            onPressed: WhatsappStickersExporter.launchWhatsApp,
            child: Text(AppLocalizations.of(context)!.openWhatsApp)),
      ]);
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.exportToWhatsApp),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: children))));
  }
}
