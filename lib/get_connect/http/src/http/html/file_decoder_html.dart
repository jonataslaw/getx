// import 'dart:html' as html;

List<int> fileToBytes(dynamic data) {
  if (data is List<int>) {
    return data;
  } else {
    throw const FormatException(
        'File is not "File" or "String" or "List<int>"');
  }
}

// void writeOnFile(List<int> bytes) {
//   var blob = html.Blob(["data"], 'text/plain', 'native');
//   var anchorElement = html.AnchorElement(
//     href: html.Url.createObjectUrlFromBlob(blob).toString(),
//   )
//     ..setAttribute("download", "data.txt")
//     ..click();
// }
