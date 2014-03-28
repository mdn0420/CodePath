//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self registerNotifications];
    
    TwitterClient *client = [TwitterClient instance];
    if([client isLoggedIn]) {
        [self showHomeTimeline];
    } else {
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showHomeTimeline {
    UINavigationController *nvc = [[UINavigationController alloc] init];
    TweetsViewController *home = [[TweetsViewController alloc] init];
    [nvc pushViewController:home animated:NO];
    self.window.rootViewController = nvc;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserAuthenticate) name:NOTIF_USER_AUTHENTICATED object:nil];
}

- (void)didUserAuthenticate {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIF_USER_AUTHENTICATED object:nil];
    [self showHomeTimeline];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"mntwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            TwitterClient *client = [TwitterClient instance];
            [client fetchAccessTokenWithUrl:url];
        }
        return YES;
    }
    return NO;
}

@end
