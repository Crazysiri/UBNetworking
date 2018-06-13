//
//  XDJBaseRequestDataModel.m
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import "XDJBaseRequestDataModel.h"
#import "XDJDownloadPlugin.h"

@implementation XDJBaseRequestDataModel
+ (XDJBaseRequestDataModel *)dataModelWithUrl:(NSString *)url
                                        param:(NSDictionary *)parameters
                                 dataFilePath:(NSString *)dataFilePath
                                     fileData:(NSData *)fileData
                                     dataName:(NSString *)dataName
                                     fileName:(NSString *)fileName
                                     mimeType:(NSString *)mimeType
                                  requestType:(XDJRequestType)requestType
                          uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                                     complete:(XDJCompletionDataBlock)responseBlock
{
    XDJBaseRequestDataModel *dataModel = [[XDJBaseRequestDataModel alloc]init];
    dataModel.url = url;
    dataModel.parameters = parameters;
    dataModel.dataFilePath = dataFilePath;
    dataModel.fileData = fileData;
    dataModel.dataName = dataName;
    dataModel.fileName = fileName;
    dataModel.mimeType = mimeType;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.responseBlock = responseBlock;
    return dataModel;
}

+ (XDJBaseRequestDataModel *)downloadModelWithUrl:(NSString *)url
                                            param:(NSDictionary *)parameters
                                 downloadProgress:(XDJDownloadProgressBlock)downloadProgress
                                         complete:(XDJDownloadCompletionBlock)responseBlock {
    XDJBaseRequestDataModel *dataModel = [[XDJBaseRequestDataModel alloc]init];
    NSString *path = [XDJDownloadPlugin filePathForURL:url];
    dataModel.currentLength = [XDJDownloadPlugin fileLengthForPath:path];
    dataModel.downloadPath = path;
    dataModel.url = url;
    dataModel.requestType = XDJRequestTypeGETDownload;
    dataModel.parameters = parameters;
    dataModel.downloadProgressBlock = downloadProgress;
    dataModel.downloadResponseBlock = responseBlock;
    return dataModel;
}
@end
