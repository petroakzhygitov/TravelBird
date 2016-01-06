#import <HTMLReader/HTMLDocument.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "TBDWeatherServiceDataParserTests.h"

SpecBegin(TBDWeatherServiceDataParser)
    {
        describe(@"TBDWeatherServiceDataParser", ^{

            __block NSString *_resourceFolder;

            beforeAll(^{
                _resourceFolder = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"travel-bird-test-data"];
            });

            it(@"should parse weather data from data", ^{
                NSString *filePath = [_resourceFolder stringByAppendingPathComponent:@"html/timeanddatedotcom.html"];
                NSArray *weatherDataArray = [TBDWeatherServiceDataParser parseWeatherDataFromData:[NSData dataWithContentsOfFile:filePath]];

                expect(@(weatherDataArray.count)).to.equal(@429);
            });

            it(@"should get temperatureInCelsius from string", ^{
                expect(@([TBDWeatherServiceDataParser temperatureInCelsiusFromString:@"32&nbsp;°C"])).to.equal(@32);
                expect(@([TBDWeatherServiceDataParser temperatureInCelsiusFromString:@"32&nbsp;°F"])).to.equal(@0);
                expect(@([TBDWeatherServiceDataParser temperatureInCelsiusFromString:@"140&nbsp;°F"])).to.equal(@60);
                expect(@([TBDWeatherServiceDataParser temperatureInCelsiusFromString:@"150&nbsp;°F"])).to.equal(@65);
                expect(@([TBDWeatherServiceDataParser temperatureInCelsiusFromString:@"N/A"])).to.equal(@(NSIntegerMin));
            });

            it(@"should get country from path string", ^{
                expect([TBDWeatherServiceDataParser countryFromPathString:@"/weather/morocco/casablanca"]).to.equal(@"Morocco");
                expect([TBDWeatherServiceDataParser countryFromPathString:@"/weather/united-arab-emirates/dubai"]).to.equal(@"United Arab Emirates");
            });
        });
    }

SpecEnd