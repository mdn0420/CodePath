//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/12/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesManager.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoviesViewController

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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[MoviesManager instance] addDelegate:self];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Getting number of rows in section");
    MoviesManager *manager = [MoviesManager instance];
    return [manager getMovieCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesManager *manager = [MoviesManager instance];
    Movie *movie = [manager getMovieAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = movie.title;
    return cell;
}

#pragma mark - Movie Manager delegates

- (void)dataDownloaded {
    [self.tableView reloadData];
}

@end
