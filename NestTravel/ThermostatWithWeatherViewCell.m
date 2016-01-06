#import "ThermostatWithWeatherViewCell.h"
#import "UIColor+NestBlue.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation ThermostatWithWeatherViewCell {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

- (void)awakeFromNib {
    [super awakeFromNib];

    self.weatherDetailsButton.backgroundColor = [UIColor nestBlue];
    self.weatherDetailsButton.layer.cornerRadius = 5;
    self.weatherDetailsButton.clipsToBounds = YES;
}

#pragma mark Public

#pragma mark IBAction

- (IBAction)weatherDetailsButtonTouchUpInsideAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(displayWeatherDetailsForThermostatWithWeatherViewCell:)]) {
        [self.delegate displayWeatherDetailsForThermostatWithWeatherViewCell:self];
    }
}

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end