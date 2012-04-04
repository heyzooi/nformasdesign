//
//  HTMLObject.h
//  nFormas
//
//  Created by Victor Hugo on 07/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLObject.h"

@interface HTMLObjectParser : NSObject <NSXMLParserDelegate> {
    
    HTMLObject *htmlObject;
    
}

@property (nonatomic, retain) HTMLObject *htmlObject;

@end
