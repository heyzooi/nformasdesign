//
//  BlogPostViewController.h
//  nFormas
//
//  Created by Victor Hugo on 03/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BlogRssItem.h"

@interface BlogPostViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    
    BlogRssItem *blogRssItem;
    UILabel *titleLabel;
    UILabel *dateLabel;
    
    UIWebView *webView;
    UITextView *textView;
    NSString *webViewHTML;
    
    NSURLRequest *request;
    
}

@property (nonatomic, retain) BlogRssItem *blogRssItem;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UITextView *textView;

-(IBAction)back;
-(IBAction)share;

-(void)shareWithTwitter;
-(void)shareWithFacebook;
-(void)shareWithDelicious;
-(void)shareWithGoogleBuzz;
-(void)shareWithEmail;

@end
