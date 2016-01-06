#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKApplicationDelegate : NSObject
#pragma mark Properties

#pragma mark Methods

+ (instancetype)sharedInstance;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end