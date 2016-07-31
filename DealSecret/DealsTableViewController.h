//
//  DealsTableViewController.h
//  DealSecret
//
//  Created by Michael Spearman on 12/13/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DealTableViewCell.h"
#import "DealCategory.h"

@interface DealsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, DealTableViewCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) DealCategory* category;

@end
