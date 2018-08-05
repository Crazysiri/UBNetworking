//
//  YABaseDataEngine.m
//  NetWorking
//
//  Created by James on 16/4/27.
//  Copyright © 2016年 James. All rights reserved.
//

#import "XDJDataEngine.h"
#import "XDJBaseRequestDataModel.h"
#import "XDJHttpClient.h"
#import "NSObject+NetWorkingAutoCancel.h"
#import "XDJRequestGenerator.h"
@interface XDJDataEngine ()

@property (strong, nonatomic) NSURLResponse *response;

@property (nonatomic, strong) NSNumber *requestID;

@end
@implementation XDJDataEngine

static id <XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate> __request_default_needs = nil;

#pragma mark - life cycle

//必须配置的方法！！！
+ (void)initializeWithDefaultNeeds:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs {
    __request_default_needs = needs;
}

- (void)dealloc{
    [self cancelRequest];
}
#pragma mark - public methods
/**
 *  取消self持有的hash的网络请求
 */
- (void)cancelRequest{
    [[XDJHttpClient sharedInstance] cancelRequestWithRequestID:self.requestID];
}

/// get/post
+ (XDJDataEngine *)control:(NSObject *)control
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
               requestType:(XDJRequestType)requestType
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
             progressBlock:(XDJProgressBlock)progressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    
    XDJDataEngine *engine = [[XDJDataEngine alloc]init];
    
    __weak typeof(control) weakControl = control;
    __weak typeof(engine) weakEngine = engine;
    XDJBaseRequestDataModel *dataModel = [XDJBaseRequestDataModel dataModelWithUrl:url param:parameters dataFilePath:nil fileData:nil dataName:nil fileName:nil mimeType:nil requestType:requestType uploadProgressBlock:progressBlock complete:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (responseBlock) {
            weakEngine.response = response;
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(responseObject,response,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    [engine callRequestWithRequestModel:dataModel control:control needs:needs beforeRequestBlock:beforeRequest];
    return engine;
}


+ (XDJDataEngine *)control:(NSObject *)control
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                  fileData:(NSData *)fileData
                  dataName:(NSString *)dataName
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    XDJDataEngine *engine = [[XDJDataEngine alloc]init];
    
    __weak typeof(control) weakControl = control;
    __weak typeof(engine) weakEngine = engine;

    XDJBaseRequestDataModel *dataModel = [XDJBaseRequestDataModel dataModelWithUrl:url param:parameters dataFilePath:nil fileData:fileData dataName:dataName fileName:fileName mimeType:mimeType requestType:XDJRequestTypePostUpload uploadProgressBlock:uploadProgressBlock  complete:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (responseBlock) {
            weakEngine.response = response;
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(responseObject,response,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    [engine callRequestWithRequestModel:dataModel control:control needs:needs beforeRequestBlock:beforeRequest];
    return engine;
}


+ (XDJDataEngine *)control:(NSObject *)control
                     needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs //use default needs if nil
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" / @"jpg"
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    return [self control:control needs:needs url:url param:parameters fileData:imageData dataName:@"image" fileName:@"image" mimeType:[NSString stringWithFormat:@"image/%@", imageType] beforeRequest:beforeRequest uploadProgressBlock:uploadProgressBlock complete:responseBlock];
}

/// downloadget的请求
+ (XDJDataEngine *)control:(NSObject *)control //control 释放时销毁当前请求
                       url:(NSString *)url //请求的url
                     param:(NSDictionary *)parameters //参数
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
          downloadProgress:(XDJDownloadProgressBlock)downloadProgressBlock //进度progress
                  complete:(XDJDownloadCompletionBlock)responseBlock
                   {
    XDJDataEngine *engine = [[XDJDataEngine alloc]init];
    
    __weak typeof(control) weakControl = control;
    __weak typeof(engine) weakEngine = engine;

        XDJBaseRequestDataModel *dataModel = [XDJBaseRequestDataModel downloadModelWithUrl:url param:parameters downloadProgress:downloadProgressBlock complete:^(NSString *path, NSURLResponse *response, NSError *error) {
                           
        if (responseBlock) {
            weakEngine.response = response;
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(path,response,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];

    }];
    [engine callRequestWithRequestModel:dataModel control:control needs:nil   beforeRequestBlock:beforeRequest];
    return engine;
} //结果block
#pragma mark - event response
#pragma mark - private methods

- (void)callRequestWithRequestModel:(XDJBaseRequestDataModel *)dataModel control:(NSObject *)control needs:(id<XDJRequestCommonNeedsDelegate,XDJReponseCommonNeedsDelegate>)needs  beforeRequestBlock:(void(^)(NSMutableURLRequest *request))beforeRequestBlock {
    if (!needs) {
        needs = __request_default_needs;
    }
    self.requestID = [[XDJHttpClient sharedInstance] callRequestWithRequestModel:dataModel needs:needs?needs:__request_default_needs beforeResume:beforeRequestBlock];
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}
#pragma mark - getters and setters
@end
