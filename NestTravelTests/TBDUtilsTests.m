#import <HTMLReader/HTMLDocument.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "TBDUtils.h"
#import "TBDWeatherServiceDataParserTests.h"

SpecBegin(TBDUtils)
    {
        describe(@"TBDUtils", ^{

            __block NSString *_resourceFolder;

            beforeAll(^{
                _resourceFolder = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"travel-bird-test-data"];
            });

            it(@"should create weather data dictionary", ^{
                NSString *filePath = [_resourceFolder stringByAppendingPathComponent:@"html/timeanddatedotcom.html"];
                NSArray *weatherDataArray = [TBDWeatherServiceDataParser parseWeatherDataFromData:[NSData dataWithContentsOfFile:filePath]];

                NSDictionary *weatherDataDictionary = [TBDUtils weatherDataDictionaryWithWeatherDataArray:weatherDataArray];
                expect(((NSArray *)weatherDataDictionary[@(-1)]).count).to.equal(8);
                expect(((NSArray *)weatherDataDictionary[@(23)]).count).to.equal(15);
                expect(((NSArray *)weatherDataDictionary[@(NSIntegerMin)]).count).to.equal(2);
            });
        });
    }

SpecEnd