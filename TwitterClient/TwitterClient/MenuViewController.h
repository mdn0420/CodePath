//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface MenuViewController : UIViewController

// ideally use a delegate instead of direct reference
@property (nonatomic, weak) MainViewController * mainController;

@end
