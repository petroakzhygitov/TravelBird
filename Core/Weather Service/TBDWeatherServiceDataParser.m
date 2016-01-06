#import <HTMLReader/HTMLDocument.h>
#import "TBDWeatherServiceDataParserTests.h"
#import "HTMLSelector.h"
#import "TBDWeatherData.h"

#pragma mark macros

#pragma mark const

static NSString *const kTagTBody = @"tbody";
static NSString *const kTagTD = @"td";
static NSString *const kTagA = @"a";

static NSString *const kAttributeHREF = @"href";

#pragma mark enum

#pragma mark typedef


@implementation TBDWeatherServiceDataParser {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (NSArray *)parseWeatherDataFromData:(NSData *)data {
    NSMutableArray *citiesTemperatureData = [[NSMutableArray alloc] init];

    HTMLDocument *home = [HTMLDocument documentWithData:data contentTypeHeader:nil];
    HTMLElement *div = [home firstNodeMatchingSelector:kTagTBody];
    NSArray *tds = [div nodesMatchingSelector:kTagTD];

    for (NSUInteger i = 0; i < tds.count; i += 4) {
        HTMLElement *href = [((HTMLElement *) tds[i]) firstNodeMatchingSelector:kTagA];

        NSString *cityName = href.textContent;
        NSString *countryName = [self countryFromPathString:href.attributes[kAttributeHREF]];
        NSString *temperatureString = ((HTMLElement *) tds[i + 3]).textContent;

        NSInteger temperatureInCelsius = [self temperatureInCelsiusFromString:temperatureString];

        TBDWeatherData *cityTemperatureData = [TBDWeatherData dataWithCityName:cityName
                                                                   countryName:countryName
                                                          temperatureInCelsius:temperatureInCelsius];

        [citiesTemperatureData addObject:cityTemperatureData];
    }

    return [citiesTemperatureData copy];
}

+ (NSInteger)temperatureInCelsiusFromString:(NSString *)temperatureString {
    NSInteger temperature = (NSInteger) [temperatureString intValue];

    if ([temperatureString isEqualToString:@"N/A"]) {
        return NSIntegerMin;
    }

    if ([temperatureString hasSuffix:@"F"]) {
        return @((temperature - 32) / 1.8).integerValue;
    }

    return temperature;
}

+ (NSString *)countryFromPathString:(NSString *)pathString {
    NSString *countryString = [pathString stringByDeletingLastPathComponent].lastPathComponent;
    countryString = [[countryString stringByReplacingOccurrencesOfString:@"-" withString:@" "] capitalizedString];

    return countryString;
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end