#import "TBDWeatherData.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation TBDWeatherData {
#pragma mark Instance variables
}

#pragma mark Initializer

+ (TBDWeatherData *)dataWithCityName:(NSString *)cityName countryName:(NSString *)countryName temperatureInCelsius:(NSInteger)temperatureInCelsius {
    return [[TBDWeatherData alloc] initWithCityName:cityName countryName:countryName temperatureInCelsius:temperatureInCelsius];
}

- (instancetype)initWithCityName:(NSString *)cityName countryName:(NSString *)countryName temperatureInCelsius:(NSInteger)temperatureInCelsius {
    self = [super init];
    if (self) {
        self.cityName = cityName;
        self.countryName = countryName;
        self.temperatureInCelsius = temperatureInCelsius;
    }

    return self;
}

- (instancetype)init {
    return [self initWithCityName:nil countryName:nil temperatureInCelsius:NSIntegerMin];
}


#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end