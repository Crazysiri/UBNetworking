//
//  XDJHttpClient.m
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/6/12.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#import "XDJDownloadPlugin.h"
#import "XDJRequestGenerator.h"
#import "XDJBaseRequestDataModel.h"
#import "AFURLSessionManager.h"
#import "NSString+UtilNetworking.h"

@interface XDJDownloadPlugin ()
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@end

@implementation XDJDownloadPlugin

- (NSURLSessionTask *)downloadTaskWithRequest:(NSMutableURLRequest *)request requestModel:(XDJBaseRequestDataModel *)requestModel  {
    AFURLSessionManager *manager = self.sessionManager;
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", requestModel.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
//    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"dataTaskWithRequest");
    
        // 清空长度
        requestModel.currentLength = 0;
        requestModel.fileLength = 0;
        
        // 关闭fileHandle
        [requestModel.fileHandle closeFile];
        requestModel.fileHandle = nil;
        
        if (requestModel.expectedContentLength == 0) {
            error = [NSError errorWithDomain:error.domain code:-1416 userInfo:@{NSLocalizedDescriptionKey:@"已下载"}];
        }
        if (requestModel.downloadResponseBlock)
            requestModel.downloadResponseBlock(requestModel.downloadPath,response, error);
    }];
    
    [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        //这里设置一下 expectedContentLength 预期长度 等到结束的时候判断如果是0 就直接提示 已下载
        requestModel.expectedContentLength = response.expectedContentLength;
        NSLog(@"NSURLSessionResponseDisposition：length:%lld",response.expectedContentLength);
        
        if (response.expectedContentLength == 0)  {
            return NSURLSessionResponseAllow;
        }
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        requestModel.fileLength = response.expectedContentLength + requestModel.currentLength;
        
        // 沙盒文件路径
        NSString *path = requestModel.downloadPath;
        
        NSLog(@"File downloaded to: %@",path);
        
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:path]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:path contents:nil attributes:nil];
        }
        
        // 创建文件句柄
        requestModel.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NSLog(@"setDataTaskDidReceiveDataBlock");
        
        // 指定数据的写入位置 -- 文件内容的最后面
        [requestModel.fileHandle seekToEndOfFile];
        
        // 向沙盒写入数据
        [requestModel.fileHandle writeData:data];
        
        // 拼接文件总长度
        requestModel.currentLength += data.length;
        
        //回调主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestModel.downloadProgressBlock) {
                requestModel.downloadProgressBlock(requestModel.currentLength, requestModel.fileLength);
            }
        });

    }];
    
    
    return task;
    //resume 开始下载/继续下载
    //suspend 暂停
}

- (AFURLSessionManager *)getCommonSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 20;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}

#pragma mark - getters and setters
- (AFURLSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        AFHTTPResponseSerializer *Serializer =[AFHTTPResponseSerializer serializer];;
        _sessionManager.responseSerializer = Serializer;
        Serializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    }
    return _sessionManager;
}

+ (NSString *)folder {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

+ (NSString *)filePathForURL:(NSString *)URL {
    NSString *fileName = [URL ubnetworking_MD5];
    NSString *path = [[self folder] stringByAppendingPathComponent:fileName];
    return path;
}
/**
 * 获取已下载的文件大小
 */
+ (long long)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

@end
