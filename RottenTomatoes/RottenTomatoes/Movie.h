//
//  Movie.h
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/13/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSInteger rtId;
@property (nonatomic) NSInteger criticScore;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbUrl;
@property (nonatomic, strong) NSString *profileUrl;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *mpaaRating;

@end
