//
//  ComposeViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/30/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
	[leftButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweetPressed)];
	[rightButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.rightBarButtonItem = rightButton;
    
    [self updateHeader];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)updateHeader {
    TwitterClient *client = [TwitterClient instance];
    User *currentUser = client.currentUser;
    if(currentUser) {
        self.nameLabel.text = currentUser.name;
        NSMutableString *screenName = [[NSMutableString alloc] initWithFormat:@"@%@", currentUser.screen_name];
        self.screenNameLabel.text = screenName;
        [self.profileImage setImageWithURL: [NSURL URLWithString:currentUser.profile_image_url]];
    } else {
        NSLog(@"No user credentials found for ComposeViewController");
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

- (void)tweetPressed {
    
}

@end
