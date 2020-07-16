//
//  XDJNetErrorHandler.m
//  Dandanjia
//
//  Created by qiuyoubo on 2017/12/19.
//  Copyright © 2017年 Skates.live. All rights reserved.
//

#import "NetErrorHandler.h"
#import "RequestCommonNeeds.h"
#import "UBNetworkingTask.h"
#import "RequestDefines.h"
@implementation NetErrorHandler

+ (id)handleModel:(id)responseData {
    return nil;
}

+ (void)resultHandlerWithRequestDataModel:(UBNetworkingTask *)model response:(NSURLResponse *)response responseObject:(id)responseObject errorHandler:(void (^)(BOOL, NSError *))errorHandler {

        NSInteger errorCode = HttpCodeSuccess;
        NSString *message = @"网络连接发生错误";
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            errorCode = HttpCodeOtherError;
        } else {
            errorCode = [responseObject[@"code"] integerValue];
            if (responseObject[@"msg"]) {
                message = responseObject[@"msg"];
            }
            //其他的错误解析逻辑，包含重新暂时不返回回调重新发起网络请求
            //注意只修改errorCode和message就行了，下面会统一生成新的error
            //如果是重新发起网络请求，发起网络请求后就直接return，不再执行下面的逻辑
        }

        
        if (errorCode != HttpCodeSuccess) {
            if (!responseObject) {
                responseObject = @{};
            }
            NSError *error;
            
            //统一生成新的error
            error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject,@"URL":response.URL.absoluteString}];
            
            if (errorCode == HttpCodeLoginDated) {
                errorHandler(NO,error);
                return;
            }
            
            if (errorHandler) {
                errorHandler(YES,error);
            }
        } else {
            if (errorHandler) {
                errorHandler(YES,nil);
            }
        }
}

@end
