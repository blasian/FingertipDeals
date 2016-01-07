//
//  SubCategoryTableViewCell.m
//  DealSecret
//
//  Created by Michael Spearman on 12/23/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "SubCategoryTableViewCell.h"

@implementation SubCategoryTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.textLabel.frame = CGRectMake(75, 0, self.frame.size.width - 75, self.frame.size.height);
        self.checkView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.checkView.image = [UIImage imageNamed:@"checkmark_unchecked"];
        
        [self addSubview:self.checkView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
