//
//  MainViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
- (IBAction)onPan:(UIPanGestureRecognizer *)sender;

@end

NSString * const NOTIF_PUSH_VIEW = @"Notif_PushView";
NSString * const NOTIF_PARAM_KEY_VIEW = @"Notif_Param_View";

@implementation MainViewController

CGPoint contentOrigCenter;
CGPoint offScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.contentView addSubview:self.mainController.view];
    [self.menuView addSubview:self.menuController.view];
    contentOrigCenter = self.contentView.center;
    offScreen = self.contentView.center;
    offScreen.x += self.contentView.frame.size.width;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewController:) name:NOTIF_PUSH_VIEW object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    point.y = contentOrigCenter.y;
    sender.view.center = point;
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
    } else if(sender.state == UIGestureRecognizerStateEnded) {
        if(velocity.x < 0) {
            [self closeMenu];
        } else {
            [self openMenu];
        }
    }
}

- (void)openMenu {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.center = offScreen;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeMenu {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.center = contentOrigCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)pushViewController:(NSNotification *)note {
    [self closeMenu];
    if([self.mainController isKindOfClass:[UINavigationController class]]) {
        UIViewController *viewController = [[note userInfo] valueForKey:NOTIF_PARAM_KEY_VIEW];
        if (viewController) {
            [((UINavigationController *)self.mainController) pushViewController:viewController animated:YES];
        }
    }
}
@end
