//
//  StringUtil.m
//  nFormas
//
//  Created by Victor Hugo on 07/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StringUtil.h"


@implementation StringUtil

+(NSString *) reverseString:(NSString*) str {
    NSMutableString *reversedStr = nil;
    int len = [str length];
    
    // Auto released string
    reversedStr = [NSMutableString stringWithCapacity:len];     
    
    // Probably woefully inefficient...
    while (len > 0) {
        [reversedStr appendString:[NSString stringWithFormat:@"%C", [str characterAtIndex:--len]]];
    }
    
    return reversedStr;
}

+(NSRange) string:(NSString*)str rangeOfLastString:(NSString*) searchStr {
    NSString *strReverse = [self reverseString:str];
    NSRange range = [strReverse rangeOfString:[self reverseString: searchStr]];
    return NSMakeRange([str length] - range.location, range.length);
}

@end
