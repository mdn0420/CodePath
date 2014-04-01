//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

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
NSString * const ENDPOINT_HOMELINE = @"1.1/statuses/home_timeline.json";
NSString * const ENDPOINT_AUTH_USER = @"1.1/account/verify_credentials.json";
NSString * const ENDPOINT_SEND_TWEET = @"1.1/statuses/update.json";
NSString * const ENDPOINT_FAVORITE_TWEET = @"1.1/favorites/create.json";
NSString * const ENDPOINT_UNFAVORITE_TWEET = @"1.1/favorites/destroy.json";

@implementation TwitterClient

static User *_currentUser = nil;

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
    [defaults removeObjectForKey:UD_KEY_USER];
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
                    [self fetchAuthUser];
                } failure:^(NSError *error) {
                    NSLog(@"Access token request error %@", [error debugDescription]);
                }];
            }
        }
    }
}

- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetData))success {
	[self GET:ENDPOINT_HOMELINE parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
		NSMutableArray *tweets = [NSMutableArray array];
        Tweet *tweet;
		if ([response isKindOfClass:[NSArray class]]) {
			for (NSDictionary *tweetData in response) {
                tweet = [[Tweet alloc] init];
				[tweets addObject:[tweet initWithJSON:tweetData]];
			}
			success(tweets);
		} else {
            NSLog(@"Unrecognized response when fetching homeline");
        }
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching teweets - %@", error);
    }];
    
}

#pragma mark - User methods

- (void)fetchAuthUser {
    [self GET:ENDPOINT_AUTH_USER parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
		if ([response isKindOfClass:[NSDictionary class]]) {
			User *userData = [[User alloc ] initWithJSON:response];
            self.currentUser = userData;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_USER_AUTHENTICATED object:self];
		} else {
			// bad server response
			NSLog(@"Unrecognized response when fetching user credentials");
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error fetching user credentials - %@", error);
	}];
}

- (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [defaults setObject:encodedObject forKey:UD_KEY_USER];
}

- (User *)currentUser {
    if(_currentUser == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *userData = [defaults objectForKey:UD_KEY_USER];
        if(userData) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
    }
    
    return _currentUser;
}

#pragma mark - Tweet methods

- (void)sendTweet:(NSString *)text success:(void (^)(void))success {
    NSDictionary *params = @{@"status": text};
    [self POST:ENDPOINT_SEND_TWEET parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully sent tweet");
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error sending tweet - %@", error);
    }];
}

- (void)favoriteTweetWithId:(NSNumber *)tweetId toggle:(BOOL)value success:(void (^)(void))success {
    NSString *endpoint = value ? ENDPOINT_FAVORITE_TWEET : ENDPOINT_UNFAVORITE_TWEET;
    NSDictionary *params = @{@"id": tweetId};
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully favorited or unfavorited tweet");
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error favorited or unfavorited tweet - %@", error);
    }];
}

@end
