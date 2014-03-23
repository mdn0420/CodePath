//
//  ResultsViewController.m
//  Yelp
//
//  Created by Minh Nguyen on 3/20/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultTableCell.h"
#import "YelpClient.h"

@interface ResultsViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;

@end

@implementation ResultsViewController

static NSString *CellIdentifier = @"ResultTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [YelpClient instance];
        [self.client addDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *resultCellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:resultCellNib forCellReuseIdentifier:CellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setupFilterButton];
    self.navigationItem.titleView = self.searchBar;
    
    [self.client searchWithTerm:@""];
}

- (void)setupFilterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Filter" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button.layer setCornerRadius:2.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    
    button.frame=CGRectMake(0.0, 100.0, 60.0, 28.0);
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.filterButton];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) onLeftButton {
    
}

#pragma mark - Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.client getResultCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableCell *cell = (ResultTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ROBusiness *business = [self.client getBusinessAtIndex:indexPath.row];
    if(business) {
        cell.business = business;
    }
    return cell;
}

#pragma mark - Yelp Client Delegate
- (void)dataDownloaded {
    [self.tableView reloadData];
}

@end
