//
//  DealButtonStrip.h
//  DealSecret
//
//  Created by Michael Spearman on 1/6/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonStripDelegate

- (void)shareButtonPressed;
- (void)timerButtonPressed;
- (void)favButtonPressed;
- (void)likeButtonPressed;

@end

@interface DealButtonStrip : UIView

@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* timerButton;
@property (nonatomic, strong) UIButton* favButton;
@property (nonatomic, strong) UIButton* likeButton;

@property (weak) id <ButtonStripDelegate> delegate;

@end
