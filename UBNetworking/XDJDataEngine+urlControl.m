//
//  XDJDataEngine+urlControl.m
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/7/28.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#import "XDJDataEngine+urlControl.h"

@implementation XDJDataEngine (urlControl)

id <XDJDataEngineURLSetterGetter> __url_getter;

+ (void)registerURLGetter:(id <XDJDataEngineURLSetterGetter>) urlGetter {
    __url_getter = urlGetter;
}

+ (NSString *)urlForHostKey:(NSString *)hostKey api:(NSString *)api {
    NSString *url = nil;
    if (!__url_getter || !hostKey || ![__url_getter hostForKey:hostKey]) {
        url = api;
    } else {
        url = [NSString stringWithFormat:@"%@%@",[__url_getter hostForKey:hostKey],api];
    }
    return url;
}


/// get/post的普通请求
+ (XDJDataEngine *)url_control:(NSObject *)control //control 释放时销毁当前请求
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters //参数
               requestType:(XDJRequestType)requestType //方式 get post
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
             progressBlock:(XDJProgressBlock)progressBlock //进度progress
                  complete:(XDJCompletionDataBlock)responseBlock {
    
    NSString *url = [self urlForHostKey:hostKey api:api];

    return [self control:control url:url param:parameters requestType:requestType beforeRequest:beforeRequest progressBlock:progressBlock complete:responseBlock];
    
} //结果block


/// 上传文件data的请求 requestType 默认为 XDJRequestTypePostUpload
+ (XDJDataEngine *)url_control:(NSObject *)control
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters
                  fileData:(NSData *)fileData
                  dataName:(NSString *)dataName
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    NSString *url = [self urlForHostKey:hostKey api:api];

    return [self control:control url:url param:parameters fileData:fileData dataName:dataName fileName:fileName mimeType:mimeType beforeRequest:beforeRequest uploadProgressBlock:uploadProgressBlock complete:responseBlock];
}


/// 上传图片data的请求，imageType = @"gif" 或者 @"jpg"
+ (XDJDataEngine *)url_control:(NSObject *)control
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" // @"jpg"
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    NSString *url = [self urlForHostKey:hostKey api:api];

    return [self control:control url:url param:parameters imageData:imageData imageType:imageType beforeRequest:beforeRequest uploadProgressBlock:uploadProgressBlock complete:responseBlock];
}


/// downloadget的请求
+ (XDJDataEngine *)url_control:(NSObject *)control //control 释放时销毁当前请求
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters //参数
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
          downloadProgress:(XDJDownloadProgressBlock)downloadProgressBlock //进度progress
                  complete:(XDJDownloadCompletionBlock)responseBlock {
    NSString *url = [self urlForHostKey:hostKey api:api];

    return [self control:control url:url param:parameters beforeRequest:beforeRequest downloadProgress:downloadProgressBlock complete:responseBlock];
}

@end
