//
//  TwitterViewController.h
//  nFormas
//
//  Created by Victor Hugo on 13/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *tableView;
    NSArray *items;
    NSLock *lock;
    UILabel *followersLabel;
    UIActivityIndicatorView *activityIndicatorView;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UILabel *followersLabel;

-(IBAction)followMe;

@end
