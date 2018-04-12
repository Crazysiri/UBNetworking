//
//  XDJHttpClientDownload.m
//  Skates.live
//
//  Created by James on 2017/12/22.
//  Copyright © 2017年 Skates.live. All rights reserved.
//

#import "XDJHttpClientDownload.h"
#import "AFNetworking.h"
@interface XDJHttpClientDownload ()
{
    NSURLSessionDownloadTask *_downloadTask;
}
@end
@implementation XDJHttpClientDownload
- (void)downFileFromServer {
    
    //远程地址
    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
    }];
    
}

- (void)resume {
    [_downloadTask resume];
}

- (void)suspend {
    [_downloadTask suspend];
}
@end
