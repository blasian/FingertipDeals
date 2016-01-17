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
        self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
        self.backgroundImage.clipsToBounds = YES;
        [self addSubview:self.backgroundImage];
        
        self.icon = [[UIImageView alloc] init];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.icon];
        
        self.header = [[UILabel alloc] init];
        self.header.textColor = [UIColor whiteColor];
        [self addSubview:self.header];
        
        self.subHeader = [[UILabel alloc] init];
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
    self.icon.frame = CGRectMake(kCategoryCellPadding,
                                 self.frame.size.height/2 - 50.0f/2,
                                 50.0f,
                                 50.0f);
    self.header.frame = CGRectMake(self.icon.frame.origin.x
                                   + self.icon.frame.size.width
                                   + kCategoryCellPadding,
                                   self.frame.size.height/2 - 50.0f/2,
                                   self.frame.size.width,
                                   20.0f);
    [self.header sizeToFit];
    self.subHeader.frame = CGRectMake(self.header.frame.origin.x,
                                      self.header.frame.origin.y
                                      + self.header.frame.size.height,
                                      self.frame.size.width,
                                      50.0f);
}

@end
