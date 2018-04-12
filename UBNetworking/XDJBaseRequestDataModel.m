//
//  XDJBaseRequestDataModel.m
//  NetWorking
//
//  Created by James on 2017/12/18.
//  Copyright © 2017年 James. All rights reserved.
//

#import "XDJBaseRequestDataModel.h"

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
                        downloadProgressBlock:(XDJProgressBlock)downloadProgressBlock
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
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseBlock = responseBlock;
    return dataModel;
}
@end
