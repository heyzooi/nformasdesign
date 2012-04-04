//
//  AppDelegate_iPhone.h
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright HZ Apps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UITabBarDelegate> {
    
    UIWindow *window;
    UITabBarController *tabBarController;
    int lastIndexSelected;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

