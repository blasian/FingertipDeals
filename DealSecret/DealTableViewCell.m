//
//  DealTableViewCell.m
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

const double kCatchWidth = 200.0f;

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:128.0f/255.0f green:180.0f/255.0f blue:215.0f/255.0f alpha:0.5f];
    
    self.dealLabel.textColor = [UIColor whiteColor];
    self.companyLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.distanceMeterView.backgroundColor = [UIColor colorWithRed:143.0f/255.0f green:174.0f/255.0f blue:36.0f/255.0f alpha:0.9];
    self.distanceMeterView.layer.cornerRadius = 5.0f;
    self.companyImage.layer.masksToBounds = YES;
    self.companyImage.layer.cornerRadius = 30.0f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    [self.contentView addSubview:self.scrollView];
    
    self.scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, kCatchWidth, CGRectGetHeight(self.bounds))];
    [self.scrollView addSubview:self.scrollViewButtonView];
    
    // Set up our two buttons
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    moreButton.frame = CGRectMake(0, 0, kCatchWidth / 3.0f, CGRectGetHeight(self.bounds));
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollViewButtonView addSubview:moreButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f];
    shareButton.frame = CGRectMake(kCatchWidth / 3.0f, 0, kCatchWidth / 3.0f, CGRectGetHeight(self.bounds));
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:shareButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(kCatchWidth / 3.0f+kCatchWidth / 3.0f, 0, kCatchWidth / 3.0f, CGRectGetHeight(self.bounds));
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    self.scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollViewContentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.scrollViewContentView];
    
    self.scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.scrollViewContentView.bounds, 10, 0)];
    [self.scrollViewContentView addSubview:self.scrollViewLabel];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.x > kCatchWidth - 20) {
        targetContentOffset->x = kCatchWidth;
    }
    else {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
