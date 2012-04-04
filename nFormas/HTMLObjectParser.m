//
//  HTMLObject.m
//  nFormas
//
//  Created by Victor Hugo on 07/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTMLObjectParser.h"


@implementation HTMLObjectParser

@synthesize htmlObject;

-(void) parserDidStartDocument:(NSXMLParser *)parser {
    HTMLObject *htmlObj = [[HTMLObject alloc]init];
    self.htmlObject = htmlObj;
    [htmlObj release];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"param"]) {
        NSString *value = [attributeDict objectForKey:@"value"];
        NSString *key = [attributeDict objectForKey:@"name"];
        [htmlObject.params setObject:value forKey:key];
    }
}

-(void) dealloc {
    self.htmlObject = nil;
    
    [super dealloc];
}

@end
