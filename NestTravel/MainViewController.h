//
//  MainViewController.h
//  NestTravel
//
//  Created by Petro Akzhygitov on 31/12/15.
//  Copyright © 2015 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThermostatWithWeatherViewCell.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ThermostatWithWeatherViewCellDelegate>

#pragma mark Properties

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *loadingDataLabel;
@property(weak, nonatomic) IBOutlet UIView *loadingDataView;

@property(weak, nonatomic) IBOutlet UIButton *connectWithNestButton;
@property(weak, nonatomic) IBOutlet UILabel *connectWithNestLabel;
@property(weak, nonatomic) IBOutlet UIView *connectWithNestView;

@property(weak, nonatomic) IBOutlet UIView *faderView;


#pragma mark Methods

@end

