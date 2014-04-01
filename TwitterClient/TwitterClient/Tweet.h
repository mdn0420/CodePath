//
//  Tweet.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/30/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUJSONResponseSerializer.h"
#import "User.h"

@interface Tweet : MUJSONResponseObject

@property (nonatomic, strong) NSNumber * tweetId;
@property (nonatomic, strong) NSString * id_str;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) User * user;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSDictionary * current_user_retweet;

@property (nonatomic, readonly) NSString * timeString;


+ (NSDateFormatter *)longDateFormatter;

@end
