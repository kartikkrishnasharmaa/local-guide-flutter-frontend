import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import '../main.dart';

class FileUtils {

  Future<void> saveBase64ToExcel(String base64Excel, String fileName, Function() callback) async {
    List<int> byteData = base64.decode(base64Excel);
    Excel excel = Excel.decodeBytes(byteData);
    if(kIsWeb) {
      var excelData = excel.encode();
      var excelBytes = Uint8List.fromList(excelData!);
      // Create a blob from byte array
      var blob = html.Blob([excelBytes]);
      var url = html.Url.createObjectUrlFromBlob(blob);
      var link = html.AnchorElement(href: url)
        ..setAttribute("download", "$fileName.xlsx")
        ..style.display = 'none';
      html.document.body?.children.add(link);
      link.click();
      html.Url.revokeObjectUrl(url);
      callback();
    } else {
      String downloadsPath = "/storage/emulated/0/Downloads";
      $logger.log(message: "message >>>>>>>>>>>>>>>>>  $downloadsPath");
      String filePath = '$downloadsPath/excel.xlsx';
      var file = File(filePath);
      var exists = await file.exists();
      if(!exists) await file.create();
      await file.writeAsBytes(excel.encode()!);
      callback();
    }
  }

}