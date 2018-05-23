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

@property (nonatomic, strong) NSNumber *requestID;

@end
@implementation XDJDataEngine

+ (NSString *)server:(NSString *)host other:(NSString *)other {
    return [NSString stringWithFormat:@"%@%@",host,other];
}

#pragma mark - life cycle

//必须配置的方法！！！aClass 是 XDJBaseRequestDataModel 子类
+ (void)initializeWithErrorHandlerClass:(Class)aClass commonNeeds:(id<XDJRequestCommonNeedsDelegate>)needs {
        [[XDJHttpClient sharedInstance] registerErrorHandlerClass:aClass];
        [[XDJRequestGenerator shared] setNeeds:needs];

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
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
               requestType:(XDJRequestType)requestType
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
             progressBlock:(XDJProgressBlock)progressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    
    XDJDataEngine *engine = [[XDJDataEngine alloc]init];
    
    __weak typeof(control) weakControl = control;
    XDJBaseRequestDataModel *dataModel = [XDJBaseRequestDataModel dataModelWithUrl:url param:parameters dataFilePath:nil fileData:nil dataName:nil fileName:nil mimeType:nil requestType:requestType uploadProgressBlock:progressBlock downloadProgressBlock:nil complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    [engine callRequestWithRequestModel:dataModel control:control beforeRequestBlock:beforeRequest];
    return engine;
}


+ (XDJDataEngine *)control:(NSObject *)control
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
    XDJBaseRequestDataModel *dataModel = [XDJBaseRequestDataModel dataModelWithUrl:url param:parameters dataFilePath:nil fileData:fileData dataName:dataName fileName:fileName mimeType:mimeType requestType:XDJRequestTypePostUpload uploadProgressBlock:uploadProgressBlock downloadProgressBlock:nil  complete:^(id data, NSError *error) {
        if (responseBlock) {
            //可以在这里做错误的UI处理，或者是在上层engine做
            responseBlock(data,error);
        }
        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
    [engine callRequestWithRequestModel:dataModel control:control beforeRequestBlock:beforeRequest];
    return engine;
}


+ (XDJDataEngine *)control:(NSObject *)control
                       url:(NSString *)url
                     param:(NSDictionary *)parameters
                 imageData:(NSData *)imageData
                 imageType:(NSString *)imageType // @"gif" / @"jpg"
             beforeRequest:(void(^)(NSMutableURLRequest *request))beforeRequest
       uploadProgressBlock:(XDJProgressBlock)uploadProgressBlock
                  complete:(XDJCompletionDataBlock)responseBlock {
    return [self control:control url:url param:parameters fileData:imageData dataName:@"image" fileName:@"image" mimeType:[NSString stringWithFormat:@"image/%@", imageType] beforeRequest:beforeRequest uploadProgressBlock:uploadProgressBlock complete:responseBlock];
}
#pragma mark - event response
#pragma mark - private methods

- (void)callRequestWithRequestModel:(XDJBaseRequestDataModel *)dataModel control:(NSObject *)control beforeRequestBlock:(void(^)(NSMutableURLRequest *request))beforeRequestBlock {
    self.requestID = [[XDJHttpClient sharedInstance] callRequestWithRequestModel:dataModel beforeResume:beforeRequestBlock];
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}
#pragma mark - getters and setters
@end
