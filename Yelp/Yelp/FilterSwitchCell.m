//
//  FilterSwitchCell.m
//  Yelp
//
//  Created by Minh Nguyen on 3/23/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "FilterSwitchCell.h"

@interface FilterSwitchCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation FilterSwitchCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
