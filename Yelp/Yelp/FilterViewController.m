//
//  FilterViewController.m
//  Yelp
//
//  Created by Minh Nguyen on 3/20/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterSwitchCell.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (nonatomic, assign) BOOL sortExpanded;

@end

@implementation FilterViewController

static NSString *SwitchCellIdentifier = @"FilterSwitchCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupCancelButton];
        self.sections = [NSMutableArray arrayWithObjects:
                           @{
                            @"name":@"Sort By",
                            @"type":@"expandable",
                            @"list":@[@"Best Match",@"Distance",@"Rating",@"Most Reviewed"]
                           },
                           nil
                           ];
    }
    return self;
}

- (void)setupCancelButton {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelButton)];
    leftButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)onCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *switchCellNib = [UINib nibWithNibName:SwitchCellIdentifier bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:SwitchCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(self.sortExpanded) {
            return 39;
        } else {
            return indexPath.row > 0 ? 0 : 39;
        }
    }
    
    return 39;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.sections[section][@"list"];

    if(self.sortExpanded) {
        return items.count;;
    } else {
        return 1;
    }

    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterSwitchCell *cell = (FilterSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    label.text = self.sections[section][@"name"];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.sortExpanded = !self.sortExpanded;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}


@end
