#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface TBDWeatherServiceDataParser : NSObject
#pragma mark Properties

#pragma mark Methods

+ (NSArray *)parseWeatherDataFromData:(NSData *)data;

+ (NSInteger)temperatureInCelsiusFromString:(NSString *)temperatureString;

+ (NSString *)countryFromPathString:(NSString *)pathString;

@end