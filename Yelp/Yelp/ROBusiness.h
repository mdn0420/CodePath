//
//  Business.h
//  Yelp
//
//  Created by Minh Nguyen on 3/21/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUJSONResponseSerializer.h"

@interface ROBusiness : MUJSONResponseObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *rating_img_url;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) float rating;


@end
