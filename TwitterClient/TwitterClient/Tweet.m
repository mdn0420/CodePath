//
//  Tweet.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/30/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "Tweet.h"
#import "MHPrettyDate.h"

@interface Tweet ()

@property (nonatomic, strong) NSDate * createdDate;

@end

@implementation Tweet

- (instancetype)init
{
    if(self = [super init])
    {
        self.propertyMap = @{@"id": @"tweetId"};
    }
    return self;
}

+ (NSDateFormatter *)longDateFormatter {
	static NSDateFormatter *longDateFormatter;
    
	if (!longDateFormatter) {
		longDateFormatter = [[NSDateFormatter alloc] init];
		[longDateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
	}
    
	return longDateFormatter;
}

- (NSDate *)getDateObject {
    if(self.createdDate == nil) {
        self.createdDate = [[Tweet longDateFormatter] dateFromString:self.created_at];
    }
    
    return self.createdDate;
}

- (NSString *)timeString {
    NSDate *date = [self getDateObject];
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)shortTimeString {
    NSDate *date = [self getDateObject];
    return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
}

@end
