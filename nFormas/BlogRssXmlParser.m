//
//  BlogRssXmlParser.m
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogRssXmlParser.h"


@implementation BlogRssXmlParser

@synthesize items;

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
    items = [[NSMutableArray alloc]initWithCapacity:10];
    buffer = [[NSMutableString alloc]initWithCapacity:64];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [locale release];
    
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZ"];
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {
    [buffer release];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        blogRssItem = [[BlogRssItem alloc]init];
    }
    [buffer setString:@""];
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [buffer replaceOccurrencesOfString:@"&#8230;" withString:@"..." options:NSCaseInsensitiveSearch range:NSMakeRange(0, [buffer length])];
    [buffer replaceOccurrencesOfString:@"&#8220;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [buffer length])];
    [buffer replaceOccurrencesOfString:@"&#8221;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [buffer length])];
    if ([elementName isEqualToString:@"item"]) {
        [items addObject:blogRssItem];
        [blogRssItem release];
    } else if ([elementName isEqualToString:@"title"]) {
        NSString* title = [buffer copy];
        blogRssItem.title = title;
        [title release];
    } else if ([elementName isEqualToString:@"pubDate"]) {
        NSString *pubDate = [buffer copy];
        blogRssItem.pubDate = [dateFormatter dateFromString:pubDate];
        [pubDate release];
    } else if ([elementName isEqualToString:@"link"]) {
        NSString* link = [buffer copy];
        blogRssItem.link = link;
        [link release];
    } else if ([elementName isEqualToString:@"comments"]) {
        NSString *comments = [buffer copy];
        blogRssItem.comments = comments;
        [comments release];
    } else if ([elementName isEqualToString:@"description"]) {
        NSString *description = [buffer copy];
        blogRssItem.description = description;
        [description release];
    } else if ([elementName isEqualToString:@"content:encoded"]) {
        NSString* contentEncoded = [buffer copy];
        blogRssItem.contentEncoded = contentEncoded;
        [contentEncoded release];
    } else if ([elementName isEqualToString:@"category"]) {
        if (blogRssItem.categories == nil) {
            NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:10];
            blogRssItem.categories = array;
            [array release];
        }
        NSString *categories = [buffer copy];
        [blogRssItem.categories addObject:categories];
        [categories release];
    }
    [buffer setString:@""];
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [buffer appendString:string];
}

-(void) dealloc
{
    [items release];
    [dateFormatter release];
    
    [super dealloc];
}

@end
