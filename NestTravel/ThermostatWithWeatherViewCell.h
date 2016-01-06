#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ThermostatWithWeatherViewCell;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol ThermostatWithWeatherViewCellDelegate <NSObject>
@optional

- (void)displayWeatherDetailsForThermostatWithWeatherViewCell:(ThermostatWithWeatherViewCell *)viewCell;

@end


@interface ThermostatWithWeatherViewCell : UITableViewCell
#pragma mark Properties

@property(weak, nonatomic) IBOutlet UILabel *weatherDetailsLabel;
@property(weak, nonatomic) IBOutlet UIView *weatherDetailsView;
@property(weak, nonatomic) IBOutlet UIButton *weatherDetailsButton;

@property(weak, nonatomic) id <ThermostatWithWeatherViewCellDelegate> delegate;

#pragma mark Methods

@end