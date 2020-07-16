//
//  UBNetworkingResultHandler.h
//  LenzNetworking
//
//  Created by Zero on 2020/7/16.
//  Copyright © 2020 Zero. All rights reserved.
//

#ifndef UBNetworkingResultHandler_h
#define UBNetworkingResultHandler_h

#import <Foundation/Foundation.h>

@class UBNetworkingTask;

@protocol UBNetworkingResultHandler <NSObject>

//临时 以后会删掉这块包括LenzRequestBaseModel 相关
+ (id)handleModel:(id)responseData;

+ (void)resultHandlerWithRequestDataModel:(UBNetworkingTask *)model
                                 response:(NSURLResponse *)response
                           responseObject:(id)responseObject
                             errorHandler:(void(^)(BOOL needCallback, NSError *newError))errorHandler;


@end

#endif /* UBNetworkingResultHandler_h */
