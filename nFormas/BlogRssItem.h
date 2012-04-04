//
//  BlogRssItem.h
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogRssItem : NSObject {
    
    UIImage *image;
    NSString *title;
    NSString *link;
    NSString *comments;
    NSDate *pubDate;
    NSMutableArray *categories;
    NSString *guid;
    NSString *description;
    NSString *contentEncoded;
    
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSDate *pubDate;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *contentEncoded;

@end
