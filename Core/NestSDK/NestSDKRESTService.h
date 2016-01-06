#import <Foundation/Foundation.h>

@protocol NestSDKStructure;
@class NestSDKThermostat;
@class NestSDKSmokeCOAlarm;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKRESTServiceGetStructuresRequestHandler)(NSArray <NestSDKStructure> *structuresArray, NSError *error);
typedef void (^NestSDKRESTServiceGetThermostatRequestHandler)(NestSDKThermostat *thermostat, NSError *error);
typedef void (^NestSDKRESTServiceGetSmokeCOAlarmRequestHandler)(NestSDKSmokeCOAlarm *smokeCOAlarm, NSError *error);

#pragma mark Protocol

@interface NestSDKRESTService : NSObject
#pragma mark Properties

#pragma mark Methods

- (void)getStructuresWithHandler:(NestSDKRESTServiceGetStructuresRequestHandler)handler;

- (void)getThermostatWithId:(NSString *)thermostatId handler:(NestSDKRESTServiceGetThermostatRequestHandler)handler;

- (void)getSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId handler:(NestSDKRESTServiceGetSmokeCOAlarmRequestHandler)handler;

@end