//
//  DealTableViewCell.h
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DealTableViewCell;

@protocol DealTableViewCellDelegate

- (void)dealSelected:(DealTableViewCell*)cell;

@end

@interface DealTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *companyImage;
@property (nonatomic, strong) UILabel *dealLabel;

//@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
//@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *distanceMeterView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewButtonView;
@property (nonatomic, strong) UIView *scrollViewContentView;
@property (nonatomic, strong) UILabel *scrollViewLabel;
@property (nonatomic, strong) id<DealTableViewCellDelegate> delegate;

@end
