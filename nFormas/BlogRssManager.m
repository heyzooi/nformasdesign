//
//  BlogRssManager.m
//  nFormas
//
//  Created by Victor Hugo on 10/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogRssManager.h"
#import "BlogRssXmlParser.h"
#import "Reachability.h"

@implementation BlogRssManager

+(BlogRssManager*) manager
{
    static BlogRssManager* blogRssManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blogRssManagerInstance = [[BlogRssManager alloc]init];
    });
    return blogRssManagerInstance;
}

-(NSArray*) loadRssBlog
{
    NSString *urlString = @"http://nformasdesign.com/blog/?feed=rss2";
    NSURL *url = [NSURL URLWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    BlogRssXmlParser *blogRssXmlParser = [[BlogRssXmlParser alloc]init];
    xmlParser.delegate = blogRssXmlParser;
    
    BOOL result = [xmlParser parse];
    NSArray *items;
    if (result) {
        items = [[blogRssXmlParser.items retain] autorelease];
    } else {
        items = nil;
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sem conexão com a internet" message:@"Por favor, conecte na internet!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [alertView release];
        } else if ([[Reachability reachabilityWithHostName:@"nformasdesign.com"] currentReachabilityStatus] == NotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Falha na obtenção das informações" message:@"Ocorreu uma falha ao obter as informações em nFormasDesign.com." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [alertView release];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Falha na obtenção das informações" message:@"Ocorreu uma falha nas informações em nFormasDesign.com." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [alertView release];
        }
    }
    
    [blogRssXmlParser release];
    [xmlParser release];
    
    return items;
}

@end
