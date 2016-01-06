#import <HTMLReader/HTMLDocument.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSNocilla.h"
#import "NestSDKAccessToken.h"
#import "NestSDKRESTService.h"
#import "NestSDKStructure.h"

SpecBegin(NestSDKRESTService)
    {
        describe(@"NestSDKRESTService", ^{

            it(@"should create, set, get access token", ^{
                [NestSDKAccessToken setCurrentAccessToken:[[NestSDKAccessToken alloc] initWithTokenString:@"c.33D800kAIprQmhXQXsLfmKOUxfSgs7maPVozihsmyrMBqzBdZY3SS9DcXgfv21e3vihAjnZgiN35nZC6OOVpT5ID6yvqKD8xFZXygrn97YB4XvyrR9tezFhkFoM1vfzSSxXhfSnVekDfBfgZ"
                                                                                           expirationDate:[NSDate distantFuture]]];

                waitUntil(^(DoneCallback done) {
                    NestSDKRESTService *service = [[NestSDKRESTService alloc] init];
                    [service getStructuresWithHandler:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        NSLog(@"here: %@", structuresArray);

                        for (NestSDKStructure *structure in structuresArray) {
                            for (NSString *thermostatId in structure.thermostats) {
                                [service getThermostatWithId:thermostatId handler:^(NestSDKThermostat *thermostat, NSError *error) {
                                    NSLog(@"Thermostat: %@", thermostat);
                                }];
                            }

//                            for (NSString *smokeCOAlarmId in structure.smoke_co_alarms) {
//                                [service getSmokeCOAlarmWithId:smokeCOAlarmId handler:^(NestSDKSmokeCOAlarm *smokeCOAlarm, NSError *error) {
//                                    NSLog(@"here3");
//                                }];
//                            }
                        }
                    }];
                });
            });
        });
    }

SpecEnd