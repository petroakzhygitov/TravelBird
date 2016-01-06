#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@class TBDWeatherData;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface TBDUtils : NSObject

#pragma mark Properties

#pragma mark Methods

+ (NSDictionary *)weatherDataDictionaryWithWeatherDataArray:(NSArray *)temperatureDataArray;

+ (NSAttributedString *)randomAttributedStringWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName;

+ (NSString *)randomDetailsButtonTitleString;

@end