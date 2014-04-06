//
//  User.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/27/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUJSONResponseSerializer.h"

@interface User : MUJSONResponseObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * screen_name;
@property (nonatomic, strong) NSString * profile_image_url;
@property (nonatomic, strong) NSNumber * followers_count;
@property (nonatomic, strong) NSNumber * friends_count;
@property (nonatomic, strong) NSNumber * statuses_count;
@property (nonatomic, readonly) NSString * screenNameFormatted;

@end
