//
//  XDJDataEngine+engine.m
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/5/23.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#import "XDJDataEngine+engine.h"

@implementation XDJDataEngine (engine)
/// get/post的普通请求
+ (XDJDataEngine *)control:(NSObject *)control //control 释放时销毁当前请求
                       url:(NSString *)url //请求的url
                     param:(NSDictionary *)parameters //参数
               requestType:(XDJRequestType)requestType //方式 get post
             progressBlock:(XDJProgressBlock)progressBlock //进度progress
                  complete:(void(^)(id responseObject, NSError *error))responseBlock {
    return [self control:control url:url param:parameters requestType:requestType beforeRequest:nil progressBlock:progressBlock complete:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (responseBlock) {
            responseBlock(responseObject,error);
        }
    }];
} //结果block


/// 上传文件data的请求 requestType 默认为 XDJRequestTypePostUpload
+ (XDJDataEngine *)control:(NSObject *)control
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                  fileData:(NSData *)fileData
                  dataName:(NSString *)dataName
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(void(^)(id responseObject, NSError *error))responseBlock {
    return [self control:control url:url param:parameters fileData:fileData dataName:dataName fileName:fileName mimeType:mimeType beforeRequest:nil uploadProgressBlock:uploadProgressBlock complete:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (responseBlock) {
            responseBlock(responseObject,error);
        }
    }];
}


/// 上传图片data的请求，imageType = @"gif" 或者 @"jpg"
+ (XDJDataEngine *)control:(NSObject *)control
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" // @"jpg"
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(void(^)(id responseObject, NSError *error))responseBlock {
    return [self control:control url:url param:parameters imageData:imageData imageType:imageType beforeRequest:nil uploadProgressBlock:uploadProgressBlock complete:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (responseBlock) {
            responseBlock(responseObject,error);
        }
    }];
}
@end
