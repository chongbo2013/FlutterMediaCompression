import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MediaCompression/MediaCompression.dart';

void main() {
  const MethodChannel channel = MethodChannel('MediaCompression');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MediaCompression.platformVersion, '42');
  });
}
