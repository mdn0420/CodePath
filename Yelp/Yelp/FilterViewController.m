//
//  FilterViewController.m
//  Yelp
//
//  Created by Minh Nguyen on 3/20/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCell.h"
#import "FilterSwitchCell.h"
#import "FilterSelectCell.h"
#import "YelpClient.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *expanded;
@property (nonatomic, strong) NSMutableArray *selection;

@end

@implementation FilterViewController

static NSString *const SECTION_KEY_NAME = @"name";
static NSString *const SECTION_KEY_TYPE = @"type";
static NSString *const SECTION_KEY_LIST = @"list";
static NSString *const SECTION_TYPE_RADIO = @"radio";
static NSString *const SECTION_TYPE_SWITCH = @"switch";
static NSString *const SwitchCellIdentifier = @"FilterSwitchCell";
static NSString *const SelectCellIdentifier = @"FilterSelectCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupNavButtons];
        self.sections = [NSMutableArray arrayWithObjects:
                         @{
                           SECTION_KEY_NAME:@"Most Popular",
                           SECTION_KEY_TYPE:SECTION_TYPE_SWITCH,
                           SECTION_KEY_LIST:@[@[@"Deals", @"0"]]
                           },
                         @{
                           SECTION_KEY_NAME:@"Distance",
                           SECTION_KEY_TYPE:SECTION_TYPE_RADIO,
                           SECTION_KEY_LIST:@[@[@"Auto", @"0"],
                                     @[@"2 blocks", @"50"],
                                     @[@"6 blocks", @"150"],
                                     @[@"1 mile", @"2000"],
                                     @[@"5 miles", @"10000"]]
                           },
                         @{
                           SECTION_KEY_NAME:@"Sort By",
                           SECTION_KEY_TYPE:SECTION_TYPE_RADIO,
                           SECTION_KEY_LIST:@[@[@"Best Match", @"0"],
                                     @[@"Distance", @"1"],
                                     @[@"Rating", @"2"]]
                           },
                         
                         nil
                         ];
    }
    return self;
}

- (void)setupNavButtons {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelButton)];
    leftButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelButton)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)onCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSearchButton {
    YelpClient *client = [YelpClient instance];
    // todo: apply filters
    [client runSearch];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCells];
    
    // todo: dynamically initialize
    self.expanded = [NSMutableArray arrayWithObjects:@NO, @NO, @NO,nil];
    self.selection = [NSMutableArray arrayWithObjects:@0, @0, @0,nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    [self.tableView reloadData];
}

// Load cell nibs
- (void)registerCells {
    UINib *nib = [UINib nibWithNibName:SwitchCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SwitchCellIdentifier];
    nib = [UINib nibWithNibName:SelectCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SelectCellIdentifier];
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
    return 39;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sect = self.sections[section];
    NSString *type = sect[SECTION_KEY_TYPE];
    NSArray *items = sect[SECTION_KEY_LIST];
    NSInteger count = 0;

    if(SECTION_TYPE_SWITCH == type) {
        count = items.count;
    } else {
        if([self isSectionExpanded:section] == YES) {
            count = items.count;
        } else {
            count = 1;
        }
    }

    return count;
}

- (BOOL) isSectionExpanded:(NSInteger) section {
    return [[self.expanded objectAtIndex:section] boolValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = self.sections[indexPath.section];
    NSString *sectionType = [self typeOfSection:indexPath.section];
    NSInteger labelIndex = indexPath.row;
    FilterCell *cell;
    
    if(SECTION_TYPE_RADIO == sectionType) {
        cell = [tableView dequeueReusableCellWithIdentifier:SelectCellIdentifier];
        if([self isSectionExpanded:indexPath.section] == NO) {
            labelIndex = [self.selection[indexPath.section] integerValue];
        } else {
            ((FilterSelectCell *) cell).downImage.hidden = YES;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
    }
    cell.nameLabel.text = section[SECTION_KEY_LIST][labelIndex][0];
    return cell;
}

- (NSString *)typeOfSection:(NSInteger) section {
    return self.sections[section][SECTION_KEY_TYPE];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    label.text = self.sections[section][SECTION_KEY_NAME];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL oldValue = [[self.expanded objectAtIndex:indexPath.section] boolValue];
    [self.expanded replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:!oldValue]];
    [self.selection replaceObjectAtIndex:indexPath.section withObject:@(indexPath.row)];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}


@end
