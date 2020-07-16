//
//  UBHttpNeeds.h
//  UBHttpNeeds
//
//  Created by Zero on 2019/1/2.
//  Copyright © 2019年 Zero. All rights reserved.
//

typedef void (^UBProgressBlock)(NSProgress *taskProgress);
typedef void (^UBCompletionBlock)(id responseObject,NSURLResponse *response, NSError *error);

#import "UBNetworkingResultHandler.h"

#ifndef UBHttpNeeds_h
#define UBHttpNeeds_h

typedef NS_ENUM(NSUInteger, DataType) {
    // 普通格式mid=10&method=userInfo&dateInt=20160818
    DataTypeNormal,
    // JSON编码格式{"mid":"11","method":"userInfo","dateInt":"20160818"}
    DataTypeJson,
    // plist编码格式
    DataTypePlist,
};


@protocol UBHttpNeeds <NSObject>

#pragma mark - for url

//url拼接 : host+api
- (NSString *)baseUrl:(NSString *)api;

#pragma mark - for header

- (NSTimeInterval)timeout;

- (NSSet *)acceptableContentTypes;

- (NSDictionary *)headers;

#pragma mark - for request

//一般不需要处理，处理主要用于整体加密需要的或者其他的
//不需要处理的直接return parameters;
- (NSDictionary *)beforeRequest:(NSDictionary *)parameters;

//通用参数
- (NSMutableDictionary *)commonParameters;

- (DataType)requestType;

#pragma mark - for response

- (DataType)responseType;

//一般不需要处理，处理主要用于整体解密需要的或者其他的
//不需要处理 直接 return responseObject;
- (id)afterResponse:(id)responseObject;

- (Class<UBNetworkingResultHandler>)errorHandler;

@end

#endif /* UBHttpNeeds_h */
