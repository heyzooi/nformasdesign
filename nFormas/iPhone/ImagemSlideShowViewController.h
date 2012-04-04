//
//  ImagemSlideShowViewController.h
//  nFormas
//
//  Created by Victor Hugo on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImagemSlideShowViewController : UIViewController {
    
    NSString *category;
    NSArray *items;
    UIWebView *webView;
    UILabel *titleLabel;
    
}

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

-(IBAction)back;

@end
