//
//  TipViewController.m
//  TipCalculator
//
//  Created by Minh Nguyen on 3/11/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)onSettingsButton;
- (void)loadDefaultTip;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)loadDefaultTip {
    // todo: seperate out into utility class
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int index = [defaults integerForKey:@"default_tip_index"];
    if(index >= 0 && index < self.tipControl.numberOfSegments) {
        self.tipControl.selectedSegmentIndex = index;
    }
}

- (void)loadAndUpdate {
    [self loadDefaultTip];
    [self updateValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadAndUpdate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAndUpdate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    
    float totalAmount = billAmount + tipAmount;
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}
@end
