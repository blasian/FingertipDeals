//
//  NetworkManager.h
//  DealSecret
//
//  Created by Michael Spearman on 11/22/15.
//  Copyright © 2015 Michael Spearman. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString* const kBaseUrl;
extern NSString* const kUserEndpoint;
extern NSString* const kUserDealEndpoint;
extern NSString* const kUserLoginEndpoint;
extern NSString* const kUserUpdateEndpoint;
extern NSString* const kUserLocationEndpoint;
extern NSString* const kUserDealsByLocationEndpoint;
extern NSString* const kUserCategoriesEndpoint;
extern NSString* const kUserClassesEndpoint;
extern NSString* const kUserSetClassesEndpoint;
extern NSString* const kUserDealsWithClassEndpoint;
extern NSString* const kUserDealsZipEndpoint;
extern NSString* const kUserUpdateLocationEndpoint;
extern NSString* const kUserForgotPassword;
extern NSString* const kUserLoginFromSourceEndpoint;
extern NSString* const kUserCreateFromSourceEndpoint;
extern NSString* const kUserLikeDealEndpoint;
extern NSString* const kTermsEndpoint;

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager*)sharedInstance;
- (id)initWithBaseURL:(NSURL*)url;

@end
