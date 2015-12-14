//
//  DealTableViewCell.m
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2f];
    
    self.dealLabel.textColor = [UIColor whiteColor];
    self.companyLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
