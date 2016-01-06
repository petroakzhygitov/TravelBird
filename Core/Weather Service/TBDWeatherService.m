#import <ReactiveCocoa/RACSignal.h>
#import "TBDWeatherService.h"
#import "RACSubscriber.h"
#import "TBDWeatherServiceDataParser.h"

#pragma mark macros

#pragma mark const

static NSString *const kServiceURL = @"http://www.timeanddate.com/weather/?sort=6&low=4";

#pragma mark enum

#pragma mark typedef


@implementation TBDWeatherService {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (RACSignal *)getWeatherData {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSURL *url = [NSURL URLWithString:kServiceURL];
        NSURLSession *session = [NSURLSession sharedSession];

        [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];

            } else {
                [subscriber sendNext:[TBDWeatherServiceDataParser parseWeatherDataFromData:data]];
                [subscriber sendCompleted];
            }
        }] resume];

        return nil;
    }];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end