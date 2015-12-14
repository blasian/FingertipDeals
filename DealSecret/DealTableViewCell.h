//
//  DealTableViewCell.h
//  DealSecret
//
//  Created by Michael Spearman on 11/29/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIImageView *companyImage;
@property (nonatomic, weak) IBOutlet UILabel *dealLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
