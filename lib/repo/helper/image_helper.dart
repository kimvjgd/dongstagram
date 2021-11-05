import 'dart:io';
import 'package:image/image.dart';

File getResizedImage(File originImage) {
  Image? image = decodeImage(originImage.readAsBytesSync());     // byte파일로 변경후 square로 변환 png-> jpg로 변환 후  파일로 저장
  Image resizedImage = copyResizeCropSquare(image!, 300);       // size를 300으로

  File resizedFile = File(originImage.path.substring(0, originImage.path.length-3)+"jpg");      //처음0부터 오른쪽 끝 3번째까지
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50));     // quality를 50% 로 줄임
  return resizedFile;
}