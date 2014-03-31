//
//  TweetTableCell.m
//  TwitterClient
//
//  Created by Minh Nguyen on 3/26/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "TweetTableCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation TweetTableCell

Tweet *_tweet;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self refreshData];
}

- (void)refreshData {
    if(_tweet) {
        self.tweetLabel.text = _tweet.text;
        NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:_tweet.user.name];
        UIColor *color = [UIColor grayColor];
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        [name appendAttributedString:[[NSAttributedString alloc] initWithString:@" @"]];
        [name appendAttributedString:[[NSAttributedString alloc] initWithString:_tweet.user.screen_name]];
        [name setAttributes:attributes range:NSMakeRange(_tweet.user.name.length, _tweet.user.screen_name.length+2)];
        self.nameLabel.attributedText = name;
        [self.profileImage setImageWithURL: [NSURL URLWithString:_tweet.user.profile_image_url]];
    }
}

@end
