//
//  BlogViewController.m
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogListViewController.h"
#import "BlogRssXmlParser.h"
#import "BlogTableViewCell.h"
#import "BlogPostViewController.h"
#import "Reachability.h"
#import "BlogRssManager.h"
#import "ImageLoadOperation.h"

@implementation BlogListViewController

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
    if ([self.tableView indexPathForSelectedRow] != nil) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

-(void)loadRSS {
    while (![lock tryLock]) {
        [NSThread sleepForTimeInterval:1];
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (items != nil) {
        [items release];
    }
    items = [[[BlogRssManager manager] loadRssBlog] retain];
    
    [tableView reloadData];
    
    [activityIndicatorView stopAnimating];
    
    [pool drain];
    
    [lock unlock];
}

-(void)reload {
    if ([lock tryLock]) {
        [activityIndicatorView startAnimating];
        [lock unlock];
        [NSThread detachNewThreadSelector:@selector(loadRSS) toTarget:self withObject:nil];
    }
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [NSThread sleepForTimeInterval:3];
    
    [activityIndicatorView startAnimating];
    activityIndicatorView.hidden = NO;
    
    [NSThread detachNewThreadSelector:@selector(loadRSS) toTarget:self withObject:nil];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    BlogTableViewCell *cell = (BlogTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BlogTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    BlogRssItem *item = [items objectAtIndex:indexPath.row];
    
    if (item.image == nil) {
        cell.imageView.image = nil;
        cell.imageView.hidden = YES;
        cell.imageView.frame = CGRectNull;
        cell.titlePostLabel.frame = CGRectMake(10, 5, 280, 35);
        cell.bodyPostLabel.frame = CGRectMake(10, 45, 280, 30);
        cell.datePostLabel.frame = CGRectMake(10, 75, 280, 20);
        
        NSURL *url = nil;
        NSString *regex = @"<\\s*(i|I)(m|M)(g|G)\\s+[^<]*>";
        NSRange range = [item.contentEncoded rangeOfString:regex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *img = [item.contentEncoded substringWithRange:range];
            regex = @"\\s+(s|S)(r|R)(c|C)=\"[^\"]*\"";
            NSRange rangeSrc = [img rangeOfString:regex options:NSRegularExpressionSearch];
            if (rangeSrc.location != NSNotFound) {
                NSString *src = [img substringWithRange:rangeSrc];
                regex = @"\"[^\"]*\"";
                NSRange rangeValue = [src rangeOfString:regex options:NSRegularExpressionSearch];
                if (rangeValue.location != NSNotFound) {
                    NSString *value = [src substringWithRange:rangeValue];
                    url = [NSURL URLWithString:[value substringWithRange:NSMakeRange(1, [value length] - 2)]];
                }
            }
        }
        if (url != nil) {
            ImageLoadOperation *operation = [[ImageLoadOperation alloc]init];
            operation.lock = lock;
            operation.item = item;
            operation.url = url;
            operation.indexPath = indexPath;
            operation.tableView = self.tableView;
            [NSThread detachNewThreadSelector:@selector(start) toTarget:operation withObject:nil];
            [operation release];
        }
    } else {
        cell.imagePostView.image = item.image;
        cell.imagePostView.hidden = NO;
        cell.imagePostView.frame = CGRectMake(0, 0, 100, 100);
        cell.titlePostLabel.frame = CGRectMake(110, 5, 180, 35);
        cell.bodyPostLabel.frame = CGRectMake(110, 45, 180, 30);
        cell.datePostLabel.frame = CGRectMake(110, 75, 180, 20);
    }

    
    /*
    CGRect rect;
    CGSize size;
     */
    
    cell.titlePostLabel.text = item.title;
    /*
    rect = cell.titleLabel.frame;
    size = [cell.titleLabel.text sizeWithFont:cell.titleLabel.font constrainedToSize:rect.size lineBreakMode:cell.titleLabel.lineBreakMode];
    cell.titleLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, size.height);
     */

    cell.bodyPostLabel.text = [item.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    /*
    rect = cell.bodyLabel.frame;
    size = [cell.bodyLabel.text sizeWithFont:cell.bodyLabel.font constrainedToSize:rect.size lineBreakMode:cell.bodyLabel.lineBreakMode];
    cell.bodyLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, size.height);
     */
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"eee"];
    NSMutableString *buffer = [[NSMutableString alloc]initWithCapacity:32];
    [buffer appendString:[[df stringFromDate:item.pubDate]uppercaseString]];
    
    [df setDateFormat:@" dd MMM yyyy HH:mm"];
    [buffer appendString:[[df stringFromDate:item.pubDate]lowercaseString]];
    
    [df setDateFormat:@" zzz"];
    [buffer appendString:[df stringFromDate:item.pubDate]];
    
    cell.datePostLabel.text = buffer;
    
    [buffer release];
    [df release];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BlogPostViewController *vc = [[BlogPostViewController alloc]initWithNibName:@"BlogPostViewController" bundle:nil];
    vc.blogRssItem = [items objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void) tableView:(UITableView *)aTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:aTableView didSelectRowAtIndexPath:indexPath];
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
    [lock release];
    [items release];
    self.activityIndicatorView = nil;
    self.tableView = nil;
    
    [super dealloc];
}


@end
