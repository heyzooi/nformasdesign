//
//  ImagensViewController.h
//  nFormas
//
//  Created by Victor Hugo on 10/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagensViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableDictionary *categories;
    NSArray *keysSorted;
    UITableView *tableView;
    UIActivityIndicatorView *activityIndicatorView;
    NSLock *lock;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
