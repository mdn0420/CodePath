//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 4/2/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;

@end

@implementation ProfileViewController

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
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    User *u = self.user;
    if(u) {
        self.nameLabel.text = u.name;
        self.screenNameLabel.text = u.screenNameFormatted;
        [self.profileImage setImageWithURL: [NSURL URLWithString:u.profile_image_url]];
        self.numTweetsLabel.text = [NSString stringWithFormat:@"%@", u.statuses_count];
        self.numFollowersLabel.text = [NSString stringWithFormat:@"%@", u.followers_count];
        self.numFollowingLabel.text = [NSString stringWithFormat:@"%@", u.friends_count];
    }
}

- (void)setUser:(User *)user {
    _user = user;
    [self refreshData];
}

@end
