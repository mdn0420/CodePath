//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "TweetTableCell.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweetData;

@end

@implementation TweetsViewController

static NSString *const TweetCellIdentifier = @"TweetTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Twitter";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:TweetCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TweetCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutPressed)];
	[leftButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(composeTweetPressed)];
	[rightButton setTintColor:[UIColor whiteColor]];
	self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setupRefresh];
    [self fetchHomeline:nil];
}

- (void)signOutPressed {
    TwitterClient *client = [TwitterClient instance];
    [client logout];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)composeTweetPressed {
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:compose animated:YES];
}

- (void)setupRefresh {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
}

- (void)handleRefresh:(id)sender {
    [self fetchHomeline:sender];
}

- (void)fetchHomeline:(UIRefreshControl *)refresh {
    TwitterClient *client = [TwitterClient instance];
    [client fetchHomeTimelineWithSuccess:^(NSMutableArray *tweetData) {
        if(refresh) {
            [refresh endRefreshing];
        }
        self.tweetData = tweetData;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TweetCellIdentifier];
    
    if(self.tweetData) {
        [cell setTweet:self.tweetData[indexPath.row]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetData ? self.tweetData.count : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.tweetData) {
        Tweet *tweet = [self.tweetData objectAtIndex:indexPath.row];
        if(tweet) {
            TweetDetailViewController *details = [[TweetDetailViewController alloc] init];
            details.tweet = tweet;
            [self.navigationController pushViewController:details animated:YES];
        } else {
            NSLog(@"Could not find tweet to show detail view");
        }
    }
}

@end
