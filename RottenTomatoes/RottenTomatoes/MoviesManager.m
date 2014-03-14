//
//  MoviesManager.m
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/13/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MoviesManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Movie.h"

@interface MoviesManager()

@property (nonatomic, strong, readwrite) NSMutableSet* delegates;

- (void)buildMovieList: (NSArray *)rawList;

@end

@implementation MoviesManager

@synthesize delegates;

NSString *const RT_URL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ch47ujnv5nexv2yc38kbqebc";
NSMutableArray * _movies;

+(MoviesManager *) instance {
    static MoviesManager *_instance = nil;
    @synchronized(self) {
        if(_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)addDelegate: (id<MovieManagerDelegate>) delegate {
    [delegates addObject: delegate];
    NSLog(@"Delegate added");
}

- (void)removeDelegate: (id<MovieManagerDelegate>) delegate {
    [delegates removeObject: delegate];
}

#pragma mark - Setup methods

- (id)init {
    delegates = [[NSMutableSet alloc] init];
    return [super init];
}

- (void)fetchData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:RT_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self buildMovieList:responseObject[@"movies"]];
        
        for(id<MovieManagerDelegate> delegate in delegates) {
            [delegate dataDownloaded];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)buildMovieList: (NSArray *)rawList {
    if(_movies == nil) {
        _movies = [[NSMutableArray alloc] init];
    }
    
    Movie *movie;
    for(id rawMovie in rawList) {
        movie = [[Movie alloc] init];
        movie.title = rawMovie[@"title"];
        [_movies addObject:movie];
    }
    
    NSLog(@"Done building movie list");
}

#pragma mark - Data methods
- (BOOL)isLoaded {
    return _movies != nil;
}

- (int)getMovieCount {
    return _movies.count;
}

- (Movie *)getMovieAtIndex: (int)index {
    return [_movies objectAtIndex:index];
}
@end
