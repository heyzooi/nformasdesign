//
//  ImagensViewController.m
//  nFormas
//
//  Created by Victor Hugo on 10/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImagensViewController.h"
#import "BlogRssManager.h"
#import "BlogRssItem.h"
#import "ImagemSlideShowViewController.h"

@implementation ImagensViewController

@synthesize tableView, activityIndicatorView;

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
    
    lock = [[NSLock alloc]init];
    
    [NSThread detachNewThreadSelector:@selector(loadRSS) toTarget:self withObject:nil];
}

-(void) viewDidAppear:(BOOL)animated {
    if ([tableView indexPathForSelectedRow] != nil) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}

-(void)loadRSS {
    if ([lock tryLock]) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        NSArray *items = [[BlogRssManager manager]loadRssBlog];
        categories = [[NSMutableDictionary alloc]initWithCapacity:10];
        NSMutableArray *array = nil;
        for (BlogRssItem *blogItem in items) {
            for (NSString *category in blogItem.categories) {
                array = [categories objectForKey:category];
                if (array == nil) {
                    array = [[NSMutableArray alloc]initWithCapacity:10];
                    [categories setObject:array forKey:category];
                    [array release];
                }
                [array addObject:blogItem];
            }
        }
        
        keysSorted = [[[categories allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]retain];
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
        
        [pool drain];
        
        [lock unlock];
    }
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [keysSorted count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [keysSorted objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagemSlideShowViewController *vc = [[ImagemSlideShowViewController alloc]initWithNibName:@"ImagemSlideShowViewController" bundle:nil];
    NSString *key = [keysSorted objectAtIndex:indexPath.row];
    vc.category = key;
    vc.items = [categories objectForKey:key];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [lock release];
    [categories release];
    [keysSorted release];
    
    self.tableView = nil;
    self.activityIndicatorView = nil;
    
    [super dealloc];
}

@end
