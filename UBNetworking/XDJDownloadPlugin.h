//
//  XDJHttpClient.h
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/6/12.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDJBaseRequestDataModel,AFURLSessionManager;
/*
 下载错误码 -1416：已下载 (416长度请求不对的http status code -1416自定义)
    
 */
@interface XDJDownloadPlugin : NSObject
- (NSURLSessionTask *)downloadTaskWithRequest:(NSMutableURLRequest *)request requestModel:(XDJBaseRequestDataModel *)requestModel;


+ (NSString *)filePathForURL:(NSString *)URL;
+ (long long)fileLengthForPath:(NSString *)path;
@end
