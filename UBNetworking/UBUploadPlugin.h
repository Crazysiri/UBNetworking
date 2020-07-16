//
//  UBUploadPlugin.h
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "UBNetworkingTask.h"
#import "UBHttpNeeds.h"

@interface UBUploadPlugin : NSObject

- (NSURLSessionTask *)task:(AFHTTPSessionManager *)manager
                     model:(UBNetworkingUploadTask *)model
                     needs:(id<UBHttpNeeds>)needs;

@end

