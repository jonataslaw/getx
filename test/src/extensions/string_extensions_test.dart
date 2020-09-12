import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  group('Test group for extension: isNullOrBlank', () {
    String testString;
    test('String extension: isNullOrBlank', () {
      expect(testString.isNullOrBlank, equals(true));
    });
    test('String extension: isNullOrBlank', () {
      testString = 'Not null anymore';
      expect(testString.isNullOrBlank, equals(false));
    });
    test('String extension: isNullOrBlank', () {
      testString = '';
      expect(testString.isNullOrBlank, equals(true));
    });
  });

  group('String extensions', () {
    var text = "oi";
    var digit = "5";
    var specialCaracters = "#\$!%@";
    var alphaNumeric = "123asd";
    var numbers = "123";
    var letters = "foo";
    String notInitializedVar;

    test('var.isNum', () {
      expect(digit.isNum, true);
      expect(text.isNum, false);
    });

    test('var.isNumericOnly', () {
      expect(numbers.isNumericOnly, true);
      expect(letters.isNumericOnly, false);
      expect(specialCaracters.isNumericOnly, false);
      expect(alphaNumeric.isNumericOnly, false);
    });

    test('var.isAlphabetOnly', () {
      expect(alphaNumeric.isAlphabetOnly, false);
      expect(numbers.isAlphabetOnly, false);
      expect(letters.isAlphabetOnly, true);
    });

    test('var.isBool', () {
      var trueString = 'true';
      expect(notInitializedVar.isBool, false);
      expect(letters.isBool, false);
      expect(trueString.isBool, true);
    });

    test('var.isVectorFileName', () {
      var path = "logo.svg";
      var fullPath = "C:/Users/Getx/Documents/logo.svg";
      expect(path.isVectorFileName, true);
      expect(fullPath.isVectorFileName, true);
      expect(alphaNumeric.isVectorFileName, false);
    });

    test('var.isImageFileName', () {
      var jpgPath = "logo.jpg";
      var jpegPath = "logo.jpeg";
      var pngPath = "logo.png";
      var gifPath = "logo.gif";
      var bmpPath = "logo.bmp";
      var svgPath = "logo.svg";

      expect(jpgPath.isImageFileName, true);
      expect(jpegPath.isImageFileName, true);
      expect(pngPath.isImageFileName, true);
      expect(gifPath.isImageFileName, true);
      expect(bmpPath.isImageFileName, true);
      expect(svgPath.isImageFileName, false);
    });

    test('var.isAudioFileName', () {
      var mp3Path = "logo.mp3";
      var wavPath = "logo.wav";
      var wmaPath = "logo.wma";
      var amrPath = "logo.amr";
      var oggPath = "logo.ogg";
      var svgPath = "logo.svg";

      expect(mp3Path.isAudioFileName, true);
      expect(wavPath.isAudioFileName, true);
      expect(wmaPath.isAudioFileName, true);
      expect(amrPath.isAudioFileName, true);
      expect(oggPath.isAudioFileName, true);
      expect(svgPath.isAudioFileName, false);
    });

    test('var.isVideoFileName', () {
      var mp4Path = "logo.mp4";
      var aviPath = "logo.avi";
      var wmvPath = "logo.wmv";
      var rmvbPath = "logo.rmvb";
      var mpgPath = "logo.mpg";
      var mpegPath = "logo.mpeg";
      var threegpPath = "logo.3gp";
      var svgPath = "logo.svg";

      expect(mp4Path.isVideoFileName, true);
      expect(aviPath.isVideoFileName, true);
      expect(wmvPath.isVideoFileName, true);
      expect(rmvbPath.isVideoFileName, true);
      expect(mpgPath.isVideoFileName, true);
      expect(mpegPath.isVideoFileName, true);
      expect(threegpPath.isVideoFileName, true);
      expect(svgPath.isAudioFileName, false);
    });
  });
}
