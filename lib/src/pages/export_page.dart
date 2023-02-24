import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:msb_app/src/settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import '../define.dart';
import '../util.dart';
import '../export.dart';

StickerExport? se;

class ProgressProvider with ChangeNotifier {
  int _progress = 0;
  int _total = 0;
  int get progress => _progress;
  int get total => _total;

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
  const ExportStickerPage(
      {super.key, required this.sn, required this.qid, required this.hex});

  @override
  State<ExportStickerPage> createState() => _ExportStickerPage();
}

class _ExportStickerPage extends State<ExportStickerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final uri = _genExportLink();
      se = StickerExport(link: uri);
      se?.installFromRemote(context);
    });
  }

  Uri _genExportLink() {
    var link =
        '$webappUrl/api/ss?sn=${widget.sn}&qid=${widget.qid}&hex=${widget.hex}&cmd=export';
    return Uri.parse(link);
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
          navigationBar: const CupertinoNavigationBar(
            middle: Text("Export to WhatsApp"),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const CupertinoActivityIndicator(),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 10),
                  Text('sn: ${widget.sn}'),
                  const SizedBox(height: 10),
                  Text('qid: ${widget.qid}')
                ])),
          ));
    });
  }
}
