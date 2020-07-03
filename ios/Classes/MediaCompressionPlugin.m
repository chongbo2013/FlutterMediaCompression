#import "MediaCompressionPlugin.h"

#if __has_include(<MediaCompression/MediaCompression-Swift.h>)
#import <MediaCompression/MediaCompression-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "MediaCompression-Swift.h"
#endif

@implementation MediaCompressionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMediaCompressionPlugin registerWithRegistrar:registrar];
}
@end
