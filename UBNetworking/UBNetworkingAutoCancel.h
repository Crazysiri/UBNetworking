//
//  UBNetworkingAutoCancel.h
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBNetworkingTask.h"

@interface UBNetworkingAutoCancel : NSObject

- (void)setTask:(UBNetworkingTask *)task taskId:(NSNumber *)taskId;

- (void)removeTaskById:(NSNumber *)taskId;

@end


@interface NSObject (autoCancel)

@property(nonatomic, strong, readonly) UBNetworkingAutoCancel *networkingAutoCancel;

- (void)setTask:(UBNetworkingTask *)task taskId:(NSNumber *)taskId;

- (void)removeTaskById:(NSNumber *)taskId;

@end
