#import <HTMLReader/HTMLDocument.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSNocilla.h"
#import "NestSDKAccessTokenCache.h"
#import "NestSDKAccessToken.h"

SpecBegin(NestSDKAccessTokenCache)
    {
        describe(@"NestSDKAccessTokenCache", ^{

            it(@"should cache, fetch clear access token cache", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"424242"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                [[[NestSDKAccessTokenCache alloc] init] cacheAccessToken:accessToken];

                NestSDKAccessToken *cachedAccessToken = [[[NestSDKAccessTokenCache alloc] init] fetchAccessToken];
                expect([cachedAccessToken isEqualToAccessToken:accessToken]).to.equal(YES);

                [[[NestSDKAccessTokenCache alloc] init] clearCache];
                NestSDKAccessToken *clearAccessToken = [[[NestSDKAccessTokenCache alloc] init] fetchAccessToken];
                expect([clearAccessToken isEqualToAccessToken:accessToken]).to.equal(NO);
                expect(clearAccessToken.tokenString).to.equal(nil);
            });
        });
    }

SpecEnd