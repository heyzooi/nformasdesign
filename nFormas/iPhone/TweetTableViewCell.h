//
//  TweetTableViewCell.h
//  nFormas
//
//  Created by Victor Hugo on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetTableViewCell : UITableViewCell {
    
    UILabel *tweetLabel;
    
}

@property (nonatomic, retain) IBOutlet UILabel *tweetLabel;

@end
