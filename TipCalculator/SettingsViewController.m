//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Minh Nguyen on 3/11/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

- (IBAction)onTipSelect:(id)sender;

@end

@implementation SettingsViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int index = [defaults integerForKey:@"default_tip_index"];
    if(index >= 0 && index < self.defaultTipControl.numberOfSegments) {
        self.defaultTipControl.selectedSegmentIndex = index;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTipSelect:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTipControl.selectedSegmentIndex forKey:@"default_tip_index"];
    [defaults synchronize];
}

@end
