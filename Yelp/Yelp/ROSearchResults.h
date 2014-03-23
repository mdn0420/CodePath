//
//  ROSearchResults.h
//  Yelp
//
//  Created by Minh Nguyen on 3/23/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface ROSearchResults : MUJSONResponseObject

@property (nonatomic, strong) NSArray *businesses;

@end
