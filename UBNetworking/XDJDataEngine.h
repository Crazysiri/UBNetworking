//
//  YABaseDataEngine.h
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBNetWorkingDefines.h"
#import "XDJRequestCommonNeedsDelegate.h"

@interface XDJDataEngine : NSObject

@property (readonly, nonatomic) NSURLResponse *response;

//必须配置的方法！！！
+ (void)initializeWithDefaultNeeds:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs;

/**
 *  取消self持有的hash的网络请求
 */
- (void)cancelRequest;

/**
 *  下面的区分get/post/upload/download只是为了上层Engine调用方便，实现都是一样的
 */

/// get/post的普通请求
+ (XDJDataEngine *)control:(NSObject *)control //control 释放时销毁当前请求
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url //请求的url
                     param:(NSDictionary *)parameters //参数
               requestType:(XDJRequestType)requestType //方式 get post
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
             progressBlock:(XDJProgressBlock)progressBlock //进度progress
                  complete:(XDJCompletionDataBlock)responseBlock; //结果block


/// 上传文件data的请求 requestType 默认为 XDJRequestTypePostUpload
+ (XDJDataEngine *)control:(NSObject *)control
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                  fileData:(NSData *)fileData
                  dataName:(NSString *)dataName
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
          uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock;


/// 上传图片data的请求，imageType = @"gif" 或者 @"jpg"
+ (XDJDataEngine *)control:(NSObject *)control
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" // @"jpg"
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock;


/// downloadget的请求
+ (XDJDataEngine *)control:(NSObject *)control //control 释放时销毁当前请求
                       url:(NSString *)url //请求的url
                     param:(NSDictionary *)parameters //参数
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
          downloadProgress:(XDJDownloadProgressBlock)downloadProgressBlock //进度progress
                  complete:(XDJDownloadCompletionBlock)responseBlock;

@end
