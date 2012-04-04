//
//  BlogRssItem.m
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogRssItem.h"


@implementation BlogRssItem

@synthesize image;
@synthesize title;
@synthesize link;
@synthesize comments;
@synthesize pubDate;
@synthesize categories;
@synthesize guid;
@synthesize description;
@synthesize contentEncoded;

-(void) dealloc {
    self.image = nil;
    self.title = nil;
    self.link = nil;
    self.comments = nil;
    self.pubDate = nil;
    self.categories = nil;
    self.guid = nil;
    self.description = nil;
    self.contentEncoded = nil;
    
    [super dealloc];
}

@end
