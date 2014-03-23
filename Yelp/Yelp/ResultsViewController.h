//
//  ResultsViewController.h
//  Yelp
//
//  Created by Minh Nguyen on 3/20/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpClient.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, YelpClientDelegate>

@end
