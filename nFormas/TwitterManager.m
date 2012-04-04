//
//  TwitterManager.m
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterManager.h"
#import "TwitterXmlParser.h"
#import "Reachability.h"
#import "JSON.h"

@implementation TwitterManager

+(TwitterManager*) manager {
    static TwitterManager* twitterManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        twitterManagerInstance = [[TwitterManager alloc]init];
    });
    return twitterManagerInstance;
}

-(NSArray*)loadRSS {
    NSString *urlString = @"http://twitter.com/statuses/user_timeline/nformas_design.rss";
    NSURL *url = [NSURL URLWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    
    TwitterXmlParser *delegate = [[TwitterXmlParser alloc]init];
    xmlParser.delegate = delegate;
    
    BOOL result = [xmlParser parse];
    NSArray *array;
    if (result) {
        array = [[delegate.items retain] autorelease];
    } else {
        array = nil;
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
    
    [delegate release];
    [xmlParser release];
    
    return array;
}

-(int)getFollowers {
//    NSString *urlString = @"http://twitter.com/nformas_design";
    NSString *urlString = @"http://api.twitter.com/1/users/show.json?screen_name=nformas_design";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *response = [responseString JSONValue];
    NSNumber *followersCount = [response objectForKey:@"followers_count"];
    if (followersCount != nil) {
        return [followersCount intValue];
    }
    
//    NSRange range = [responseString rangeOfString:@"<span id=\"follower_count\" class=\"stats_count numeric\">.*(\\d)+.*</span>.*\\n.*<span class=\"label\">Followers</span>" options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound) {
//        NSString *htmlPart = [responseString substringWithRange:range];
//        range = [htmlPart rangeOfString:@"(\\d)+" options:NSRegularExpressionSearch];
//        if (range.location != NSNotFound) {
//            NSString *value = [htmlPart substringWithRange:range];
//            return atoi([value UTF8String]);
//        }
//    }
    
    return 0;
}

@end
