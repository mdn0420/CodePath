//
//  User.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/27/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "User.h"

@implementation User

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.screen_name forKey:@"screen_name"];
    [encoder encodeObject:self.profile_image_url forKey:@"profile_image_url"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.screen_name = [decoder decodeObjectForKey:@"screen_name"];
        self.profile_image_url = [decoder decodeObjectForKey:@"profile_image_url"];
    }
    return self;
}


@end
