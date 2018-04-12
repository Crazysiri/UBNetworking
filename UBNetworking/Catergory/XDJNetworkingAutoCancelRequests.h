//
//  XDJNetworkingAutoCancelRequests.h
//  NetWorking
//
//  Created by James on 16/4/27.
//  Copyright © 2016年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDJDataEngine;
@interface XDJNetworkingAutoCancelRequests : NSObject
- (void)setEngine:(XDJDataEngine *)engine requestID:(NSNumber *)requestID;
- (void)removeEngineWithRequestID:(NSNumber *)requestID;
@end
