//
//  StringUtil.h
//  nFormas
//
//  Created by Victor Hugo on 07/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringUtil : NSObject {

}

+(NSString *) reverseString:(NSString*) str;

+(NSRange) string:(NSString*)str rangeOfLastString:(NSString*) searchStr;

@end
