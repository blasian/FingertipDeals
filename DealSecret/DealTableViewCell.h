//
//  DealTableViewCell.h
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *companyImage;
@property (nonatomic, weak) IBOutlet UILabel *dealLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIView *distanceMeterView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewButtonView;
@property (nonatomic, strong) UIView *scrollViewContentView;
@property (nonatomic, strong) UILabel *scrollViewLabel;

@end
