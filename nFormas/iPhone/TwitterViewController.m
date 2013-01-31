//
//  TwitterViewController.m
//  nFormas
//
//  Created by Victor Hugo on 13/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterManager.h"
#import "TwitterRssItem.h"

@implementation TwitterViewController

@synthesize tableView, activityIndicatorView, followersLabel;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void)loadRSS {
    while (![lock tryLock]) {
        [NSThread sleepForTimeInterval:1];
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (items != nil) {
        [items release];
    }
    TwitterManager *manager = [TwitterManager manager];
    followersLabel.text = [NSString stringWithFormat:@"%i followers", [manager getFollowers]];
    items = [[manager loadRSS] retain];
    
    [tableView reloadData];
    
    [activityIndicatorView stopAnimating];
    
    [pool drain];
    
    [lock unlock];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView.separatorColor = [UIColor clearColor];
    lock = [[NSLock alloc]init];
    
    [NSThread detachNewThreadSelector:@selector(loadRSS) toTarget:self withObject:nil];
}

-(void)reload {
    if ([lock tryLock]) {
        [activityIndicatorView startAnimating];
        [lock unlock];
        [NSThread detachNewThreadSelector:@selector(loadRSS) toTarget:self withObject:nil];
    }
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
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TweetTableViewCell *cell = (TweetTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TweetTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    NSDictionary *item = [items objectAtIndex:indexPath.row];
    cell.tweetLabel.text = item[@"text"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)followMe {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/nformas_design"]];
}

- (void)dealloc {
    [lock release];
    [items release];
    self.tableView = nil;
    self.followersLabel = nil;
    self.activityIndicatorView = nil;
    
    [super dealloc];
}


@end
