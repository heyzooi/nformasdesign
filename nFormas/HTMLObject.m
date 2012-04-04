//
//  HTMLObject.m
//  nFormas
//
//  Created by Victor Hugo on 07/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTMLObject.h"


@implementation HTMLObject

@synthesize params;

-(id) init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.params = dictionary;
        [dictionary release];
    }
    return self;
}

-(void) dealloc {
    self.params = nil;
    
    [super dealloc];
}

@end
