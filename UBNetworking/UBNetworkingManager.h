//
//  UBNetworkingManager.h
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBHttpNeeds.h"

#import "UBNetworkingTask.h"

#import "UBNetworkingResultHandler.h"

@interface UBNetworkingManager : NSObject

@property (readonly ,class) id shared;

//这里需要设置一下，一般一个工程只有一个，这里包含固定的每次请求的参数等设置
@property (class) id <UBHttpNeeds> needs;

///是否启用 debug log 默认 NO
@property (nonatomic,assign) BOOL enableDebugLog;


- (NSNumber *)callRequestWithRequestModel:(UBNetworkingTask *)model needs:(id<UBHttpNeeds>)needs;

- (void)cancelByID:(NSNumber *)tid;
- (void)cancelByIDs:(NSArray<NSNumber *> *)tids;

@end

