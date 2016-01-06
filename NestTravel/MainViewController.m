//
//  MainViewController.m
//  NestTravel
//
//  Created by Petro Akzhygitov on 31/12/15.
//  Copyright © 2015 Petro Akzhygitov. All rights reserved.
//

#import <ReactiveCocoa/RACSignal.h>
#import <libkern/OSAtomic.h>
#import "MainViewController.h"
#import "NestSDKAccessToken.h"
#import "NestSDKAuthorizationManager.h"
#import "UIColor+NestBlue.h"
#import "NestSDKAuthorizationManagerAuthorizationResult.h"
#import "NestSDKStructuresManager.h"
#import "NestSDKStructure.h"
#import "NestSDKThermostatsManager.h"
#import "TBDWeatherService.h"
#import "RACSignal+Operations.h"
#import "TBDUtils.h"
#import "NestSDKThermostat.h"
#import "NestSDKRESTService.h"
#import "TBDWeatherData.h"
#import "WebViewController.h"
#import "TBDTravelSuggestion.h"

#pragma mark macros

#pragma mark const

static const double kDefaultAnimationDuration = .2;

static NSString *const kThermostatWithWeatherViewCellIdentifier = @"ThermostatWithWeatherViewCellIdentifier";
static NSString *const kNibNameThermostatWithWeatherViewCell = @"ThermostatWithWeatherViewCell";

static NSString *const kWebViewControllerSegue = @"showWebViewControllerSegueIdentifier";

static NSString *const kGoogleSearchURLString = @"https://www.google.com.ua/#q=";

static const int kHeaderInSectionHeight = 30;
static const int kFooterInSectionHeight = 0;

static const int kCellRowHeight = 200;

#pragma mark enum

#pragma mark typedef

@implementation MainViewController {
#pragma mark Instance variables

    NestSDKStructuresManager *_structuresManager;
    NestSDKThermostatsManager *_thermostatsManager;

    TBDWeatherService *_weatherService;

    NSDictionary *_weatherDataDictionary;

    NSArray <NestSDKStructure> *_structuresArray;
    NSMutableArray *_thermostatsArray;

    NSMutableDictionary *_travelSuggestionsForThermostatsDictionary;

    int32_t _loadedThermostatDataCount;
    int _totalThermostatsCount;

    int _isUpdatingThermostatData;

    TBDWeatherData *_selectedWeatherData;
}

#pragma mark Initializer

#pragma mark Private

- (void)p_updateThermostatsData {
//    [self p_updateThermostatsDataWithREST];
    [self p_updateThermostatsDataWithFirebase];
}

- (void)p_updateThermostatsDataWithREST {
    if (!OSAtomicCompareAndSwapInt(NO, YES, &_isUpdatingThermostatData)) return;

    NestSDKRESTService *service = [[NestSDKRESTService alloc] init];
    [service getStructuresWithHandler:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        if (!structuresArray.count || error) {
            OSAtomicCompareAndSwapInt(YES, NO, &_isUpdatingThermostatData);

            return;
        }

        _totalThermostatsCount = 0;
        _loadedThermostatDataCount = 0;

        for (NestSDKStructure *structure in structuresArray) {
            _totalThermostatsCount += structure.thermostats.count;
        }

        _structuresArray = structuresArray;
        _thermostatsArray = [NSMutableArray arrayWithCapacity:structuresArray.count];

        for (NSUInteger i = 0; i < structuresArray.count; i++) {
            NestSDKStructure *structure = structuresArray[i];

            NSMutableArray *thermostatsWithinStructureArray = [[NSMutableArray alloc] initWithCapacity:structure.thermostats.count];
            _thermostatsArray[i] = thermostatsWithinStructureArray;

            for (NSString *thermostatId in structure.thermostats) {
                [service getThermostatWithId:thermostatId handler:^(NestSDKThermostat *thermostat, NSError *error) {
                    if (!thermostat) return;

                    [thermostatsWithinStructureArray addObject:thermostat];

                    if (OSAtomicIncrement32(&_loadedThermostatDataCount) == _totalThermostatsCount) {
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            [self.tableView reloadData];
                        });

                        OSAtomicCompareAndSwapInt(YES, NO, &_isUpdatingThermostatData);
                    }
                }];
            }
        }
    }];
}

- (void)p_updateThermostatsDataWithFirebase {
    [self p_showView:self.loadingDataView];

    [_structuresManager observeStructuresWithUpdateBlock:^(NSArray <NestSDKStructure> *structuresArray) {
        [_thermostatsManager removeAllObservers];

        _structuresArray = structuresArray;
        _thermostatsArray = [NSMutableArray arrayWithCapacity:structuresArray.count];

        if (!structuresArray.count) return;

        for (NSUInteger i = 0; i < structuresArray.count; i++) {
            NestSDKStructure *structure = structuresArray[i];

            NSMutableArray *thermostatsWithinStructureArray = [[NSMutableArray alloc] initWithCapacity:structure.thermostats.count];
            _thermostatsArray[i] = thermostatsWithinStructureArray;

            for (NSString *thermostatId in structure.thermostats) {
                [_thermostatsManager observeThermostatWithId:thermostatId updateBlock:^(NestSDKThermostat *thermostat) {
                    [self p_hideView:self.loadingDataView];

                    if (!thermostat) return;

                    NSUInteger thermostatIndex = [self p_thermostatIndex:thermostat inThermostatsArray:thermostatsWithinStructureArray];

                    if (thermostatIndex == NSNotFound) {
                        [thermostatsWithinStructureArray addObject:thermostat];

                    } else {
                        thermostatsWithinStructureArray[thermostatIndex] = thermostat;
                    }

                    _travelSuggestionsForThermostatsDictionary[thermostat.device_id] = [self p_generateSuggestionForThermostat:thermostat];

                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.tableView reloadData];
                    });
                }];
            }
        }
    }];
}

- (NSUInteger)p_thermostatIndex:(NestSDKThermostat *)thermostat inThermostatsArray:(NSArray *)thermostatsArray {
    @synchronized (thermostatsArray) {
        for (NSUInteger i = 0; i < thermostatsArray.count; i++) {
            NestSDKThermostat *currentThermostat = thermostatsArray[i];

            if ([currentThermostat.device_id isEqualToString:thermostat.device_id]) {
                return i;
            }
        }
    }

    return NSNotFound;
}

- (void)p_initUI {
    [self.tableView registerNib:[UINib nibWithNibName:kNibNameThermostatWithWeatherViewCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kThermostatWithWeatherViewCellIdentifier];

    self.tableView.estimatedRowHeight = kCellRowHeight;
    self.tableView.estimatedSectionHeaderHeight = kHeaderInSectionHeight;
    self.tableView.estimatedSectionFooterHeight = 0;

    self.tableView.allowsSelection = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.loadingDataView.layer.cornerRadius = 6;
    self.loadingDataView.layer.masksToBounds = YES;
    self.loadingDataView.clipsToBounds = YES;

    self.loadingDataLabel.textColor = [UIColor nestBlue];

    self.connectWithNestView.layer.cornerRadius = 6;
    self.connectWithNestView.layer.masksToBounds = YES;
    self.connectWithNestView.clipsToBounds = YES;

    self.connectWithNestLabel.textColor = [UIColor nestBlue];

    self.connectWithNestButton.layer.cornerRadius = 3;
    self.connectWithNestButton.layer.masksToBounds = YES;
    self.connectWithNestButton.clipsToBounds = YES;
    self.connectWithNestButton.backgroundColor = [UIColor nestBlue];
}

- (void)p_updateWeatherData {
    [[[_weatherService.getWeatherData retry:3] deliverOnMainThread] subscribeNext:^(NSArray *weatherDataArray) {
        _weatherDataDictionary = [TBDUtils weatherDataDictionaryWithWeatherDataArray:weatherDataArray];

        [self p_generateSuggestionsForAllThermostats];
        [self.tableView reloadData];
    }];
}

- (void)p_generateSuggestionsForAllThermostats {
    for (NSArray *thermostatsWithinStructureArray in _thermostatsArray) {

        for (NestSDKThermostat *thermostat in thermostatsWithinStructureArray) {
            _travelSuggestionsForThermostatsDictionary[thermostat.device_id] = [self p_generateSuggestionForThermostat:thermostat];
        }
    }
}

- (TBDTravelSuggestion *)p_generateSuggestionForThermostat:(NestSDKThermostat *)thermostat {
    NSInteger roundTemperature = @(thermostat.target_temperature_c).integerValue;
    NSArray *sameWeatherArray = _weatherDataDictionary[@(roundTemperature)];

    NSUInteger randomIndex = arc4random() % sameWeatherArray.count;
    TBDWeatherData *weatherData = (TBDWeatherData *) sameWeatherArray[randomIndex];

    return [TBDTravelSuggestion suggestionWithWeatherData:weatherData andThermostatName:thermostat.name];
}

- (void)p_showView:(UIView *)view {
    if (!view.hidden && view.alpha == 1) return;

    view.alpha = 0;
    view.hidden = NO;

    self.faderView.alpha = 0;
    self.faderView.hidden = NO;

    [UIView animateWithDuration:kDefaultAnimationDuration
                     animations:^(void) {
                         view.alpha = 1;
                         self.faderView.alpha = .4;
                     }];
}

- (void)p_hideView:(UIView *)view {
    if (view.hidden) return;

    [UIView animateWithDuration:kDefaultAnimationDuration
                     animations:^(void) {
                         view.alpha = 0;
                         self.faderView.alpha = 0;

                     } completion:^(BOOL finished) {
                view.hidden = YES;
                self.faderView.hidden = YES;
            }];
}

#pragma mark Notification selectors

#pragma mark Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _structuresManager = [[NestSDKStructuresManager alloc] init];
    _thermostatsManager = [[NestSDKThermostatsManager alloc] init];

    _weatherService = [[TBDWeatherService alloc] init];

    _travelSuggestionsForThermostatsDictionary = [[NSMutableDictionary alloc] init];

    [self p_initUI];
    [self p_updateWeatherData];

    if (![NestSDKAccessToken currentAccessToken]) {
        [self p_showView:self.connectWithNestView];

    } else {
        [self p_updateThermostatsData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kWebViewControllerSegue]) {
        NSString *searchURLString = [NSString stringWithFormat:@"%@,+%@", _selectedWeatherData.cityName, _selectedWeatherData.countryName];
        NSString *escapedSearchURLString = [searchURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

        WebViewController *webViewController = [segue destinationViewController];
        webViewController.url = [NSURL URLWithString:[kGoogleSearchURLString stringByAppendingString:escapedSearchURLString]];
    }
}

#pragma mark Public

#pragma mark IBAction

- (IBAction)loginWithNesButtonTouchUpInsideAction:(id)sender {
    NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];
    [authorizationManager authorizeWithNestAccountFromViewController:self handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
        if (result.token.tokenString.length && !error) {
            [self p_hideView:self.connectWithNestView];
            [self p_updateThermostatsData];
        }
    }];
}

#pragma mark Protocol @protocol-name

#pragma mark Delegate <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _thermostatsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *) _thermostatsArray[(NSUInteger) section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kThermostatWithWeatherViewCellIdentifier];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NestSDKStructure *structure = _structuresArray[(NSUInteger) section];

    return structure.name;
}

#pragma mark Delegate <UITableViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderInSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFooterInSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *thermostatsArray = (NSArray *) _thermostatsArray[(NSUInteger) indexPath.section];
    NestSDKThermostat *thermostat = thermostatsArray[(NSUInteger) indexPath.row];

    ThermostatWithWeatherViewCell *thermostatCell = (ThermostatWithWeatherViewCell *) cell;
    thermostatCell.delegate = self;

    TBDTravelSuggestion *suggestion = _travelSuggestionsForThermostatsDictionary[thermostat.device_id];
    thermostatCell.weatherDetailsLabel.attributedText = suggestion.text;
    [thermostatCell.weatherDetailsButton setTitle:suggestion.question forState:UIControlStateNormal];
}

#pragma mark Delegate <UITableViewDelegate>

- (void)displayWeatherDetailsForThermostatWithWeatherViewCell:(ThermostatWithWeatherViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSArray *thermostatsArray = (NSArray *) _thermostatsArray[(NSUInteger) indexPath.section];
    NestSDKThermostat *thermostat = thermostatsArray[(NSUInteger) indexPath.row];

    TBDTravelSuggestion *suggestion = _travelSuggestionsForThermostatsDictionary[thermostat.device_id];
    _selectedWeatherData = suggestion.weatherData;

    [self performSegueWithIdentifier:kWebViewControllerSegue sender:self];
}


@end
