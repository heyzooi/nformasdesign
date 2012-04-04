//
//  TwitterRssItem.m
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterRssItem.h"


@implementation TwitterRssItem

@synthesize title, description, pubDate, guid, link, twitterSource, twitterPlace;

-(void) dealloc {
    self.title = nil;
    self.description = nil;
    self.pubDate = nil;
    self.guid = nil;
    self.link = nil;
    self.twitterSource = nil;
    self.twitterPlace = nil;
    
    [super dealloc];
}

@end
