//
//  XDJBaseRequestDataModel.h
//  NetWorking
//
//  Created by qiuyoubo on 2017/12/18.
//  Copyright © 2017年 Yasin. All rights reserved.
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

// download
// download file

// progressBlock
@property (nonatomic, copy) XDJProgressBlock uploadProgressBlock;
@property (nonatomic, copy) XDJProgressBlock downloadProgressBlock;




+ (XDJBaseRequestDataModel *)dataModelWithUrl:(NSString *)url
                                        param:(NSDictionary *)parameters
                                 dataFilePath:(NSString *)dataFilePath //(二选一)
                                     fileData:(NSData *)fileData    //(二选一)
                                     dataName:(NSString *)dataName
                                     fileName:(NSString *)fileName
                                     mimeType:(NSString *)mimeType
                                  requestType:(XDJRequestType)requestType
                          uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                        downloadProgressBlock:(XDJProgressBlock)downloadProgressBlock
                                     complete:(XDJCompletionDataBlock)responseBlock;
@end
