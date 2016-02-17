//
//  SplashScreenViewController.h
//  DealSecret
//
//  Created by Michael Spearman on 12/10/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "STTwitter.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SplashScreenViewController : UIViewController <FBSDKLoginButtonDelegate, STTwitterAPIOSProtocol>

@end
