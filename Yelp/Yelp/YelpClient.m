//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "MUJSONResponseSerializer.h"
#import "ROBusiness.h"
#import "ROSearchResults.h"

static ROSearchResults *_results;

NSString * const kYelpConsumerKey = @"IONp_LFvPZHp9R8AOV0LYA";
NSString * const kYelpConsumerSecret = @"mdW3ult1brnqBFhUvBbklH-IWIM";
NSString * const kYelpToken = @"2PSqX_OT7XC-NnZd435lpQTWVP7r-Xle";
NSString * const kYelpTokenSecret = @"C5IxIuB0cy8OBF6j2aG29q_mmCI";

@interface YelpClient()

@property (nonatomic, strong, readwrite) NSMutableSet *delegates;

@end

@implementation YelpClient

@synthesize delegates;

+(YelpClient *) instance {
    static YelpClient *_instance = nil;
    @synchronized(self) {
        if(_instance == nil) {
            _instance = [[self alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        }
    }
    return _instance;
}

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        delegates = [[NSMutableSet alloc] init];
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
        [self setResponseSerializer:[[MUJSONResponseSerializer alloc] init]];
    }
    return self;
}

#pragma mark - Instance methods

- (NSUInteger)getResultCount {
    NSUInteger result = 0;
    if(_results && _results.businesses) {
        result = _results.businesses.count;
    }
    return result;
}

- (ROBusiness *)getBusinessAtIndex:(NSUInteger)index {
    ROBusiness *business = nil;
    NSUInteger total = [self getResultCount];
    if(total > 0 && index < total) {
        business = [_results.businesses objectAtIndex:index];
    }
    return business;
}

#pragma mark - API methods

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term {
    
    [(MUJSONResponseSerializer *)[self responseSerializer] setResponseObjectClass:[ROSearchResults class]];
    
    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    return [self GET:@"search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        _results = response;
        [self callDelegates:@"dataDownloaded"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

#pragma mark - Delegate methods

- (void)addDelegate: (id<YelpClientDelegate>) delegate {
    [delegates addObject: delegate];
}

- (void)removeDelegate: (id<YelpClientDelegate>) delegate {
    [delegates removeObject: delegate];
}

- (void)callDelegates: (NSString *)selectorName {
    SEL selector = NSSelectorFromString(selectorName);
    for(NSObject *delegate in delegates) {
        [delegate performSelector:selector withObject:nil afterDelay:0.0f];
    }
}

@end