#import <Foundation/Foundation.h>

@class TBDWeatherData;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface TBDTravelSuggestion : NSObject
#pragma mark Properties

@property(nonatomic, copy) NSAttributedString *text;
@property(nonatomic, copy) NSString *question;

@property(nonatomic) TBDWeatherData *weatherData;

#pragma mark Methods

+ (instancetype)suggestionWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName;

- (instancetype)initWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName;

@end