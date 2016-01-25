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
        self.checkView = [[UIImageView alloc] init];
        self.checkView.image = [UIImage imageNamed:@"checkmark_unchecked"];
        
        [self addSubview:self.checkView];
    }
    return self;
}

- (void)layoutSubviews {
    self.textLabel.frame = CGRectMake(10.0f, 0.0, self.frame.size.width - 20.0f, self.frame.size.height);
    self.checkView.frame = CGRectMake(10.0f, (self.frame.size.height - 30.0f)/2, 30, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
