//
//  MainViewController.h
//  TwitterClient
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const NOTIF_PUSH_VIEW;
extern NSString * const NOTIF_PARAM_KEY_VIEW;

@interface MainViewController : UIViewController

@property (nonatomic, strong) UIViewController *mainController;
@property (nonatomic, strong) UIViewController *menuController;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
