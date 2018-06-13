//
//  XDJBaseRequestDataModel.h
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBNetWorkingDefines.h"

@interface XDJBaseRequestDataModel : NSObject
/**
 *  网络请求参数
 */
@property (nonatomic, strong) NSString *url;                        //网络请求地址
@property (nonatomic, strong) NSDictionary *parameters;             //请求参数
@property (nonatomic, assign) XDJRequestType requestType;  //网络请求方式
@property (nonatomic, copy) XDJCompletionDataBlock responseBlock;      //请求着陆回调

// upload
// upload file

@property (nonatomic, strong) NSString *dataFilePath;//(二选一)
@property (nonatomic, strong) NSData *fileData;//(二选一)

@property (nonatomic, strong) NSString *dataName;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;

@property (nonatomic, copy) XDJProgressBlock uploadProgressBlock;

// download
// download file
/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) long long fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) long long currentLength;
/** 当次下载需要的长度 */
@property (nonatomic, assign) long long expectedContentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, copy) NSString *downloadPath;
// progressBlock
@property (nonatomic, copy) XDJDownloadProgressBlock downloadProgressBlock;

@property (nonatomic, copy) XDJDownloadCompletionBlock downloadResponseBlock;      //请求着陆回调




+ (XDJBaseRequestDataModel *)dataModelWithUrl:(NSString *)url
                                        param:(NSDictionary *)parameters
                                 dataFilePath:(NSString *)dataFilePath //(二选一)
                                     fileData:(NSData *)fileData    //(二选一)
                                     dataName:(NSString *)dataName
                                     fileName:(NSString *)fileName
                                     mimeType:(NSString *)mimeType
                                  requestType:(XDJRequestType)requestType
                          uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                                     complete:(XDJCompletionDataBlock)responseBlock;

+ (XDJBaseRequestDataModel *)downloadModelWithUrl:(NSString *)url
                                            param:(NSDictionary *)parameters
                                 downloadProgress:(XDJDownloadProgressBlock)downloadProgress
                                         complete:(XDJDownloadCompletionBlock)responseBlock;
@end
