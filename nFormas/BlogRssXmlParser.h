//
//  BlogRssXmlParser.h
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogRssItem.h"

@interface BlogRssXmlParser : NSObject <NSXMLParserDelegate> {
    
    NSMutableArray *items;
    BlogRssItem *blogRssItem;
    NSMutableString *buffer;
    
    NSDateFormatter *dateFormatter;
    
}

@property (nonatomic, readonly) NSMutableArray *items;

@end
