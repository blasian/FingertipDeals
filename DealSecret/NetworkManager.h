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
extern NSString* const kUserLoginEndpoint;
extern NSString* const kUserUpdateEndpoint;
extern NSString* const kUserLocationEndpoint;
extern NSString* const kUserDealsEndpoint;
extern NSString* const kUserCategories;
@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager*)sharedInstance;
- (id)initWithBaseURL:(NSURL*)url;

@end
