//
//  TwitterXmlParser.h
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterRssItem.h"

@interface TwitterXmlParser : NSObject <NSXMLParserDelegate> {
    
    NSMutableArray *items;
    
    NSMutableString *buffer;
    
    NSDateFormatter *dateFormatter;
    
    TwitterRssItem *twitterRssItem;
    
}

@property (nonatomic, readonly) NSArray *items;

@end
