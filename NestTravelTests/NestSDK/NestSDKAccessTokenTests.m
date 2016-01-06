#import <HTMLReader/HTMLDocument.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSNocilla.h"
#import "NestSDKAccessToken.h"

SpecBegin(NestSDKAccessToken)
    {
        describe(@"NestSDKAccessToken", ^{

            it(@"should create, set, get access token", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"424242"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                expect(accessToken.tokenString).to.equal(@"424242");
                expect([accessToken.expirationDate isEqualToDate:[NSDate dateWithTimeIntervalSince1970:42]]).to.equal(YES);

                expect([NestSDKAccessToken currentAccessToken]).to.equal(nil);

                [NestSDKAccessToken setCurrentAccessToken:accessToken];
                expect([[NestSDKAccessToken currentAccessToken] isEqualToAccessToken:accessToken]).to.equal(YES);
            });

            it(@"should equal and calculate hash", ^{
                NestSDKAccessToken *accessToken1 = [[NestSDKAccessToken alloc] initWithTokenString:@"424242"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NestSDKAccessToken *accessToken2 = [[NestSDKAccessToken alloc] initWithTokenString:@"444444"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:44]];

                NestSDKAccessToken *accessToken3 = [[NestSDKAccessToken alloc] initWithTokenString:@"424242"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                expect([accessToken1 isEqualToAccessToken:accessToken2]).to.equal(NO);
                expect([accessToken1 isEqualToAccessToken:accessToken3]).to.equal(YES);

                expect(accessToken1.hash).notTo.equal(accessToken2.hash);
                expect(accessToken1.hash).to.equal(accessToken3.hash);
            });

            it(@"should serialize/deserialize", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"424242"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NSData *archivedObjectData = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
                NestSDKAccessToken *unarchivedAccessToken = [NSKeyedUnarchiver unarchiveObjectWithData:archivedObjectData];

                expect([accessToken isEqualToAccessToken:unarchivedAccessToken]).to.equal(YES);
            });
        });
    }

SpecEnd