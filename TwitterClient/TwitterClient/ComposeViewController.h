//
//  ComposeViewController.h
//  TwitterClient
//
//  Created by Minh Nguyen on 3/30/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) Tweet * replyTweet;

@end
