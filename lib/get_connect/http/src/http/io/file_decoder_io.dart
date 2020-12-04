import 'dart:io';

List<int> fileToBytes(dynamic data) {
  if (data is File) {
    return data.readAsBytesSync();
  } else if (data is String) {
    if (File(data).existsSync()) {
      return File(data).readAsBytesSync();
    } else {
      throw 'File [data] not exists';
    }
  } else if (data is List<int>) {
    return data;
  } else {
    throw FormatException('File is not [File] or [String] or [List<int>]');
  }
}

void writeOnFile(List<int> bytes) {}
