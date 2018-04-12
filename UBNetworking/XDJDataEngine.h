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

//必须配置的方法！！！aClass 是 XDJBaseRequestDataModel 子类
+ (void)initializeWithErrorHandlerClass:(Class)aClass commonNeeds:(id<XDJRequestCommonNeedsDelegate>)needs;

/*拼url 用的 一般是 host = "http://url.com" other="/api.php"
 return @"http://url.com/api.php"
 */
+ (NSString *)server:(NSString *)host other:(NSString *)other;

@property (strong, nonatomic) void (^BeforeResumeBlock)(NSMutableURLRequest *request); //在开始请求前可以再次设置请求（timeout等等）

/**
 *  取消self持有的hash的网络请求
 */
- (void)cancelRequest;

/**
 *  下面的区分get/post/upload/download只是为了上层Engine调用方便，实现都是一样的
 */

/// get/post的普通请求
+ (XDJDataEngine *)control:(NSObject *)control //control 释放时销毁当前请求
                       url:(NSString *)url //请求的url
                     param:(NSDictionary *)parameters //参数
               requestType:(XDJRequestType)requestType //方式 get post
             progressBlock:(XDJProgressBlock)progressBlock //进度progress
                  complete:(XDJCompletionDataBlock)responseBlock; //结果block


/// 上传文件data的请求 requestType 默认为 XDJRequestTypePostUpload
+ (XDJDataEngine *)control:(NSObject *)control
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                  fileData:(NSData *)fileData
                  dataName:(NSString *)dataName
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
          uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock;


/// 上传图片data的请求，imageType = @"gif" 或者 @"jpg"
+ (XDJDataEngine *)control:(NSObject *)control
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" // @"jpg"
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock;
@end
