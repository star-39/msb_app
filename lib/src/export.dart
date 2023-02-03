import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:msb_app/src/settings.dart';
import 'package:msb_app/src/util.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/iterables.dart';
// import 'package:whatsapp_stickers/exceptions.dart';
// import 'package:whatsapp_stickers/whatsapp_stickers.dart';
import 'package:whatsapp_stickers_exporter/exceptions.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

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
class StickerSet {
  final String ssname;
  final String sstitle;
  final String ssthumb;
  final bool animated;
  final List<StickerObject> ss;

  const StickerSet(
      {required this.ssname,
      required this.sstitle,
      required this.ssthumb,
      required this.animated,
      required this.ss});

  factory StickerSet.fromJson(Map<String, dynamic> json) {
    return StickerSet(
        ssname: json['ssname'] as String,
        sstitle: json['sstitle'] as String,
        ssthumb: json['ssthumb'] as String,
        animated: json['animated'] as bool,
        ss: json['ss']
            .map<StickerObject>((data) => StickerObject.fromJson(data))
            .toList());
  }
}

class StickerObject {
  final int id;
  final String emoji;
  final String surl;
  const StickerObject(
      {required this.id, required this.emoji, required this.surl});

  factory StickerObject.fromJson(Map<String, dynamic> json) {
    return StickerObject(
        id: json['id'] as int,
        emoji: json['emoji'] as String,
        surl: json['surl'] as String);
  }
}

class StickerExportObject {
  final String file;
  final String surl;
  final String emoji;
  const StickerExportObject(
      {required this.file, required this.surl, required this.emoji});
}

class StickerExport {
  final Uri link;
  late StickerSet wss;
  late Directory docDir;
  late Directory ssDir;
  late List<String> ssFiles;
  List<List<List<String>>> stickerPacks = [
    [[]]
  ];

  StickerExport({required this.link});

  void fetchStickerList(Uri uri) async {
    var res = await Dio().getUri(uri);
    final Map<String, dynamic> wssMap = jsonDecode(res.data);
    wss = StickerSet.fromJson(wssMap);
  }

  downloadStickers(StickerSet wss, String targetDir) async {
    final dio = Dio();
    final downloads = <Future>[];
    ssFiles = <String>[];

    downloads.add(dio.download(wss.ssthumb, path.join(targetDir, "thumb.png")));
    for (var s in wss.ss) {
      //padLeft3
      //001 002 003 ... 120 .webp
      final f = "${s.id.toString().padLeft(3, "0")}.webp";
      ssFiles.add(path.join(targetDir, f));
      downloads.add(dio.download(s.surl, path.join(targetDir, f)));
    }

    await Future.wait(downloads);
  }

  Future<int> installFromRemote() async {
    try {
      fetchStickerList(this.link);
      docDir = await getApplicationDocumentsDirectory();
      ssDir = Directory(path.join(docDir.path, 'stickers'));
      if (ssDir.existsSync()) {
        await ssDir.delete(recursive: true);
        log("purged stickers dir");
      } else {
        await ssDir.create(recursive: true);
      }
    } catch (e) {
      return -1;
    }

    // Retry download for 5 times max.
    for (var i = 0; i < 5; i++) {
      try {
        await downloadStickers(wss, ssDir.path);
        // if no Exception, break retry loop.
        break;
      } catch (e) {
        if (i == 4) {
          rethrow;
        } else {
          // wait and retry
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
      }
    }

    generateStickerPacks();
    if (stickerPacks.length == 1) {
      sendToWhatsApp(0);
    } else {
      return stickerPacks.length;
    }
    return 0;
  }

  void generateStickerPacks() {
    List<List<String>> stickers = [];

    wss.ss.asMap().forEach((i, s) {
      var ss = <String>[];
      ss.add(WhatsappStickerImage.fromFile(ssFiles[i]).path);
      ss.add(s.emoji);
      stickers.add(ss);
    });

    stickerPacks = partition(stickers, 30).toList();
  }

  void sendToWhatsApp(int packIndex) async {
    final publisher = await getPublisher();
    final identifier = "${wss.ssname}_${secHex(4)}";
    try {
      var handler = WhatsappStickersExporter();
      await handler.addStickerPack(
          identifier,
          wss.sstitle,
          publisher,
          WhatsappStickerImage.fromFile(path.join(ssDir.path, "thumb.png"))
              .path,
          '',
          '',
          '',
          wss.animated,
          stickerPacks[packIndex]);
    } catch (e) {
      rethrow;
    }
  }
}
