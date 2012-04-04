//
//  BlogTableViewCell.h
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogTableViewCell : UITableViewCell {
    
    UIImageView *imagePostView;
    UILabel *titlePostLabel;
    UILabel *bodyPostLabel;
    UILabel *datePostLabel;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imagePostView;
@property (nonatomic, retain) IBOutlet UILabel *titlePostLabel;
@property (nonatomic, retain) IBOutlet UILabel *bodyPostLabel;
@property (nonatomic, retain) IBOutlet UILabel *datePostLabel;

@end
