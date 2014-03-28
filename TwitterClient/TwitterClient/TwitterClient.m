//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TwitterClient.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

// Constants
NSString * const NOTIF_USER_AUTHENTICATED = @"Notif_UserAuthenticated";
NSString * const NOTIF_TIMELINE_RECEIVED = @"Notif_TimelineReceived";
NSString * const UD_KEY_USER = @"UD_User";
NSString * const BASE_URL = @"https://api.twitter.com";

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] consumerKey:@"iNixd8uFmDR97WlY87YvJA" consumerSecret:@"wxFdxBhUzXC3kIparWqjB6TKx453HVflcotO99PoY"];
    });
    
    return _instance;
}

- (void)login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"mntwitter://oauth"] scope:nil success:^(BDBOAuthToken * requestToken) {
        NSLog(@"Token request successful");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Token request error: %@", [error debugDescription]);
    }];
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:UD_KEY_USER];
    [self.requestSerializer removeAccessToken];
}

- (AFHTTPRequestOperation *)homeTimeline {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Got timeline");
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error in getting timeline");
             }];
}

- (void)fetchAccessTokenWithUrl:(NSURL *)url {
    if ([url.scheme isEqualToString:@"mntwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                [self fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    [self.requestSerializer saveAccessToken:accessToken];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:UD_KEY_USER]; // todo: store user model in here
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_AUTHENTICATED object:self];
                } failure:^(NSError *error) {
                    NSLog(@"Access token request error %@", [error debugDescription]);
                }];
            }
        }
    }
}

- (void)getAuthUser {
    //[self GET:<#(NSString *)#> parameters:<#(NSDictionary *)#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>]
}

- (BOOL)isLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    return [defaults boolForKey:UD_KEY_USER];
}

@end
