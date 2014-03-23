//
//  YelpClient.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "ROBusiness.h"

@protocol YelpClientDelegate

-(void)dataDownloaded;

@end

@interface YelpClient : BDBOAuth1RequestOperationManager

+ (id)instance;

- (NSUInteger)getResultCount;
- (ROBusiness *)getBusinessAtIndex:(NSUInteger) index;
- (void)addDelegate: (id<YelpClientDelegate>)delegate;
- (void)removeDelegate: (id<YelpClientDelegate>)delegate;
- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term;

@end