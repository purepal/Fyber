//
//  HttpAPIClient.m
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 17..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import "HttpAPIClient.h"

static NSString * const kAFBaseURLString = @"http://api.fyber.com";

@implementation HttpAPIClient

+ (HttpAPIClient *)sharedClient
{
    static HttpAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFBaseURLString]];
        [_sharedClient.requestSerializer setTimeoutInterval:10];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    return self;
}

@end
