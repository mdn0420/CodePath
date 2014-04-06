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
- (BOOL)isMenuClosed;
@end

NSString * const NOTIF_PUSH_VIEW = @"Notif_PushView";
NSString * const NOTIF_POP_ROOT_VIEW = @"Notif_PopRootView";
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
    [self.contentView addSubview:self.mainController.view];
    [self.menuView addSubview:self.menuController.view];
    contentOrigCenter = CGPointMake(self.view.center.x, self.contentView.center.y);
    offScreen = CGPointMake(self.contentView.center.x + self.contentView.frame.size.width, self.contentView.center.y);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewController:) name:NOTIF_PUSH_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popRootViewController:) name:NOTIF_POP_ROOT_VIEW object:nil];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGPoint point = CGPointMake(touchPoint.x + self.contentView.frame.size.width/2, contentOrigCenter.y);
    if(point.x < contentOrigCenter.x) {
        point.x = contentOrigCenter.x;
    }
    
    
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.center = point;
        } completion:^(BOOL finished) {
            
        }];
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        if(![self isMenuClosed]) {
            self.contentView.center = point;
        }
    } else if(sender.state == UIGestureRecognizerStateEnded) {
        if(velocity.x < 0) {
            [self closeMenu];
        } else {
            [self openMenu];
        }
    }
}

- (BOOL)isMenuClosed {
    return CGPointEqualToPoint(offScreen, self.contentView.center);
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

- (void)popRootViewController:(NSNotification *)note {
    [self closeMenu];
    if (self.mainController) {
        [((UINavigationController *)self.mainController) popToRootViewControllerAnimated:NO];
    }
}
@end
