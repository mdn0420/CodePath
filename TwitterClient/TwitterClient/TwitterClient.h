//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

extern NSString * const NOTIF_USER_AUTHENTICATED;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)login;
- (void)logout;
- (BOOL)isLoggedIn;
- (void)fetchAccessTokenWithUrl:(NSURL *)url;

@end
