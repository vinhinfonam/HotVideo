//
//  NetworkHTTPClient.h
//  HightLearning
//
//  Created by VinhNguyen on 7/21/14.
//  Copyright (c) 2014 Synova. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol NetworkHTTPClientDelegate;

@interface NetworkHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<NetworkHTTPClientDelegate> delegate;

+ (NetworkHTTPClient *)sharednetworkHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end

@protocol NetworkHTTPClientDelegate <NSObject>
@optional
-(void) networkHTTPClient:(NetworkHTTPClient *)client didUpdateWithInfo:(id)info;
-(void) networkHTTPClient:(NetworkHTTPClient *)client didFailWithError:(NSError *)error;


@end
