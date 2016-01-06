#import "TBDUtils.h"
#import "TBDWeatherData.h"
#import "HTMLAttributedString.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation TBDUtils {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (NSDictionary *)weatherDataDictionaryWithWeatherDataArray:(NSArray *)temperatureDataArray {
    NSMutableDictionary *temperatureDictionary = [[NSMutableDictionary alloc] init];

    for (TBDWeatherData *temperatureData in temperatureDataArray) {
        NSMutableArray *dataArray = temperatureDictionary[@(temperatureData.temperatureInCelsius)] ? : [[NSMutableArray alloc] init];
        [dataArray addObject:temperatureData];

        temperatureDictionary[@(temperatureData.temperatureInCelsius)] = dataArray;
    }

    return [temperatureDictionary copy];
}

+ (NSAttributedString *)randomAttributedStringWithWeatherData:(TBDWeatherData *)weatherData andThermostatName:(NSString *)thermostatName {
    NSArray *textsArray = @[@"The temperature in your %thermostat_name% is %temperature%. The same temperature is in %city_name% now!",
            @"Your %thermostat_name% feels like %city_name%! Its %temperature% there!",
            @"Have you been in %city_name%? Go visit your %thermostat_name% and feel same %temperature%!",
            @"%city_name% welcomes you right from your %thermostat_name%! Get your favourite %temperature% there!",
            @"Your %thermostat_name% is right in the heart of %city_name%! Exactly %temperature% there!"];

    NSUInteger randomIndex = arc4random() % textsArray.count;
    NSString *htmlString = textsArray[randomIndex];

    NSString *cityNameHTMLString = [NSString stringWithFormat:@"<span class='c2'>%@</span>", weatherData.cityName];
    NSString *thermostatNameHTMLString = [NSString stringWithFormat:@"<span class='c3'>%@</span>", thermostatName];
    NSString *temperatureHTMLString = [NSString stringWithFormat:@"<span class='c1'>%d °C</span>", weatherData.temperatureInCelsius];

    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%city_name%" withString:cityNameHTMLString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%thermostat_name%" withString:thermostatNameHTMLString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%temperature%" withString:temperatureHTMLString];

    HTMLAttributedString *htmlAttributedString = [[HTMLAttributedString alloc] initWithHtml:htmlString
                                                                                andBodyFont:[UIFont fontWithName:@"Avenir-Roman" size:18.0]];

    [htmlAttributedString addCssAttribute:@".c1 {font-family : 'Avenir-Roman'; font-size : 22px;}"];
    [htmlAttributedString addCssAttribute:@".c2 {font-family : 'Avenir-Roman'; font-size : 22px;}"];
    [htmlAttributedString addCssAttribute:@".c3 {font-family : 'Avenir-Roman'; font-size : 22px;}"];

    NSMutableAttributedString *attributedString = [htmlAttributedString.attributedString mutableCopy];

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:2.0f];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [attributedString length])];

    return attributedString;
}

+ (NSString *)randomDetailsButtonTitleString {
    NSArray *titlesArray = @[@"Where is it?", @"Never been there?", @"Never heard about?", @"Want to discover?", @"How to get there?"];
    NSUInteger randomIndex = arc4random() % titlesArray.count;

    return titlesArray[randomIndex];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end