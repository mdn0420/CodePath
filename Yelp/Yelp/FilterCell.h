//
//  FilterCell.h
//  Yelp
//
//  Created by Minh Nguyen on 3/23/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) id value;

@end
