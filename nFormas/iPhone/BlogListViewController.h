//
//  BlogViewController.h
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogRssItem.h"

@interface BlogListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    
    UITableView *tableView;
    NSArray *items;
    UIActivityIndicatorView *activityIndicatorView;
    NSLock *lock;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
