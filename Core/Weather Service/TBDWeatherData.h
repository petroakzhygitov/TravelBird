#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol


@interface TBDWeatherData : NSObject
#pragma mark Properties

@property(nonatomic, copy) NSString *countryName;
@property(nonatomic, copy) NSString *cityName;

@property(nonatomic) NSInteger temperatureInCelsius;

#pragma mark Methods

+ (TBDWeatherData *)dataWithCityName:(NSString *)cityName countryName:(NSString *)countryName temperatureInCelsius:(NSInteger)temperatureInCelsius;

- (instancetype)initWithCityName:(NSString *)cityName countryName:(NSString *)countryName temperatureInCelsius:(NSInteger)temperatureInCelsius;

@end