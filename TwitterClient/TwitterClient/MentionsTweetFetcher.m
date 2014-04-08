//
//  MentionsTweetFetcher.m
//  TwitterClient
//
//  Created by Minh Nguyen on 4/7/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MentionsTweetFetcher.h"
#import "TwitterClient.h"

@implementation MentionsTweetFetcher

- (void)fetchTweetsWithSuccess:(void (^)(NSMutableArray *tweetData))success {
    TwitterClient *client = [TwitterClient instance];
    [client fetchTweetsWithSuccess:^(NSMutableArray *tweetData) {
        success(tweetData);
    } url:ENDPOINT_MENTIONS_TIMELINE];
}

@end
