//
//  ImageLoadOperation.m
//  nFormas
//
//  Created by Victor Hugo on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageLoadOperation.h"


@implementation ImageLoadOperation

@synthesize item, url, indexPath, tableView, lock;

-(void) start {
    while (![lock tryLock]) {
        [NSThread sleepForTimeInterval:1];
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    item.image = [UIImage imageWithData:data];
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    
    [pool drain];
    
    [lock unlock];
}

-(void) dealloc {
    self.lock = nil;
    self.item = nil;
    self.url = nil;
    self.indexPath = nil;
    self.tableView = nil;
    
    [super dealloc];
}

@end
