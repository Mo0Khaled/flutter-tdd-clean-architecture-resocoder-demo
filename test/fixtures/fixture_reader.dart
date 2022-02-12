import 'dart:io';

String fixture(String fileName) => File('test/fixtures/$fileName.json').readAsStringSync();