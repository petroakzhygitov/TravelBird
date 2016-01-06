#import "TBDTravelSuggestion.h"
#import "TBDWeatherData.h"
#import "TBDUtils.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation TBDTravelSuggestion {
#pragma mark Instance variables
}

#pragma mark Initializer

+ (instancetype)suggestionWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName {
    return [[TBDTravelSuggestion alloc] initWithWeatherData:weatherData andThermostatName:thermostatName];
}

- (instancetype)initWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName {
    self = [super init];
    if (self) {
        self.text = [TBDUtils randomAttributedStringWithWeatherData:weatherData andThermostatName:thermostatName];
        self.question = [TBDUtils randomDetailsButtonTitleString];
        self.weatherData = weatherData;
    }

    return self;
}

- (instancetype)init {
    return [self initWithWeatherData:nil andThermostatName:nil];
}

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end