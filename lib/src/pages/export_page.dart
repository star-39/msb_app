import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../export.dart';

class ProgressProvider with ChangeNotifier {
  String _title = "";
  int _progress = 0;
  int _total = 0;

  String get title => _title;
  int get progress => _progress;
  int get total => _total;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  set progress(int value) {
    _progress = value;
    notifyListeners();
  }

  set total(int value) {
    _total = value;
    notifyListeners();
  }
}

class ExportStickerPage extends StatefulWidget {
  final String sn;
  final String qid;
  final String hex;
  final String dn;
  const ExportStickerPage({super.key, required this.sn, required this.qid, required this.hex, required this.dn});

  @override
  State<ExportStickerPage> createState() => _ExportStickerPage();
}

class _ExportStickerPage extends State<ExportStickerPage> {
  @override
  void initState() {
    super.initState();
    // Refresh ProgressProvider.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProgressProvider>(context, listen: false).total = 0;
      Provider.of<ProgressProvider>(context, listen: false).progress = 0;
      Provider.of<ProgressProvider>(context, listen: false).title = "...";
    });
    //go to done page when done.
    StickerExport(sn: widget.sn, qid: widget.qid, hex: widget.hex, dn: widget.dn)
        .installFromRemote(Provider.of<ProgressProvider>(context, listen: false))
        .then((value) => context.go("/export/done", extra: value));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(builder: (context, provider, child) {
      var progress = provider.progress / provider.total;
      if (progress.isNaN) {
        progress = 0.0;
      }
      log(progress.toString());
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(AppLocalizations.of(context)!.exportToWhatsApp),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CupertinoActivityIndicator(),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 10),
              Text(widget.sn, style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 5),
              Text(provider.title)
            ])),
          ));
    });
  }
}
