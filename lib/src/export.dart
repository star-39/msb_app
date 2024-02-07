import 'dart:convert';
import 'dart:io';

import 'package:msb_app/src/pages/export_page.dart';
import 'package:msb_app/src/settings.dart';
import 'package:msb_app/src/util.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/iterables.dart';
// import 'package:whatsapp_stickers/exceptions.dart';
// import 'package:whatsapp_stickers/whatsapp_stickers.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'define.dart';

/*
type webappStickerObject struct {
    //Sticker index with offset of +1
    Id int `json:"id"`
    //Sticker emojis.
    Emoji string `json:"emoji"`
    //Sticker emoji changed on front-end.
    EmojiChanged bool `json:"emoji_changed"`
    //Sticker file path on server.
    FilePath string `json:"file_path"`
    //Sticker file ID
    FileID string `json:"file_id"`
    //Sticker unique ID
    UniqueID string `json:"unique_id"`
    //URL of sticker image.
    Surl string `json:"surl"`
    //StickerSet Name
    SSName string `json:"ssname"`
}
*/

class StickerResult {
  final StickerExport? se;
  final String? ssname;
  final String? sstitle;
  final Exception? err;
  final int? packs;

  const StickerResult({this.ssname, this.sstitle, this.err, this.packs, this.se});
}

class StickerSet {
  final String ssname;
  final String sstitle;
  final String ssthumb;
  final bool animated;
  final List<StickerObject> ss;

  const StickerSet(
      {required this.ssname, required this.sstitle, required this.ssthumb, required this.animated, required this.ss});

  factory StickerSet.fromJson(Map<String, dynamic> json) {
    return StickerSet(
        ssname: json['ssname'] as String,
        sstitle: json['sstitle'] as String,
        ssthumb: json['ssthumb'] as String,
        animated: json['animated'] as bool,
        ss: json['ss'].map<StickerObject>((data) => StickerObject.fromJson(data)).toList());
  }
}

class StickerObject {
  final int id;
  final String emoji;
  final String surl;
  const StickerObject({required this.id, required this.emoji, required this.surl});

  factory StickerObject.fromJson(Map<String, dynamic> json) {
    return StickerObject(id: json['id'] as int, emoji: json['emoji'] as String, surl: json['surl'] as String);
  }
}

class StickerExportObject {
  final String file;
  final String surl;
  final String emoji;
  const StickerExportObject({required this.file, required this.surl, required this.emoji});
}

class StickerExport {
  final String sn;
  final String qid;
  final String hex;
  final String dn;

  final dio = Dio();
  final ssFiles = <String>[];
  final queue = <Future>[];

  late Directory docDir;
  late Directory ssDir;

  int amount = 0;
  StickerSet? wss;
  Exception? err;
  List<List<List<String>>> stickerPacks = [
    [[]]
  ];

  StickerExport({required this.sn, required this.qid, required this.hex, required this.dn}) {
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 3,
      retryableExtraStatuses: {status404NotFound},
      retryDelays: const [
        Duration(seconds: 2),
        Duration(seconds: 3),
        Duration(seconds: 3),
      ],
    ));
  }

  Future<void> fetchStickerList() async {
    final res = await Dio().get('https://$dn/webpp/api/ss?sn=$sn&qid=$qid&hex=$hex&cmd=export');
    final Map<String, dynamic> wssMap = jsonDecode(res.data);
    wss = StickerSet.fromJson(wssMap);
  }

  Future<void> downloadStickers(String targetDir, ProgressProvider provider) async {
    await dio.download(wss!.ssthumb, path.join(targetDir, "thumb.png"));
    for (var s in wss!.ss) {
      final f = "${s.id.toString().padLeft(3, "0")}.webp";
      ssFiles.add(path.join(targetDir, f));
      queue.add(dio.download(s.surl, path.join(targetDir, f)).then((res) => provider.progress++));
    }
    await Future.wait(queue);
  }

  Future<StickerExport> installFromRemote(ProgressProvider provider) async {
    try {
      await fetchStickerList();
      provider.title = wss!.sstitle;
      provider.total = wss!.ss.length;

      docDir = await getApplicationDocumentsDirectory();
      ssDir = Directory(path.join(docDir.path, 'stickers'));
      if (ssDir.existsSync()) {
        await ssDir.delete(recursive: true);
      } else {
        await ssDir.create(recursive: true);
      }

      await downloadStickers(ssDir.path, provider);
    } on Exception catch (e) {
      err = e;
      return this;
    }

    try {
      generateStickerPacks();
      if (stickerPacks.length == 1) {
        sendToWhatsApp(0);
      }
    } on Exception catch (e) {
      err = e;
      return this;
    }
    return this;
  }

  void generateStickerPacks() {
    List<List<String>> stickers = [];

    wss!.ss.asMap().forEach((i, s) {
      var ss = <String>[];
      if (File(ssFiles[i]).lengthSync() < 500 * 1024) {
        ss.add(WhatsappStickerImage.fromFile(ssFiles[i]).path);
        ss.add(s.emoji);
        stickers.add(ss);
        amount++;
      }
    });

    stickerPacks = partition(stickers, 30).toList();
  }

  void sendToWhatsApp(int packIndex) async {
    final publisher = await getPublisher();
    final identifier = "${wss!.ssname}_${secHex(4)}";
    try {
      var handler = WhatsappStickersExporter();
      await handler.addStickerPack(
          identifier,
          wss!.sstitle,
          publisher,
          WhatsappStickerImage.fromFile(path.join(ssDir.path, "thumb.png")).path,
          '',
          '',
          '',
          wss!.animated,
          stickerPacks[packIndex]);
    } catch (e) {
      rethrow;
    }
  }
}
