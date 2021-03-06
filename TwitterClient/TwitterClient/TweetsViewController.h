//
//  TweetsViewController.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id <TweetFetcher> tweetFetcher;

@end
