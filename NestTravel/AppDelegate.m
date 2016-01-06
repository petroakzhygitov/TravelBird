//
//  AppDelegate.m
//  NestTravel
//
//  Created by Petro Akzhygitov on 31/12/15.
//  Copyright © 2015 Petro Akzhygitov. All rights reserved.
//

#import "AppDelegate.h"
#import "NestSDKApplicationDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initializing NestSDK
    [[NestSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Initializing NestSDK (for the future use)
    return [[NestSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


@end
