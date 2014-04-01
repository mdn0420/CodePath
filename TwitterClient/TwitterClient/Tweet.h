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

@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) User * user;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) BOOL favorited;

@property (nonatomic, readonly) NSString * timeString;


+ (NSDateFormatter *)longDateFormatter;

@end
