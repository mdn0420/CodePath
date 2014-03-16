//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/12/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesManager.h"
#import "MovieTableCell.h"
#import "MBProgressHUD.h"

@interface MoviesViewController ()

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;

@end

@implementation MoviesViewController

static NSString *CellIdentifier = @"MovieTableCell";

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UINib *movieCellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:CellIdentifier];
    
    self.networkErrorView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    MoviesManager *manager = [MoviesManager instance];
    [manager addDelegate:self];
    [manager fetchData];
    
    [self setupRefresh];
}

- (void)setupRefresh {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl = refresh;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MoviesManager *manager = [MoviesManager instance];
    return [manager getMovieCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesManager *manager = [MoviesManager instance];
    Movie *movie = [manager getMovieAtIndex:indexPath.row];
    
    MovieTableCell *cell = (MovieTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.movie = movie;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - Movie Manager delegates

- (void)dataDownloaded {
    self.networkErrorView.hidden = YES;
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFailed {
    self.networkErrorView.hidden = NO;
}

@end
