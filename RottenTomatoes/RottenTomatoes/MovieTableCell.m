//
//  MovieTableCell.m
//  RottenTomatoes
//
//  Created by Minh Nguyen on 3/15/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MovieTableCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieTableCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *thumbView;

@end

@implementation MovieTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public methods
- (void)setMovie:(Movie *)movie {
    self.titleLabel.text = movie.title;    
    [self.thumbView setImageWithURL: [NSURL URLWithString:movie.posterUrl]];
}

@end
