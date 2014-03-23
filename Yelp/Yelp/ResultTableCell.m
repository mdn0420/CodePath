//
//  ResultTableCell.m
//  Yelp
//
//  Created by Minh Nguyen on 3/20/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "ResultTableCell.h"
#import "UIImageView+AFNetworking.h"

@interface ResultTableCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UIView *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation ResultTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(ROBusiness *)business {
    _business = business;
    [self reloadData];
}

- (void)reloadData {
    if(self.business) {
        ROBusiness *b = self.business;
        self.nameLabel.text = b.name;
        [self.profileImage setImageWithURL:[NSURL URLWithString:b.image_url]];
        [self.ratingImage setImageWithURL:[NSURL URLWithString:b.rating_img_url]];
    }
}

@end
