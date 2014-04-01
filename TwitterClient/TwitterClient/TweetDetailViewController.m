//
//  TweetDetailViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/31/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)replyPressed:(id)sender;
- (IBAction)retweetPressed:(id)sender;
- (IBAction)favoritePressed:(id)sender;


@end

@implementation TweetDetailViewController

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
    self.navigationItem.title = @"Tweet";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
	[leftButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.leftBarButtonItem = leftButton;
    
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyPressed)];
	[rightButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData {
    if(self.tweet && self.tweet.user) {
        Tweet *tweet = self.tweet;
        User *user = self.tweet.user;
        self.nameLabel.text = user.name;
        NSMutableString *screenName = [[NSMutableString alloc] initWithFormat:@"@%@", user.screen_name];
        self.screenNameLabel.text = screenName;
        [self.profileImage setImageWithURL: [NSURL URLWithString:user.profile_image_url]];
        self.statusLabel.text = tweet.text;
        self.timeLabel.text = tweet.timeString;
        self.favoriteButton.selected = tweet.favorited;
    } else {
        NSLog(@"Invalid data for TweetDetailViewController");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)replyPressed {
    
}

- (IBAction)replyPressed:(id)sender {
}

- (IBAction)retweetPressed:(id)sender {
}

- (IBAction)favoritePressed:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    TwitterClient *client = [TwitterClient instance];
    [client favoriteTweetWithId:self.tweet.tweetId toggle:self.favoriteButton.selected success:^{
        self.tweet.favorited = self.favoriteButton.selected;
    }];
}
@end
