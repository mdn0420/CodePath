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

static NSString *const BASE_RT_URL = @"http://api.rottentomatoes.com";
static NSString *const RT_URL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ch47ujnv5nexv2yc38kbqebc";
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
    [self checkReachability];
    return [super init];
}

- (void)fetchData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:RT_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self buildMovieList:responseObject[@"movies"]];
        
        [self callDelegates:@"dataDownloaded"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self callDelegates:@"requestFailed"];
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
        movie.posterUrl = rawMovie[@"posters"][@"thumbnail"];
        [_movies addObject:movie];
    }
    
    NSLog(@"Done building movie list");
}

- (void)checkReachability {
    NSURL *baseURL = [NSURL URLWithString:BASE_RT_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"Unreachable");
                break;
        }
    }];
}

- (void)callDelegates: (NSString *)selectorName {
    SEL selector = NSSelectorFromString(selectorName);
    for(NSObject *delegate in delegates) {
        [delegate performSelector:selector withObject:nil afterDelay:0.0f];
    }
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
