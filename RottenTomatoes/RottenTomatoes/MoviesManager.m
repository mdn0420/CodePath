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

@end

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

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

- (void)buildMovieList: (NSArray *)rawList {
    if(_movies == nil) {
        _movies = [[NSMutableArray alloc] init];
    }
    
    Movie *movie;
    for(id rawMovie in rawList) {
        movie = [[Movie alloc] init];
        movie.rtId = [rawMovie[@"id"] integerValue];
        movie.criticScore = [rawMovie[@"ratings"][@"critics_score"] integerValue];
        movie.title = rawMovie[@"title"];
        movie.thumbUrl = rawMovie[@"posters"][@"thumbnail"];
        movie.profileUrl = rawMovie[@"posters"][@"profile"];
        movie.synopsis = rawMovie[@"synopsis"];
        movie.mpaaRating = rawMovie[@"mpaa_rating"];
        [_movies addObject:movie];
    }
    
    // just to keep it interesting
    //[_movies shuffle];
    
    NSLog(@"Done building movie list");
}

# pragma mark - Helper methods

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

# pragma mark - Data request methods

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

- (void)fetchDetailedData {
    
}

- (void)refreshData {
    if(_movies) {
        [_movies removeAllObjects];
    }
    
    [self fetchData];
}

#pragma mark - Data methods

- (BOOL)isLoaded {
    return _movies != nil && _movies.count > 0;
}

- (int)getMovieCount {
    return _movies.count;
}

- (Movie *)getMovieAtIndex: (int)index {
    Movie *result;
    if(index >= 0 && index < _movies.count) {
        result = [_movies objectAtIndex:index];
    } else {
        NSLog(@"Invalid movie index %d", index);
    }
    return result;
}
@end
