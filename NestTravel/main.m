//
//  main.m
//  NestTravel
//
//  Created by Petro Akzhygitov on 31/12/15.
//  Copyright © 2015 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestsAppDelegate.h"

int main(int argc, char *argv[]) {
    int returnValue;

    @autoreleasepool {
        BOOL inLogicTests = (NSClassFromString(@"SenTestCase") != nil || NSClassFromString(@"XCTest") != nil);
        BOOL inUITests = NSClassFromString(@"KIFTestCase") != nil;

        if (inLogicTests && !inUITests) {
            //use a special empty delegate when we are inside the tests
            returnValue = UIApplicationMain(argc, argv, nil, NSStringFromClass([TestsAppDelegate class]));
        } else {
            //use the normal delegate
            returnValue = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }

    return returnValue;
}
