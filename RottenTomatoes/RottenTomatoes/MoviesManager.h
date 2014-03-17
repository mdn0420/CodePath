//
//  MoviesManager.h
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/13/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MovieManagerDelegate

-(void)dataDownloaded;
-(void)requestFailed;

@end

@interface MoviesManager : NSObject

+ (id)instance;
- (void)fetchData;
- (void)refreshData;
- (int)getMovieCount;
- (Movie *)getMovieAtIndex: (int)index;
- (void)addDelegate: (id<MovieManagerDelegate>)delegate;
- (void)removeDelegate: (id<MovieManagerDelegate>)delegate;
- (BOOL)isLoaded;

@end

