//
//  User.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/27/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUJSONResponseSerializer.h"

@interface User : MUJSONResponseObject

@property (nonatomic, assign) NSString * screenName;

@end
