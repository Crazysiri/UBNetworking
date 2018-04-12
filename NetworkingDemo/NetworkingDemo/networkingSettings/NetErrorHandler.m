//
//  XDJNetErrorHandler.m
//  Dandanjia
//
//  Created by qiuyoubo on 2017/12/19.
//  Copyright © 2017年 Skates.live. All rights reserved.
//

#import "NetErrorHandler.h"
#import "RequestCommonNeeds.h"
#import "XDJBaseRequestDataModel.h"
#import "RequestDefines.h"
@implementation NetErrorHandler
+ (void)resultHandlerWithRequestDataModel:(XDJBaseRequestDataModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(BOOL needCallback, NSError *newError))errorHandler {
    if (error) {
        if (errorHandler) {
            errorHandler(YES,error);
        }
        
    } else {
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
            //统一生成新的error
            error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:message,@"data":responseObject,@"URL":responseURL.URL.absoluteString}];
            
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
}

@end
