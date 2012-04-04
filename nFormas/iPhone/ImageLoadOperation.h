//
//  ImageLoadOperation.h
//  nFormas
//
//  Created by Victor Hugo on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogRssItem.h"

@interface ImageLoadOperation : NSOperation {
    
    BlogRssItem *item;
    NSURL *url;
    NSIndexPath *indexPath;
    UITableView *tableView;
    NSLock *lock;
    
}

@property (nonatomic, retain) BlogRssItem *item;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSLock *lock;

@end
