//
//  DealButtonStrip.m
//  DealSecret
//
//  Created by Michael Spearman on 1/6/16.
//  Copyright © 2016 Michael Spearman. All rights reserved.
//

#import "DealButtonStrip.h"

#define BUTTON_WIDTH 20.0f

@implementation DealButtonStrip

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    float spacer = (self.frame.size.width - 2*BUTTON_WIDTH)/3;
    float topSpacer = (self.frame.size.height - BUTTON_WIDTH)/2;
    
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(spacer - 20, topSpacer, BUTTON_WIDTH, BUTTON_WIDTH)];
    [self.shareButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"share_icon_selected"] forState:UIControlStateSelected];
    [self.shareButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.tag = 0;
    
//    self.timerButton = [[UIButton alloc] initWithFrame:CGRectMake(spacer*2 - 10 + BUTTON_WIDTH, topSpacer, BUTTON_WIDTH, BUTTON_WIDTH)];
//    [self.timerButton setImage:[UIImage imageNamed:@"timer_icon"] forState:UIControlStateNormal];
//    [self.timerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.timerButton.tag = 1;
//    
//    self.favButton = [[UIButton alloc] initWithFrame:CGRectMake(spacer*3 + 10 + BUTTON_WIDTH*2, topSpacer, BUTTON_WIDTH, BUTTON_WIDTH)];
//    [self.favButton setImage:[UIImage imageNamed:@"favorite_icon"] forState:UIControlStateNormal];
//    [self.favButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.favButton.tag = 2;
    
    self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(spacer*2 + 20 + BUTTON_WIDTH, topSpacer, BUTTON_WIDTH, BUTTON_WIDTH)];
    [self.likeButton setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"like_icon_selected"] forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.tag = 3;
    
    [self addSubview:self.shareButton];
//    [self addSubview:self.timerButton];
//    [self addSubview:self.favButton];
    [self addSubview:self.likeButton];
}

- (void)likeButtonPressed {
    [self.likeButton setSelected:!self.likeButton.isSelected];
    [self.delegate likeButtonPressed];
}

- (void)buttonPressed:(id)sender {
    UIButton* button = sender;
    switch (button.tag)
        case 0: {
            [self.shareButton setSelected:!self.shareButton.isSelected];
            [self.delegate shareButtonPressed];
            break;
        case 1:
            [self.delegate timerButtonPressed];
            break;
        case 2:
            [self.delegate favButtonPressed];
            break;
        case 3:
            [self likeButtonPressed];
            break;
        default:
            break;
    }
}

@end
