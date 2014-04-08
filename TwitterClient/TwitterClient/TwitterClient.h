//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

extern NSString * const NOTIF_USER_AUTHENTICATED;
extern NSString * const ENDPOINT_HOMELINE;
extern NSString * const ENDPOINT_MENTIONS_TIMELINE;

@protocol TweetFetcher <NSObject>

- (void)fetchTweetsWithSuccess:(void (^)(NSMutableArray *tweetData))success;

@end

@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (nonatomic, strong) User *currentUser;

+ (TwitterClient *)instance;

- (void)login;
- (void)logout;
- (void)fetchAccessTokenWithUrl:(NSURL *)url;
- (void)fetchTweetsWithSuccess:(void (^)(NSMutableArray *tweetData))success url:(NSString *)url;
- (void)sendTweet:(NSString *)text reply:(Tweet *)replyTweet success:(void (^)(void))success;
- (void)favoriteTweetWithId:(NSNumber *)tweetId toggle:(BOOL)value success:(void (^)(void))success;
- (void)retweetWithId:(NSNumber *)tweetId success:(void (^)(void))success;
- (void)destroyTweetWithId:(NSNumber *)tweetId success:(void (^)(void))success;

@end
