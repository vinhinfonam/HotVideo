//
//  NetworkHTTPClient.m
//  HightLearning
//
//  Created by VinhNguyen on 7/21/14.
//  Copyright (c) 2014 Synova. All rights reserved.
//

#import "NetworkHTTPClient.h"


static NSString * const networkURLString = @"";

@implementation NetworkHTTPClient

+ (NetworkHTTPClient *)sharednetworkHTTPClient
{
    static NetworkHTTPClient *_sharedWeatherHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return _sharedWeatherHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}
@end

