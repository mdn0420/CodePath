//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetTableCell.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetsViewController

static NSString *const TweetCellIdentifier = @"TweetTableCell";

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
    
    UINib *nib = [UINib nibWithNibName:TweetCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TweetCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TweetCellIdentifier];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
