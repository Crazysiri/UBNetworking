//
//  XDJDataEngine+urlControl.h
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/7/28.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#import "XDJDataEngine.h"

@protocol XDJDataEngineURLSetterGetter <NSObject>

- (void)setHost:(NSString *)host forKey:(NSString *)key;

- (NSString *)hostForKey:(NSString *)key;

@end


@interface XDJDataEngine (urlControl)
/*
 
 hostKey
 api
 
 1.注册 实现了 XDJDataEngineURLSetterGetter协议的类
 2.请求的url 拼接 是根据 hostForKey:hostKey 拿到的host 再拼上 api 得到的
 比如 host是 http://api.xxx.com api是/login
 3.如果 hostForKey 获取的是空的或者hostKey是空的 url=api
 
 */

+ (void)registerURLGetter:(id <XDJDataEngineURLSetterGetter>) urlGetter;

/// get/post的普通请求
+ (XDJDataEngine *)url_control:(NSObject *)control //control 释放时销毁当前请求
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters //参数
               requestType:(XDJRequestType)requestType //方式 get post
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
             progressBlock:(XDJProgressBlock)progressBlock //进度progress
                  complete:(XDJCompletionDataBlock)responseBlock; //结果block


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
                  complete:(XDJCompletionDataBlock)responseBlock;


/// 上传图片data的请求，imageType = @"gif" 或者 @"jpg"
+ (XDJDataEngine *)url_control:(NSObject *)control
                   hostKey:(NSString *)hostKey
                       api:(NSString *)api
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" // @"jpg"
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock;


/// downloadget的请求
+ (XDJDataEngine *)url_control:(NSObject *)control //control 释放时销毁当前请求
                   hostKey:(NSString *)hostKey
                       api:(NSArray *)api
                     param:(NSDictionary *)parameters //参数
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
          downloadProgress:(XDJDownloadProgressBlock)downloadProgressBlock //进度progress
                  complete:(XDJDownloadCompletionBlock)responseBlock;
@end
