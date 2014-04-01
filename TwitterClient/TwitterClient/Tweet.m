//
//  Tweet.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/30/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "Tweet.h"

@interface Tweet ()

@property (nonatomic, strong) NSDate * createdDate;

@end

@implementation Tweet

+ (NSDateFormatter *)longDateFormatter {
	static NSDateFormatter *longDateFormatter;
    
	if (!longDateFormatter) {
		longDateFormatter = [[NSDateFormatter alloc] init];
		[longDateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
	}
    
	return longDateFormatter;
}

- (NSString *)timeString {
    if(self.createdDate == nil) {
        self.createdDate = [[Tweet longDateFormatter] dateFromString:self.created_at];
    }
    return [NSDateFormatter localizedStringFromDate:self.createdDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

@end
