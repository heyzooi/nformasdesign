//
//  BlogRssManager.h
//  nFormas
//
//  Created by Victor Hugo on 10/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlogRssManager : NSObject {
    
}

+(BlogRssManager*) manager;

-(NSArray*) loadRssBlog;

@end
