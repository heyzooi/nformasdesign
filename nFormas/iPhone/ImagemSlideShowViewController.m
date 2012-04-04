//
//  ImagemSlideShowViewController.m
//  nFormas
//
//  Created by Victor Hugo on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImagemSlideShowViewController.h"
#import "BlogRssItem.h"

@implementation ImagemSlideShowViewController

@synthesize category, items, webView, titleLabel;

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
    
    titleLabel.text = category;
    
    NSString *base = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *buffer = [NSMutableString stringWithCapacity:4096];
    for (BlogRssItem *item in items) {
        NSString *regex = @"<\\s*(img|IMG)\\s+[^<]*>";
        NSRange rangeRegex = [item.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(0, [item.contentEncoded length])];
        int idx;
        while (rangeRegex.location != NSNotFound) {
            [buffer appendFormat:@"%@\n        ", [item.contentEncoded substringWithRange:rangeRegex]];
            
            idx = rangeRegex.location + rangeRegex.length;
            rangeRegex = [item.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(idx, [item.contentEncoded length] - idx)];
        }
    }
    NSString *value = [buffer copy];
    NSString *html = [NSString stringWithFormat:base, value];
    [value release];

    [webView loadHTMLString:html baseURL:nil];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)dealloc {
    self.category = nil;
    self.items = nil;
    self.webView = nil;
    
    [super dealloc];
}


@end
