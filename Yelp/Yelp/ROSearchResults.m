//
//  ROSearchResults.m
//  Yelp
//
//  Created by Minh Nguyen on 3/23/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "ROSearchResults.h"
#import "ROBusiness.h"

@implementation ROSearchResults

- (Class)classForElementsInArrayProperty:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"businesses"]) {
        return [ROBusiness class];
    }
    return [NSObject class];
}

@end
