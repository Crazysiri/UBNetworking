//
//  XDJRequestGenerator.m
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import "XDJRequestGenerator.h"
#import "XDJRequestCommonNeedsDelegate.h"
#import "XDJBaseRequestDataModel.h"
#import "NSString+UtilNetworking.h"

#import "AFURLRequestSerialization.h"
@interface XDJRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end
@implementation XDJRequestGenerator
+ (id)shared {
    static dispatch_once_t onceToken;
    static XDJRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XDJRequestGenerator alloc] init];
    });
    return sharedInstance;
}


#pragma mark - public methods
- (NSMutableURLRequest *)requestWithDataModel:(XDJBaseRequestDataModel *)model commonHeaders:(NSDictionary *)commonHeaders commonParameters:(NSDictionary *)commonParameters timeout:(NSTimeInterval)timeout {
    
    for (NSString *key in commonHeaders.allKeys) {
        [self.httpRequestSerializer setValue:commonHeaders[key] forHTTPHeaderField:key];
    }
    self.httpRequestSerializer.timeoutInterval = timeout;

    NSMutableDictionary *commonParams = [NSMutableDictionary dictionaryWithDictionary:commonParameters];
    [commonParams addEntriesFromDictionary:model.parameters];

    NSString *urlString = model.url;
    NSError *error;
    NSMutableURLRequest *request;
    /**
     *      YAAPIManagerRequestTypeGet,                 //get请求
     YAAPIManagerRequestTypePost,                //POST请求
     YAAPIManagerRequestTypePostUpload,             //POST数据请求
     YAAPIManagerRequestTypeGETDownload
     */
    if (model.requestType == XDJRequestTypeGet) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:commonParams error:&error];
    } else if (model.requestType == XDJRequestTypePost) {
        request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:commonParams error:&error];
    } else if (model.requestType == XDJRequestTypePostUpload) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:commonParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            /**
             *  这里的参数配置也可以根据自己的设计修改默认值.
             为什么没有直接使用NSData?
             */
            if (![NSString isEmptyString:model.dataFilePath]) {
                NSURL *fileURL = [NSURL fileURLWithPath:model.dataFilePath];
                NSString *name = model.dataName?model.dataName:@"data";
                NSString *fileName = model.fileName?model.fileName:@"data.zip";
                NSString *mimeType = model.mimeType?model.mimeType:@"application/zip";
                NSError *error;
                [formData appendPartWithFileURL:fileURL
                                           name:name
                                       fileName:fileName
                                       mimeType:mimeType
                                          error:&error];
            } else if (model.fileData) {
                NSString *name = model.dataName?model.dataName:@"data";
                NSString *fileName = model.fileName?model.fileName:@"data.zip";
                NSString *mimeType = model.mimeType?model.mimeType:@"application/zip";
                [formData appendPartWithFileData:model.fileData
                                            name:name
                                        fileName:fileName
                                        mimeType:mimeType];
            }
            
        } error:&error];
    } else if (model.requestType == XDJRequestTypeGETDownload) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:commonParams error:&error];
    }
    if (error || request == nil) {
        NSLog(@"NSMutableURLRequests生成失败：\n---------------------------\n\
              urlString:%@\n\
              \n---------------------------\n",urlString);
        return nil;
    }
    
    return request;
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}
@end
