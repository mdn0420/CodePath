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
#import "FilterViewController.h"

@interface ResultsViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;

@end

@implementation ResultsViewController

static NSString *CellIdentifier = @"ResultTableCell";
static ResultTableCell *_protoCell;

static NSString *DEFAULT_NAME_STRING = @"Name"; // string used to calculate default height
static CGRect _defaultNameBounds; // Used to store default label height

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
    
    self.searchBar.delegate = self;
    
    [self setupFilterButton];
    self.navigationItem.titleView = self.searchBar;
    
    [self runSearch];
}

- (void)runSearch {
    self.client.searchTerm = self.searchBar.text;
    [self.client runSearch];
}

- (void)setupFilterButton {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(onLeftButton)];
    leftButton.tintColor = [UIColor whiteColor];
    
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

- (void)onLeftButton {
    FilterViewController *fvc = [[FilterViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}

#pragma mark - Search Bar delegates
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self runSearch];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Table view delegates
- (ResultTableCell *)protoCell {
    if(!_protoCell) {
        _protoCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _protoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 100; // default size
    ResultTableCell *proto = [self protoCell];
    if(CGRectIsEmpty(_defaultNameBounds)) {
        _defaultNameBounds = [self getBoundsWithString:DEFAULT_NAME_STRING label:proto.nameLabel];
    }
    
    ROBusiness *business = [self.client getBusinessAtIndex:indexPath.row];
    CGRect bounds = [self getBoundsWithString:business.name label:proto.nameLabel];
    result += bounds.size.height - _defaultNameBounds.size.height;
    //NSLog(@"Row: %d Height: %f Width: %f", indexPath.row, bounds.size.height, bounds.size.width);
    return result;
}

- (CGRect)getBoundsWithString:(NSString *)str label:(UILabel *)label {
    NSDictionary *attributes = @{NSFontAttributeName: label.font};
    return [str boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Yelp Client Delegate
- (void)dataDownloaded {
    [self.tableView reloadData];
}

@end
