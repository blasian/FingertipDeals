//
//  CategoryTableViewCell.h
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, strong) UILabel *subHeader;

@end
