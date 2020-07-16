//
//  UBNetworkingAutoCancel.m
//  LenzNetworking
//
//  Created by Zero on 2020/7/15.
//  Copyright © 2020 Zero. All rights reserved.
//

#import "UBNetworkingAutoCancel.h"

@interface UBNetworkingAutoCancel ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *,UBNetworkingTask *> *tasks;

@end

@implementation UBNetworkingAutoCancel

- (void)dealloc
{
    [self.tasks enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UBNetworkingTask*  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.tasks removeAllObjects];
    self.tasks = nil;
}

- (NSMutableDictionary<NSNumber *,UBNetworkingTask *> *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (void)setTask:(UBNetworkingTask *)task taskId:(NSNumber *)taskId {
    if (task && taskId) {
        self.tasks[taskId] = task;
    }
}

- (void)removeTaskById:(NSNumber *)taskId {
    if (taskId) {
        [self.tasks removeObjectForKey:taskId];
    }
}

@end

#import <objc/runtime.h>

@implementation NSObject (autoCancel)

- (UBNetworkingAutoCancel *)networkingAutoCancel {
    UBNetworkingAutoCancel *requests = objc_getAssociatedObject(self, @selector(networkingAutoCancel));
    if (!requests) {
        requests = [[UBNetworkingAutoCancel alloc]init];
        objc_setAssociatedObject(self, @selector(networkingAutoCancel), requests, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requests;
}


- (void)setTask:(UBNetworkingTask *)task taskId:(NSNumber *)taskId {
    [self.networkingAutoCancel setTask:task taskId:taskId];
}

- (void)removeTaskById:(NSNumber *)taskId {
    [self.networkingAutoCancel removeTaskById:taskId];
}

@end
