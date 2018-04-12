//
//  UBNetWorkingDefines.h
//  NetworkingDemo
//
//  Created by qiuyoubo on 2018/4/12.
//  Copyright © 2018年 qiuyoubo. All rights reserved.
//

#ifndef UBNetWorkingDefines_h
#define UBNetWorkingDefines_h



typedef NS_ENUM (NSUInteger, XDJRequestType){
    XDJRequestTypeGet,                 //get请求
    XDJRequestTypePost,                //POST请求
    XDJRequestTypePostUpload,             //POST数据请求
    XDJRequestTypeGETDownload             //下载文件请求，不做返回值解析
};

typedef void (^XDJProgressBlock)(NSProgress *taskProgress);
typedef void (^XDJCompletionDataBlock)(id responseObject, NSError *error);
typedef void (^XDJErrorAlertSelectIndexBlock)(NSUInteger buttonIndex);

#endif /* UBNetWorkingDefines_h */
