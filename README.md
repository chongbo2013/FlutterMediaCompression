<!-- Copyright (c) 2020 ferrisxu -->

# flutter video or image compress

Generate a new path by compressed video or image.   
Easy to deal with compressed video or images.   
Android image compression using luban  
video compression using Mediacodec.  
IOS image compression using luban  
video compression using AVAssetExportSession.

<p align="left">
  <a href="https://pub.dartlang.org/packages/MediaCompression"><img alt="pub version" src="https://img.shields.io/pub/v/MediaCompression.svg"></a>
  <img alt="license" src="https://img.shields.io/github/license/TenkaiRuri/MediaCompression.svg">
  <img alt="android min Sdk Version" src="https://img.shields.io/badge/android-16-success.svg?logo=android">
  <img alt="ios min target" src="https://img.shields.io/badge/ios-8-lightgrey.svg?logo=apple">
</p>



## Usage

**Installing**
add [MediaCompression](https://pub.dartlang.org/packages/MediaCompression) as a dependency in your pubspec.yaml file.
```yaml
dependencies:
  MediaCompression: ^0.01
```


**Get image compression**
```dart
String resultPath =await MediaCompression.compressFileHandler(input.path, output.path);
```

**Get video compression**
```dart
 String resultPath =await MediaCompression.compressVideoFileHandler(input.path, output.path);
```
