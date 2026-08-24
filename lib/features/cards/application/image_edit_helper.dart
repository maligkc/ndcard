import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<Uint8List> downloadBytes(String url) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateBytes(response);
    return bytes;
  } finally {
    client.close();
  }
}

Future<Uint8List> consolidateBytes(HttpClientResponse response) async {
  final builder = BytesBuilder();
  await for (final chunk in response) {
    builder.add(chunk);
  }
  return builder.toBytes();
}

/// Uzak bir görüntüyü indirip yerel geçici bir dosyaya yazar (image_cropper
/// gibi yalnızca yerel dosya yolu kabul eden araçlarla kullanmak için).
Future<File> downloadToTempFile(String url, String fileName) async {
  final bytes = await downloadBytes(url);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file;
}

/// Görüntüyü 90 derece saat yönünde döndürüp yeni bir geçici dosyaya yazar.
Future<File> rotateImage(File source) async {
  final bytes = await source.readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return source;
  final rotated = img.copyRotate(decoded, angle: 90);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await file.writeAsBytes(img.encodeJpg(rotated, quality: 90));
  return file;
}
