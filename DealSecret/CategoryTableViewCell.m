//
//  CategoryTableViewCell.m
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "CategoryTableViewCell.h"

const CGFloat kCategoryCellPadding = 30.0f;

@interface CategoryTableViewCell ()

@end

@implementation CategoryTableViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, frame.size.height)];
        [self addSubview:self.backgroundImage];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(kCategoryCellPadding,
                                                                  kCategoryCellPadding,
                                                                  self.backgroundImage.frame.size.height
                                                                  - 2*kCategoryCellPadding,
                                                                  self.backgroundImage.frame.size.height
                                                                  - 2*kCategoryCellPadding)];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.icon];
        
        self.header = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.origin.x
                                                                + self.icon.frame.size.width,
                                                                15,
                                                                self.frame.size.width,
                                                                50.0f)];
        self.header.textColor = [UIColor whiteColor];
        [self addSubview:self.header];
        
        self.subHeader = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.origin.x
                                                                   + self.icon.frame.size.width,
                                                                   self.header.frame.origin.y
                                                                   + kCategoryCellPadding,
                                                                   self.frame.size.width,
                                                                   50.0f)];
        self.subHeader.textColor = [UIColor whiteColor];
        [self addSubview:self.subHeader];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.imageView.frame = self.frame;
}

@end
