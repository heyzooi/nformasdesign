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
    NSString *urlString = @"https://api.twitter.com/1/statuses/user_timeline.json?screen_name=nformas_design";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSArray *array = [string JSONValue];
    [string release];
    if (!array) {
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
    }
    
    return array;
}

-(int)getFollowers {
    NSString *urlString = @"http://api.twitter.com/1/users/show.json?screen_name=nformas_design";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *responseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *response = [responseString JSONValue];
    NSNumber *followersCount = [response objectForKey:@"followers_count"];
    if (followersCount != nil) {
        return [followersCount intValue];
    }
    return 0;
}

@end
