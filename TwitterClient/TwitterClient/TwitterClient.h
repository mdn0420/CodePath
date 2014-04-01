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

@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (nonatomic, strong) User *currentUser;

+ (TwitterClient *)instance;

- (void)login;
- (void)logout;
- (void)fetchAccessTokenWithUrl:(NSURL *)url;
- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetData))success;
- (void)sendTweet:(NSString *)text reply:(Tweet *)replyTweet success:(void (^)(void))success;
- (void)favoriteTweetWithId:(NSNumber *)tweetId toggle:(BOOL)value success:(void (^)(void))success;
- (void)retweetWithId:(NSNumber *)tweetId success:(void (^)(void))success;
- (void)destroyTweetWithId:(NSNumber *)tweetId success:(void (^)(void))success;

@end
