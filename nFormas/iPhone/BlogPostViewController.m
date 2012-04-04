//
//  BlogPostViewController.m
//  nFormas
//
//  Created by Victor Hugo on 03/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogPostViewController.h"
#import "HTMLObjectParser.h"
#import "StringUtil.h"

@implementation BlogPostViewController

@synthesize blogRssItem, titleLabel, dateLabel, webView, textView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleLabel.text = blogRssItem.title;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"eee"];
    NSMutableString *buffer = [[NSMutableString alloc]initWithCapacity:32];
    [buffer appendString:[[df stringFromDate:blogRssItem.pubDate]uppercaseString]];
    
    [df setDateFormat:@" dd MMM yyyy HH:mm"];
    [buffer appendString:[[df stringFromDate:blogRssItem.pubDate]lowercaseString]];
    
    [df setDateFormat:@" zzz"];
    [buffer appendString:[df stringFromDate:blogRssItem.pubDate]];
    
    NSString *date = [buffer copy];
    
    [buffer release];
    [df release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"post" ofType:@"html"];
    NSMutableString *html = [[NSMutableString alloc]initWithCapacity:4096];
    [html appendFormat:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil], date, blogRssItem.contentEncoded];
    [date release];
    
    NSURL *url = [[NSBundle mainBundle] bundleURL];
    
    NSRange range = [html rangeOfString:@"<object "];
    while (range.length > 0) {
        NSRange endRange = [html rangeOfString:@"</object>" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location, [html length] - range.location)];
        NSRange objRange = NSMakeRange(range.location, endRange.location - range.location + range.length + 1);
        NSString *htmlObj = [html substringWithRange:objRange];
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[htmlObj dataUsingEncoding:NSUTF8StringEncoding]];
        HTMLObjectParser *htmlObjDelegate = [[HTMLObjectParser alloc] init];
        parser.delegate = htmlObjDelegate;
        
        [parser parse];
        
        NSString *src = [htmlObjDelegate.htmlObject.params objectForKey:@"src"];
        
        [htmlObjDelegate release];
        [parser release];
        
//        endRange = [src rangeOfString:@"&"];
//        NSRange startRange = [StringUtil string:src rangeOfLastString:@"/"];
//        NSString *videoKey = nil;
//        if (endRange.length > 0) {
//            videoKey = [src substringWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location)];
//        } else {
//            videoKey = [src substringWithRange:NSMakeRange(startRange.location, [src length] - startRange.location)];
//        }
//        NSString *replaceStr = [NSString stringWithFormat:@"<a href=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"><img class=\"aligncenter\" width=\"100%%\" src=\"http://i1.ytimg.com/vi/%@/default.jpg\"/></a>", videoKey, videoKey];
        
        NSString *replaceStr = [NSString stringWithFormat:@"<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"100%%\"></embed>", src];
        [html replaceCharactersInRange:objRange withString:replaceStr];
        
        range = [html rangeOfString:@"<object "];
    }
    
    range = [StringUtil string:html rangeOfLastString:@"<div class=\"shr-bookmarks shr-bookmarks-expand shr-bookmarks-center shr-bookmarks-bg-knowledge\">"];
    if (range.length > 0) {
        [html deleteCharactersInRange:NSMakeRange(range.location - range.length, [html length] - (range.location - range.length))];
    }
    
    webViewHTML = [html retain];
    [webView loadHTMLString:html baseURL:url];
    
    [html release];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)requestTmp navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result = [[[requestTmp URL] description] hasPrefix:@"file://"];
    if (!result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Abrir URL no browser?" message:@"Tem certeza que deseja sair da aplicação e abrir a URL no browser?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Abrir", nil];
        request = [requestTmp retain];
        [alertView show];
        [alertView release];
    }
    return result;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[UIApplication sharedApplication] openURL:[request URL]];
            break;
        default:
            break;
    }
    [request release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)share {
    UIActionSheet *actionSheet = nil;
    if ([MFMailComposeViewController canSendMail]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Compartilhar no..."
                                             delegate:self
                                             cancelButtonTitle:@"Cancelar"
                                             destructiveButtonTitle:nil
                                             otherButtonTitles: @"Twitter",
                                                                @"Facebook",
                                                                @"Delicious",
                                                                @"Google Buzz",
                                                                @"E-Mail",
                                                                nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Compartilhar no..."
                                             delegate:self
                                             cancelButtonTitle:@"Cancelar"
                                             destructiveButtonTitle:nil
                                             otherButtonTitles: @"Twitter",
                                                                @"Facebook",
                                                                @"Delicious",
                                                                @"Google Buzz",
                                                                nil];
    }
    if (actionSheet != nil) {
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}

-(void)shareWithTwitter {
    NSString *url = nil;
    NSString *regex = @"<\\s*a\\s*href=\"http://(w{3}.)?twitter\\.com/home\\?status=.*</\\s*a\\s*>";
    NSRange range = [blogRssItem.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *shareTwitter = [blogRssItem.contentEncoded substringWithRange:range];
        regex = @"href=\"[^\"]*\"";
        NSRange range = [shareTwitter rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *href = [shareTwitter substringWithRange:range];
            url = [[href substringWithRange:NSMakeRange(6, [href length] - 7)] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
    }
    if (url != nil) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

-(void)shareWithFacebook {
    NSString *url = nil;
    NSString *regex = @"<\\s*a\\s*href=\"http://www.facebook.com/share.php\\?.*</a>";
    NSRange range = [blogRssItem.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *shareFacebook = [blogRssItem.contentEncoded substringWithRange:range];
        regex = @"href=\"[^\"]*\"";
        NSRange range = [shareFacebook rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *href = [shareFacebook substringWithRange:range];
            url = [[href substringWithRange:NSMakeRange(6, [href length] - 7)] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
    }
    if (url != nil) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

-(void)shareWithDelicious {
    NSString *url = nil;
    NSString *regex = @"<\\s*a\\s*href=\"http://(w{3}.)?delicious\\.com/post\\?url=.*</\\s*a\\s*>";
    NSRange range = [blogRssItem.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *shareFacebook = [blogRssItem.contentEncoded substringWithRange:range];
        regex = @"href=\"[^\"]*\"";
        NSRange range = [shareFacebook rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *href = [shareFacebook substringWithRange:range];
            url = [[href substringWithRange:NSMakeRange(6, [href length] - 7)] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
    }
    if (url != nil) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

-(void)shareWithGoogleBuzz {
    NSString *url = nil;
    NSString *regex = @"<\\s*a\\s*href=\"http://(w{3}.)?google\\.com/buzz/post\\?url=.*</\\s*a\\s*>";
    NSRange range = [blogRssItem.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *shareFacebook = [blogRssItem.contentEncoded substringWithRange:range];
        regex = @"href=\"[^\"]*\"";
        NSRange range = [shareFacebook rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *href = [shareFacebook substringWithRange:range];
            url = [[href substringWithRange:NSMakeRange(6, [href length] - 7)] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
    }
    if (url != nil) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

-(void)shareWithEmail {
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:[NSString stringWithFormat:@"[nFormas Design] %@", blogRssItem.title]];
    [mailVC setMessageBody:webViewHTML isHTML:YES];
    [self presentModalViewController:mailVC animated:YES];
    [mailVC release];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet release];
    switch (buttonIndex) {
        case 0: //Twitter
            [self shareWithTwitter];
            break;
        case 1: //Facebook
            [self shareWithFacebook];
            break;
        case 2: //Delicious
            [self shareWithDelicious];
            break;
        case 3: //Google Buzz
            [self shareWithGoogleBuzz];
            break;
        case 4: //E-Mail
            if ([MFMailComposeViewController canSendMail]) {
                [self shareWithEmail];
            }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    self.blogRssItem = nil;
    self.titleLabel = nil;
    self.dateLabel = nil;
    self.webView = nil;
    self.textView = nil;
    [webViewHTML release];
    
    [super dealloc];
}


@end
