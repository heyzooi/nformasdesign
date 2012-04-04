//
//  TwitterRssItem.h
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TwitterRssItem : NSObject {
    
    NSString *title;
    NSString *description;
    NSDate *pubDate;
    NSString *guid;
    NSString *link;
    NSString *twitterSource;
    NSString *twitterPlace;
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate *pubDate;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *twitterSource;
@property (nonatomic, retain) NSString *twitterPlace;

@end
