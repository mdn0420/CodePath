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
    [encoder encodeObject:self.followers_count forKey:@"followers_count"];
    [encoder encodeObject:self.friends_count forKey:@"friends_count"];
    [encoder encodeObject:self.statuses_count forKey:@"statuses_count"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.screen_name = [decoder decodeObjectForKey:@"screen_name"];
        self.profile_image_url = [decoder decodeObjectForKey:@"profile_image_url"];
         self.followers_count = [decoder decodeObjectForKey:@"followers_count"];
         self.friends_count = [decoder decodeObjectForKey:@"friends_count"];
         self.statuses_count = [decoder decodeObjectForKey:@"statuses_count"];
    }
    return self;
}

- (NSString *)screenNameFormatted {
    return [NSString stringWithFormat:@"@%@", self.screen_name];
}


@end
