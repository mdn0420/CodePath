//
//  HomeTweetFetcher.m
//  TwitterClient
//
//  Created by Minh Nguyen on 4/7/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "HomeTweetFetcher.h"
#import "TwitterClient.h"

@implementation HomeTweetFetcher

- (void)fetchTweetsWithSuccess:(void (^)(NSMutableArray *tweetData))success {
    TwitterClient *client = [TwitterClient instance];
    [client fetchTweetsWithSuccess:^(NSMutableArray *tweetData) {
        success(tweetData);
    } url:ENDPOINT_HOMELINE];
}

@end
