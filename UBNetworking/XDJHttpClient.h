//
//  XDJBaseRequest.h
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/18.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDJBaseRequestDataModel;

@interface XDJHttpClient : NSObject

+ (instancetype)sharedInstance;
- (void)registerErrorHandlerClass:(Class)aClass;

/**
 *  根据dataModel发起网络请求，并根据dataModel发起回调
 *
 *
 *  @return 网络请求task哈希值
 */
- (NSNumber *)callRequestWithRequestModel:(XDJBaseRequestDataModel *)requestModel beforeResume:(void(^)(NSMutableURLRequest *request))block;

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

@end

