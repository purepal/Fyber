//
//  HttpAPIClient.h
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 17..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import "AFNetworking.h"

@interface HttpAPIClient : AFHTTPRequestOperationManager

+ (HttpAPIClient *)sharedClient;

@end
