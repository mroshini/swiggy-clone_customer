import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadImageUrl(String imageUrl) async {
  File fileName;
  var documentDirectory = await getApplicationDocumentsDirectory();
  // var checkFile = await File('${documentDirectory.path}/$imageName').exists();
  var response = await get(imageUrl);

  File file = new File(join(documentDirectory.path, 'imagetest.png'));

  file.writeAsBytesSync(response.bodyBytes);

  return fileName;
}

_asyncMethod() async {
  //comment out the next two lines to prevent the device from getting
  // the image from the web in order to prove that the picture is
  // coming from the device instead of the web.
  var url =
      "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
  var response = await get(url); // <--2
  var documentDirectory = await getApplicationDocumentsDirectory();
  var firstPath = documentDirectory.path + "/images";
  var filePathAndName = documentDirectory.path + '/images/pic.jpg';
  //comment out the next three lines to prevent the image from being saved
  //to the device to show that it's coming from the internet
  await Directory(firstPath).create(recursive: true); // <-- 1
  File file2 = new File(filePathAndName); // <-- 2
  file2.writeAsBytesSync(response.bodyBytes); // <-- 3
}
