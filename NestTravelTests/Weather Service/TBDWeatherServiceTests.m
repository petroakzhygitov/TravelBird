#import <HTMLReader/HTMLDocument.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSNocilla.h"
#import "TBDWeatherService.h"
#import "RACSignal.h"

SpecBegin(TBDWeatherService)
    {
        __block NSString *_resourceFolder;

        describe(@"TBDWeatherService", ^{

            beforeAll(^{
                [[LSNocilla sharedInstance] start];
                _resourceFolder = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"travel-bird-test-data"];
            });

            afterAll(^{
                [[LSNocilla sharedInstance] stop];
            });

            afterEach(^{
                [[LSNocilla sharedInstance] clearStubs];
            });

            it(@"should get weather data", ^{
                NSString *filePath = [_resourceFolder stringByAppendingPathComponent:@"html/timeanddatedotcom.html"];

                stubRequest(@"GET", @"http://www.timeanddate.com/weather/?sort=6&low=4").
                        andReturn(200).
                        withBody([NSData dataWithContentsOfFile:filePath]);

                waitUntil(^(DoneCallback done) {
                    TBDWeatherService *service = [[TBDWeatherService alloc] init];
                    [service.getWeatherData subscribeNext:^(NSArray *weatherDataArray) {
                        expect(@(weatherDataArray.count)).to.equal(@429);
                        done();

                    }                               error:^(NSError *error) {
                        failure(@"Should get weather data! Error: %@", error);
                        done();
                    }];
                });
            });
        });
    }

SpecEnd