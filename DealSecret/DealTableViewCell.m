//
//  DealTableViewCell.m
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

const double kCatchWidth = 150.0f;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.companyImage = [[UIImageView alloc] init];
        self.dealLabel = [[UILabel alloc] init];
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceMeterView = [[UIView alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5.0f, self.bounds.size.width, self.bounds.size.height - 10.0f)];
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:88.0f/255.0f green:129.0f/255.0f blue:173.0f/255.0f alpha:1.0f];

    CGFloat companyImageLength = self.frame.size.height - 20.0f;
    self.companyImage.frame = CGRectMake(10.0f, 10.0f, companyImageLength, companyImageLength);
    self.companyImage.layer.masksToBounds = YES;
    self.companyImage.layer.cornerRadius = self.companyImage.frame.size.height/2;
    
    self.distanceMeterView.frame = CGRectMake(self.frame.size.width - 50.0f, self.frame.size.height/2, 40.0f, 10.0f);
    self.distanceMeterView.layer.cornerRadius = 5.0f;
    
    CGRect distanceFrame = self.distanceMeterView.frame;
    distanceFrame.origin.y = distanceFrame.origin.y - 20.0f;
    distanceFrame.size.height = distanceFrame.size.height + 10.0f;
    self.distanceLabel.frame = distanceFrame;
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    
    self.dealLabel.textColor = [UIColor whiteColor];
    self.dealLabel.frame = CGRectMake(self.companyImage.frame.origin.x + self.companyImage.frame.size.width + 10.0f, 10.0f, self.frame.size.width - (self.companyImage.frame.origin.x + self.companyImage.frame.size.width + 10.0f + (self.frame.size.width - self.distanceMeterView.frame.origin.x)), 30.0f);
    self.dealLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.dealLabel.numberOfLines = 0;
    [self.dealLabel sizeToFit];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    [self.contentView addSubview:self.scrollView];
    
    self.scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), self.backgroundImage.frame.origin.y, kCatchWidth, self.backgroundImage.frame.size.height)];
    [self.scrollView addSubview:self.scrollViewButtonView];
    
    // Set up our two buttons
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor colorWithRed:0.0f green:174.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
    shareButton.frame = CGRectMake(kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.scrollViewButtonView.bounds));
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareDeal:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:shareButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:193.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
    deleteButton.frame = CGRectMake(0, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.scrollViewButtonView.bounds));
    [deleteButton setTitle:@"Like" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(likeDeal:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    self.scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollViewContentView.backgroundColor = [UIColor clearColor];
    
    [self.scrollViewContentView addSubview:self.backgroundImage];
    [self.scrollViewContentView addSubview:self.companyImage];
    [self.scrollViewContentView addSubview:self.dealLabel];
    [self.scrollViewContentView addSubview:self.distanceLabel];
    [self.scrollViewContentView addSubview:self.distanceMeterView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealSelected:)];
    [self.scrollViewContentView addGestureRecognizer:tapGR];
    
    [self.scrollView addSubview:self.scrollViewContentView];
}

- (void)likeDeal:(id)sender {
    [self.delegate likeButtonTapped:self];
}

- (void)shareDeal:(id)sender {
    [self.delegate shareButtonTapped:self];
}

- (void)dealSelected:(id)sender {
    [self.delegate dealSelected:self];
}

# pragma mark ScrollViewDelegateMethods
 
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
