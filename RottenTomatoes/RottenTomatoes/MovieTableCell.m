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

@property (strong, nonatomic) IBOutlet UILabel *mpaaLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
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
    if(movie) {
        self.titleLabel.text = movie.title;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d%%", movie.criticScore];
        self.scoreLabel.textColor = [UIColor colorWithRed:1-(movie.criticScore/100.0f) green:movie.criticScore/100.0f blue:0 alpha:1];
        self.mpaaLabel.text = movie.mpaaRating;
        [self.thumbView setImageWithURL: [NSURL URLWithString:movie.thumbUrl]];
    }
}

@end
