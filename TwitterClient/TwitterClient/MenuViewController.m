//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MenuViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"
#import "HomeTweetFetcher.h"
#import "MentionsTweetFetcher.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

- (IBAction)onViewProfile:(id)sender;
- (IBAction)onViewHomeline:(id)sender;
- (IBAction)onViewMentions:(id)sender;


@end

@implementation MenuViewController

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
    [self refreshData];
}

- (void)refreshData {
    TwitterClient *client = [TwitterClient instance];
    User *currUser = client.currentUser;
    if(currUser) {
        self.nameLabel.text = currUser.name;
        self.screenNameLabel.text = currUser.screenNameFormatted;
        [self.profileImage setImageWithURL: [NSURL URLWithString:currUser.profile_image_url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onViewProfile:(id)sender {
    ProfileViewController *profileView = [[ProfileViewController alloc] init];
    TwitterClient *client = [TwitterClient instance];
    profileView.user = client.currentUser;
    NSDictionary *notifParams = [NSDictionary dictionaryWithObject:profileView forKey:NOTIF_PARAM_KEY_VIEW];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_PUSH_VIEW object:self userInfo:notifParams];
}

- (IBAction)onViewHomeline:(id)sender {
    HomeTweetFetcher *fetcher = [[HomeTweetFetcher alloc] init];
    NSDictionary *notifParams = [NSDictionary dictionaryWithObject:fetcher forKey:@"updateFetcherParam"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFetcher" object:self userInfo:notifParams];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_POP_ROOT_VIEW object:self];
}

- (IBAction)onViewMentions:(id)sender {
    MentionsTweetFetcher *fetcher = [[MentionsTweetFetcher alloc] init];
    NSDictionary *notifParams = [NSDictionary dictionaryWithObject:fetcher forKey:@"updateFetcherParam"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFetcher" object:self userInfo:notifParams];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_POP_ROOT_VIEW object:self];
}
@end
