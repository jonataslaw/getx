import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  group('String extensions', () {
    final text = "oi";
    final digit = "5";
    final specialCaracters = "#\$!%@";
    final alphaNumeric = "123asd";
    final numbers = "123";
    final letters = "foo";
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
      final trueString = 'true';
      expect(notInitializedVar.isBool, false);
      expect(letters.isBool, false);
      expect(trueString.isBool, true);
    });

    test('var.isVectorFileName', () {
      final path = "logo.svg";
      final fullPath = "C:/Users/Getx/Documents/logo.svg";
      expect(path.isVectorFileName, true);
      expect(fullPath.isVectorFileName, true);
      expect(alphaNumeric.isVectorFileName, false);
    });

    test('var.isImageFileName', () {
      final jpgPath = "logo.jpg";
      final jpegPath = "logo.jpeg";
      final pngPath = "logo.png";
      final gifPath = "logo.gif";
      final bmpPath = "logo.bmp";
      final svgPath = "logo.svg";

      expect(jpgPath.isImageFileName, true);
      expect(jpegPath.isImageFileName, true);
      expect(pngPath.isImageFileName, true);
      expect(gifPath.isImageFileName, true);
      expect(bmpPath.isImageFileName, true);
      expect(svgPath.isImageFileName, false);
    });

    test('var.isAudioFileName', () {
      final mp3Path = "logo.mp3";
      final wavPath = "logo.wav";
      final wmaPath = "logo.wma";
      final amrPath = "logo.amr";
      final oggPath = "logo.ogg";
      final svgPath = "logo.svg";

      expect(mp3Path.isAudioFileName, true);
      expect(wavPath.isAudioFileName, true);
      expect(wmaPath.isAudioFileName, true);
      expect(amrPath.isAudioFileName, true);
      expect(oggPath.isAudioFileName, true);
      expect(svgPath.isAudioFileName, false);
    });

    test('var.isVideoFileName', () {
      final mp4Path = "logo.mp4";
      final aviPath = "logo.avi";
      final wmvPath = "logo.wmv";
      final rmvbPath = "logo.rmvb";
      final mpgPath = "logo.mpg";
      final mpegPath = "logo.mpeg";
      final threegpPath = "logo.3gp";
      final svgPath = "logo.svg";

      expect(mp4Path.isVideoFileName, true);
      expect(aviPath.isVideoFileName, true);
      expect(wmvPath.isVideoFileName, true);
      expect(rmvbPath.isVideoFileName, true);
      expect(mpgPath.isVideoFileName, true);
      expect(mpegPath.isVideoFileName, true);
      expect(threegpPath.isVideoFileName, true);
      expect(svgPath.isAudioFileName, false);
    });

    test('var.isTxtFileName', () {
      const txtPath = 'file.txt';
      expect(txtPath.isTxtFileName, true);
      expect(alphaNumeric.isTxtFileName, false);
    });

    test('var.isDocumentFileName', () {
      final docPath = "file.doc";
      final docxPath = "file.docx";

      expect(docPath.isDocumentFileName, true);
      expect(docxPath.isDocumentFileName, true);
      expect(alphaNumeric.isDocumentFileName, false);
    });

    test('var.isExcelFileName', () {
      final xlsPath = "file.xls";
      final xlsxPath = "file.xlsx";

      expect(xlsPath.isExcelFileName, true);
      expect(xlsxPath.isExcelFileName, true);
      expect(alphaNumeric.isExcelFileName, false);
    });

    test('var.isPPTFileName', () {
      final pptPath = "file.ppt";
      final pptxPath = "file.pptx";

      expect(pptPath.isPPTFileName, true);
      expect(pptxPath.isPPTFileName, true);
      expect(alphaNumeric.isPPTFileName, false);
    });

    test('var.isAPKFileName', () {
      final apkPath = "file.apk";

      expect(apkPath.isAPKFileName, true);
      expect(alphaNumeric.isAPKFileName, false);
    });

    test('var.isPDFFileName', () {
      final pdfPath = "file.pdf";

      expect(pdfPath.isPDFFileName, true);
      expect(alphaNumeric.isPDFFileName, false);
    });
    test('var.isHTMLFileName', () {
      final htmlPath = "file.html";

      expect(htmlPath.isHTMLFileName, true);
      expect(alphaNumeric.isHTMLFileName, false);
    });
    test('var.isURL', () {
      // Url's generated in https://www.randomlists.com/urls
      final urls = [
        'http://www.example.com/aunt/babies.aspx#act',
        'http://adjustment.example.com/bedroom/animal.htm',
        'http://blade.example.com/arch/basketball',
        'https://www.example.com/air/advice.php',
        'http://www.example.com/balance/arch.html?blow=aftermath&bait=bath',
        'http://authority.example.com/',
        'http://example.com/advice.html',
        'https://www.example.com/',
        'https://www.example.com/bee?act=art&bells=board',
        'http://example.org/',
        'https://www.example.com/',
        'https://example.com/bed',
        'https://www.example.edu/acoustics',
        'https://www.example.com/bells',
        'http://board.example.com/',
        'http://book.example.com/afterthought?advertisement=ball&birth=argument',
        'http://birds.example.org/ball.aspx?apparatus=border&brother=aftermath',
        'https://www.example.org/books/book?bedroom=birds',
        'http://advice.example.com/',
        'http://example.com/',
        'http://example.com/bedroom/alarm',
        'https://example.com/advice/approval',
        'http://anger.example.net/?breath=brother&air=bell#ball',
        'http://appliance.example.com/bee/badge',
        'http://www.example.org/berry.aspx',
        'http://example.org/',
      ];

      for (final url in urls) {
        expect(url.isURL, true);
      }
      expect(alphaNumeric.isURL, false);
    });
    test('var.isEmail', () {
      final emails = [
        'hellfire@comcast.net',
        'hllam@icloud.com',
        'tskirvin@live.com',
        'choset@comcast.net',
        'parksh@live.com',
        'kassiesa@yahoo.com',
        'kramulous@comcast.net',
        'froodian@me.com',
        'shawnce@yahoo.ca',
        'cgreuter@gmail.com',
        'aprakash@verizon.net',
        'dhrakar@gmail.com',
        'wmszeliga@yahoo.ca',
        'bmorrow@icloud.com',
        'seurat@comcast.net',
        'dialworld@yahoo.ca',
        'johndo@yahoo.ca',
        'empathy@yahoo.com.pt',
        'openldap@verizon.net',
        'elflord@outlook.com',
        'kaiser@me.com',
        'carcus@att.net',
        'garland@hotmail.com',
        'clkao@yahoo.ca',
        'daveed@mac.com',
        'parasite@icloud.com',
        'drolsky@aol.com',
        'reziac@outlook.com',
        'storerm@yahoo.ca',
        'johnbob@hotmail.com.br',
      ];

      for (final email in emails) {
        expect(email.isEmail, true);
      }
      expect(alphaNumeric.isEmail, false);
    });
    test('var.isPhoneNumber', () {
      final phoneNumbers = [
        '+1202-555-0145',
        '+1202-555-0139',
        '+1202-555-0101',
        '+1202-555-0136',
        '+1202-555-0190',
        '+1202-555-0156',
        '(738) 952-5253',
        '(861) 965-1597',
        '(732) 372-9760',
        '(532) 766-4719',
        '(987) 472-7813',
        '(455) 443-8171',
        '(915) 685-8658',
        '(572) 207-1898',

        // TODO those are failing, but they shouldn't
        // '(81) 6 2499-9538',
        // '(31) 32304-4263',
        // '(64) 25242-6375',
        // '(41) 19308-7925',
        // '(67) 61684-0395',
        // '(60) 54706-3569',
        '(31) 33110055',
        '(11) 3344-5599',
        '(31) 977447788',
        '(31) 66557744',
        '(21) 946576541',
        '(11) 3432-3333',
        '02131973585858'
      ];

      for (final phone in phoneNumbers) {
        // print('testing $phone');
        expect(phone.isPhoneNumber, true);
      }

      final bigRandomNumber = '168468468465241327987624987327987';
      expect(bigRandomNumber.isPhoneNumber, false);

      expect(alphaNumeric.isPhoneNumber, false);
    });
    test('var.isDateTime', () {
      final dateTimes = [
        '2003-07-05 05:51:47.000Z',
        '1991-05-11 11:57:30.000Z',
        '2002-01-04 10:00:41.000Z',
        '1995-11-04 19:43:25.000Z',
        '2006-07-12 20:06:46.000Z',
        '2000-08-10 00:06:23.000Z',
        '1998-07-31 10:56:50.000Z',
        '1995-04-27 11:49:34.000Z',
        '1998-07-26 15:43:11.000Z',
        '1999-02-04 10:03:01.000Z',
        '1998-05-02 12:17:55.000Z',
        '2013-05-26 10:47:22.000Z',
        '1991-07-07 20:25:42.000Z',
        '2018-11-03 09:27:38.000Z',
        '1992-12-22 08:20:26.000Z',
        '1997-07-01 23:11:59.000Z',
        '2012-04-13 16:00:04.000Z',
        '1997-01-06 18:37:51.000Z',
        '2008-08-23 11:11:29.000Z',
        '1996-02-06 03:46:43.000Z',
        '2016-01-03 10:57:15.000Z',
        '2014-04-16 17:20:50.000Z',
        '1994-07-13 03:55:16.000Z',
        '2004-11-15 03:45:11.000Z',
        '2007-12-18 18:21:21.000Z',
        '1995-01-31 03:55:44.000Z',
        '2013-08-09 04:48:37.000Z',
        '2001-09-07 17:13:55.000Z',
        '1993-06-18 13:21:21.000Z',
        '1991-02-06 03:05:47.000Z',
        '2000-09-22 18:48:55.000Z',
        '2000-06-01 02:13:57.000Z',
        '1991-08-07 21:08:35.000Z',
        '1998-08-15 07:27:12.000Z',
        '2002-07-03 10:34:25.000Z',
        '2013-10-05 00:37:45.000Z',
        '2012-09-10 20:07:21.000Z',
        '2017-06-18 14:38:06.000Z',
        '2000-03-09 11:27:49.000Z',
        '2016-01-16 22:01:20.000Z',
      ];

      for (final dateTime in dateTimes) {
        // print('testing $dateTime');
        expect(dateTime.isDateTime, true);
      }
      expect(alphaNumeric.isDateTime, false);
    });
    test('var.isMD5', () {
      final md5s = [
        '176cfa006065a2a2bd8d3f1f83531b64',
        '713fca6d088132e863497a79d1bd9572',
        '7decc2fb2aca5cbd8a2cae5de1b50edb',
        '85ed9bc4e4a8ae65add67886f5dfe02f',
        'e4f0097f84a11f0298c83ecf6aa0fec3',
        '70a2712b47127b431d7119b3a511b145',
        'dd54069e3f97787e79592f6e3a307e93',
        '5b64677b69da7370ee69523281ce935c',
        '6150ce23f4b071e1cde49021b57c5a17',
        '2781566b09a84a695297482cdcb1ffd0',
        '54fe4ce16862aac01768b5831390d557',
        '2747268afaa9898a320b8cc5580f143e',
        'ce3c2d105fb2740c5bf59347b47603a8',
        'cccef3bbc8cd2530c6de78af586ebcee',
        '502115b10c767f50ab55270be095512e',
        'b084ea385e849eaedf4fefaf6dd5f1a9',
        '1f167339977225fe63a86388083fc64f',
        '6abd5f472dba5e4688ad6dd14f975870',
        '7e7f9ef53fb6e3ce2a4fb56665548eb8',
        'de134fce82421dd2b3fab751fbfa190d',
        'b0d8492572a52d1f2360535612c5dc82',
      ];

      for (final md5 in md5s) {
        expect(md5.isMD5, true);
      }

      expect(alphaNumeric.isMD5, false);
    });
    test('var.isSHA1', () {
      final sha1s = [
        '1A310CF5DC8CE513586F74EE19CE90BD4BCC5AED',
        'B458B077B5075C316CFD03619D627F529A0555BF',
        '902C6A2850B4348BE445D637689CCAE5C5EF3552',
        '8DC86C0DD0FD2960D62573AB142F90572A7421D5',
        '7E18C8EA5F05BB2F385A9E34657B8D439A83BF82',
        '3EC857A133E801C0B3198371C17C1A3A3D73DFE8',
        'E32590E41805BEFD524205DAE0A56F429DCCC4E7',
        '943A9164A126457203680B49F0309B5F15F0117E',
        'C5E1442484AF49A92E1CC51F95AE4E8305F49DB6',
        'B0C3B071F8ADBEE2222AA07ECFF51C3C040AA0A0',
        '722ED6929057BF801F29590C423A40F4EF8C710E',
        'F484FA4DC5EC1E063F0752112D9BF3B9763D6E41',
        '2A87522644011223A27FD62C87FA926A1838F271',
      ];

      for (final sha1 in sha1s) {
        expect(sha1.isSHA1, true);
      }

      expect(alphaNumeric.isSHA1, false);
    });
    test('var.isSHA256', () {
      final sha256s = [
        'FC694FFE78167EAE21EA4EBF072D8AB6ECF847162D1F65600BF019BA9805DB2D',
        '3B64F1C349B548E72688A8EEFFA2F418A62BA2E22CF5BD954B4B1912C963D7FA',
        'EF69D763148B8A222980BD164943F754937DF12771083889DDB69C18245C2904',
        '9896D3134156E546FFC003C2C9CFED88D46C2BC214B39CF21192EAAF875A7C0A',
        '2C70E9735D7DAB56427BAA09E6C63912BEAD9C7938F6B16C4954B78F46D1C3CF',
        '423E095C8074BC1C440D874D999C18025445CD39211D98362E827E55863DD0B2',
        '4FCDB44D5521663F713A5821DE9401D64D44050C2AF62EBA758B1D128AC4C279',
        'BD91C9BBC044C94C283D0DF3AA1E8CDBF1BF35BF325E8196BA15FCA5238A3A40',
        '7B9434447F3B1236221D40CB707D1909886CC9E8CA25EB18DCCFDC70F0A3AE9F',
        'FBD3A0B1C5F9906EF3BFB5EDD846F77BA252070E036EC1F4F57BDD912F02987D',
        'B8369EE116ADE797285DC973DDAA69433F255DC0AEEC7936378D4D08B2A7FDD2',
        '6B6FE6891A5DFCCF2900A2A1F513196827AF5A95AB2DE1590B878BEFCCF12603',
        'F2CB3614CD070450912EBEC399C63527D2A839C4E5BB2FE281BA1C5D5EA64257',
        '822805E8FA05909AD7D3D6DBFBB1AE61D7A3C70209DB2A37C415BD5E11764866',
        '40DAC792B52101BB1506AD880F0378EFACF46B019427A3D0E01DE2B09B06B6ED',
        'E765A129579AF2F31C681973844490F8EA146DA8ADC07671F9FB71F0FE10E296',
        '2B5B6DC7EF398D1420D23327295BCDCDDA8AAEDB7FE6C6129D1D31432B676CB7',
        '67F20826370162C472791055E10E44624D40E35F29E60592B239692836474323',
        'BD16B1ED024E353B5B2334201EC63C0B3E181F0DFD226A36825EF18F6A7D8D97',
        'AC98F969AA56810BE672C770BE30EF79F7F77AE6EFB2A90D56FA2AD5506D8BD7',
      ];

      for (final sha256 in sha256s) {
        expect(sha256.isSHA256, true);
      }

      expect(alphaNumeric.isSHA256, false);
    });
    test('var.isBinary', () {
      final binaries = [
        '00111100',
        '00001111',
        '10110110',
        '01101110',
        '01110101',
        '00010100',
        '11100010',
        '11000001',
        '11000110',
        '11011101',
        '10001101',
        '10101110',
        '11001110',
        '10001011',
        '11111101',
        '11010110',
        '11110011',
        '01111010',
        '11110011',
        '01000111',
      ];

      for (final binary in binaries) {
        expect(binary.isBinary, true);
      }

      expect(alphaNumeric.isBinary, false);
    });
    test('var.isIPv4', () {
      final ipv4s = [
        '155.162.247.250',
        '121.99.222.180',
        '142.197.183.237',
        '176.60.213.134',
        '12.190.123.58',
        '105.75.28.173',
        '121.120.116.138',
        '20.195.194.189',
        '234.171.207.97',
        '153.122.129.170',
        '224.226.28.80',
        '236.196.62.84',
        '122.71.160.46',
        '151.24.85.63',
        '37.109.242.32',
        '235.47.62.53',
        '151.1.242.190',
        '227.197.221.85',
        '12.118.136.231',
        '51.73.246.208',
      ];

      for (final ipv4 in ipv4s) {
        expect(ipv4.isIPv4, true);
      }

      expect(alphaNumeric.isIPv4, false);
    });
    test('var.isIPv6', () {
      final ipv6s = [
        'f856:62fc:9091:e649:e928:d771:f40c:1439',
        'b8d5:3f85:5ae5:c63a:6b5f:f7e6:ea6b:871d',
        '2f91:979a:90b0:55d1:40b7:3e6f:a210:598e',
        'd35d:49fc:fbe4:9841:e4d3:f006:b04b:e242',
        '2e0f:2912:e4e8:33d5:e833:0ac5:c73a:30b3',
        '6af9:878a:a80f:f520:fc2b:a05c:b0dd:b93f',
        '3329:1ce5:ab09:0120:945c:057b:ed4a:7869',
        'b77d:5523:2f1b:ff07:93a5:378f:a9c7:e2f2',
        'b669:64fa:1be7:af47:28fc:07f4:38bd:ae05',
        'aa77:1f7e:8539:a01a:706d:6f74:7fc3:8407',
        '16f9:9bcc:32d6:96de:5087:620b:c0c0:25cb',
        'baad:273f:7e63:29cd:c742:c1ed:d0f9:062d',
        'ae62:5b09:05fa:4611:5da9:a40a:f1ef:2a9d',
        '4d2a:353a:9f6b:2070:9605:ab97:92c0:7956',
        'bfcb:39f8:5119:458f:85fa:9e54:8c53:acd5',
        '0c1a:c6f3:06af:9588:23b4:e7fb:c307:febd',
        'ddaa:3c91:f554:dbe5:8447:9464:a9ae:2200',
        '8787:c939:5002:a4f6:19b2:6521:4cde:8111',
        'b515:5c17:6590:46dd:4ca8:1db3:a86c:e006',
        '1083:d492:f42e:2c99:f050:f67f:07c5:23f9',
      ];

      for (final ipv6 in ipv6s) {
        expect(ipv6.isIPv6, true);
      }

      expect(alphaNumeric.isIPv6, false);
    });
    test('var.isHexadecimal', () {
      final hexadecimals = [
        '#56E97B',
        '#597E2A',
        '#F45D5C',
        '#A350DC',
        '#2DA48E',
        '#98CB3C',
        '#F7DCD1',
        '#B1F9BE',
        '#D17855',
        '#6F35CB',
        '#DCBE21',
        '#4C2E46',
        '#145F3F',
        '#F9776D',
        '#62E9DC',
        '#2F1030',
        '#C4F888',
        '#8E6D85',
        '#8C64CE',
        '#4DFF4E',
      ];

      for (final hexadecimal in hexadecimals) {
        expect(hexadecimal.isHexadecimal, true);
      }

      expect(alphaNumeric.isHexadecimal, false);
    });
    test('var.isPalindrom', () {
      final palindroms = [
        'Anna',
        'Civic',
        'Kayak',
        'Level',
        'Madam',
        'Mom',
        'Noon',
        'Racecar',
        'Radar',
        'Redder',
        'Refer',
        'Repaper',
        'Don\'t nod.',
        'I did, did I?',
        'My gym',
        'Red rum, sir, is murder',
        'Step on no pets',
        'Top spot',
        'Was it a cat I saw?',
        'Eva, can I see bees in a cave?',
        'No lemon, no melon',
        'A base do teto desaba.',
        'A cara rajada da jararaca.',
        'Acuda cadela da Leda caduca.',
        'A dama admirou o rim da amada.',
        'A Daniela ama a lei? Nada!',

        // TODO make isPalindrom regex support UTF8 characters
        // 'Adias a data da saída.',
        // 'A diva em Argel alegra-me a vida.',
        // 'A droga do dote é todo da gorda.',
        // 'A gorda ama a droga.',
        // 'A grama é amarga.',
        // 'Aí, Lima falou: “Olá, família!”.',
        // 'anã',
        // 'anilina',
        // 'ata',
        // 'arara',
        // 'asa',
        // 'ele',
        // 'esse',
        // 'mamam',
        // 'matam',
        // 'metem',
        // 'mirim',
        // 'oco',
        // 'omissíssimo',
      ];
      for (final palindrom in palindroms) {
        // print("testing $palindrom");
        expect(palindrom.isPalindrom, true);
      }
      expect(alphaNumeric.isPalindrom, false);
    });
    test('var.isPassport', () {
      final passports = [
        '12ss46',
        'jdmg5dg',
        '5f7fj5d7',
        'w8a9s6f3z',
      ];

      for (final passport in passports) {
        expect(passport.isPassport, true);
      }

      expect(specialCaracters.isPassport, false);
    });

    test('var.isCurrency', () {
      final currencies = [
        'R\$50.58',
        '\$82.48',
        '\₩54.24',
        '\¥81.04',
        '\€4.06',
        '\₹37.40',
        '\₽18.12',
        'fr95.15',
        'R81.04',
        '9.35USD',
        '98.48AUD',
        '29.20NZD',
        '50.58CAD',
        '82.48CHF',
        '54.24GBP',
        '81.04CNY',
        '4.06EUR',
        '37.40JPY',
        '18.12IDR',
        '95.15MXN',
        '81.04NOK',
        '9.35KRW',
        '98.48TRY',
        '29.20INR',
      ];

      for (final currency in currencies) {
        // print('currency $currency');
        expect(currency.isCurrency, true);
      }

      expect(specialCaracters.isCurrency, false);
    });

    test('var.isCpf', () {
      final cpfs = [
        '370.559.380-31',
        '055.878.430-50',
        '655.232.870-24',
        '86497047000',
        '12341309046',
        '31496294033',
      ];

      for (final cpf in cpfs) {
        expect(cpf.isCpf, true);
      }

      expect(specialCaracters.isCpf, false);
    });
    test('var.isCnpj', () {
      final cnpjs = [
        '11.066.893/0001-94',
        '21.883.660/0001-38',
        '59.705.218/0001-94',
      ];

      for (final cnpj in cnpjs) {
        expect(cnpj.isCnpj, true);
      }

      expect(specialCaracters.isCnpj, false);
    });

    test('var.isCaseInsensitiveContains(string)', () {
      final phrase = 'Back to Square One';

      expect(phrase.isCaseInsensitiveContains('to'), true);
      expect(phrase.isCaseInsensitiveContains('square'), true);
      expect(phrase.isCaseInsensitiveContains('On'), true);
      expect(phrase.isCaseInsensitiveContains('foo'), false);
    });

    test('var.isCaseInsensitiveContainsAny(string)', () {
      final phrase = 'Back to Square One';

      expect(phrase.isCaseInsensitiveContainsAny('to'), true);
      expect(phrase.isCaseInsensitiveContainsAny('square'), true);
      expect(phrase.isCaseInsensitiveContainsAny('On'), true);
      expect(phrase.isCaseInsensitiveContainsAny('foo'), false);
      expect('to'.isCaseInsensitiveContainsAny(phrase), true);
      expect('square'.isCaseInsensitiveContainsAny('qu'), true);
    });

    test('var.capitalize', () {
      expect('foo bar'.capitalize, 'Foo Bar');
      expect('FoO bAr'.capitalize, 'Foo Bar');
      expect('FOO BAR'.capitalize, 'Foo Bar');
      expect(''.capitalize, null);
    });

    test('var.capitalizeFirst', () {
      expect('foo bar'.capitalizeFirst, 'Foo bar');
      expect('FoO bAr'.capitalizeFirst, 'Foo bar');
      expect('FOO BAR'.capitalizeFirst, 'Foo bar');
      expect(''.capitalizeFirst, null);
    });

    test('var.removeAllWhitespace', () {
      expect('foo bar'.removeAllWhitespace, 'foobar');
      expect('foo'.removeAllWhitespace, 'foo');
      expect(''.removeAllWhitespace, null);
    });

    test('var.camelCase', () {
      expect('foo bar'.camelCase, 'fooBar');
      expect('the fox jumped in the water'.camelCase, 'theFoxJumpedInTheWater');
      expect(''.camelCase, null);
    });

    test('var.numericOnly()', () {
      expect('date: 2020/09/13, time: 00:00'.numericOnly(), '202009130000');
      expect(
        'and 1, and 2, and 1 2 3'.numericOnly(),
        '12123',
      );
      expect(''.numericOnly(), '');
    });
  });
}
