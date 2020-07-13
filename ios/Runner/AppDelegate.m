#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "IDCardReadPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    [self registerCustomPlugin:self];
  // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:3.0];
//  return [super application:application didFinishLaunchingWithOptions:launchOptions];
    
   return YES;
}

- (void)registerCustomPlugin:(NSObject<FlutterPluginRegistry>*) registry{
    [IDCardReadPlugin registerWithRegistrar:[registry registrarForPlugin:@"idcard_plugin"]];
}

@end
