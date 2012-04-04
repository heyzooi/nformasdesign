//
//  TwitterManager.h
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterManager : NSObject {

}

+(TwitterManager*) manager;

-(NSArray*)loadRSS;

-(int)getFollowers;

@end
