import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

const int _kMaxDimension = 1600;
const int _kJpegQuality = 85;

/// Kart görselleri upload öncesi §9 kuralına göre işlenir: max 1600px'e
/// ölçeklenir ve JPEG %85 sıkıştırılır. [highAccuracy] açıkken atlanır.
Future<File> compressForUpload(File file, {required bool highAccuracy}) async {
  if (highAccuracy) return file;

  final bytes = await file.readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return file;

  final needsResize = decoded.width > _kMaxDimension || decoded.height > _kMaxDimension;
  final resized = needsResize
      ? img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? _kMaxDimension : null,
          height: decoded.height > decoded.width ? _kMaxDimension : null,
        )
      : decoded;

  final dir = await getTemporaryDirectory();
  final out = File('${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await out.writeAsBytes(img.encodeJpg(resized, quality: _kJpegQuality));
  return out;
}
