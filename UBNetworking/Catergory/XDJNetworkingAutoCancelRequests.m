//
//  XDJNetworkingAutoCancelRequests.m
//  NetWorking
//
//  Created by James on 16/4/27.
//  Copyright © 2016年 James. All rights reserved.
//

#import "XDJNetworkingAutoCancelRequests.h"
#import "XDJDataEngine.h"
@interface XDJNetworkingAutoCancelRequests()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,XDJDataEngine *> *requestEngines;
@end
@implementation XDJNetworkingAutoCancelRequests
-(void)dealloc{
    [self.requestEngines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, XDJDataEngine * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancelRequest];
    }];
    [self.requestEngines removeAllObjects];
    self.requestEngines = nil;
}
- (NSMutableDictionary *)requestEngines
{
    if (_requestEngines == nil) {
        _requestEngines = [[NSMutableDictionary alloc] init];
    }
    return _requestEngines;
}

- (void)setEngine:(XDJDataEngine *)engine requestID:(NSNumber *)requestID
{
    if (engine && requestID) {
        self.requestEngines[requestID] = engine;
    }
}

- (void)removeEngineWithRequestID:(NSNumber *)requestID
{
    if (requestID) {
//        NSArray *keys = self.requestEngines.allKeys;
//        if ([keys containsObject:requestID]) {
            [self.requestEngines removeObjectForKey:requestID];
//        } else {
//            __block NSMutableArray *needRemove = [[NSMutableArray alloc] init];
//            [keys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([requestID isEqualToNumber:obj]) {
//                    [needRemove addObject:obj];
//                }
//            }];
//            if (needRemove.count > 0) {
//                [self.requestEngines removeObjectsForKeys:needRemove];
//            }
//        }
    }
}

@end
