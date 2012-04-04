//
//  BlogTableViewCell.m
//  nFormas
//
//  Created by Victor Hugo on 30/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlogTableViewCell.h"


@implementation BlogTableViewCell

@synthesize imagePostView, titlePostLabel, bodyPostLabel, datePostLabel;

/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}
*/

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/

- (void)dealloc {
    self.imagePostView = nil;
    self.titlePostLabel = nil;
    self.bodyPostLabel = nil;
    self.datePostLabel = nil;
    
    [super dealloc];
}


@end
